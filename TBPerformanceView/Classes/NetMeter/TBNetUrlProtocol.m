//
//  TBNetUrlProtocol.m
//  TBPerformanceView
//
//  Created by BinTong on 2019/4/9.
//

#import "TBNetUrlProtocol.h"
static NSString *const TBHTTP = @"TBHTTP";

@interface TBNetUrlProtocol() <NSURLConnectionDelegate, NSURLConnectionDataDelegate>

@property (strong, nonatomic) NSURLConnection *connection;
@property (strong, nonatomic) NSURLRequest *tb_request;
@property (strong, nonatomic) NSURLResponse *tb_response;
@property (strong, nonatomic) NSMutableData *tb_data;

@end

@implementation TBNetUrlProtocol

//+ (BOOL)canInitWithTask:(NSURLSessionTask *)task {
//
//}

+ (BOOL)canInitWithRequest:(NSURLRequest *)request {
    NSLog(@"TBNetUrlProtocol ==== %@",request.URL.absoluteString);
    if ([NSURLProtocol propertyForKey:TBHTTP inRequest:request]) {
        return NO;
    }
    if ([request.URL.scheme isEqualToString:@"http"] || [request.URL.scheme isEqualToString:@"https"]) {
        return YES;
    }
    return NO;
 }

+ (NSURLRequest *)canonicalRequestForRequest:(NSURLRequest *)request {
    NSMutableURLRequest *mutableReqeust = [request mutableCopy];
    [NSURLProtocol setProperty:@YES
                        forKey:TBHTTP
                     inRequest:mutableReqeust];
    return [mutableReqeust copy];
}

+ (BOOL)requestIsCacheEquivalent:(NSURLRequest *)a toRequest:(NSURLRequest *)b{
    return [super requestIsCacheEquivalent:a toRequest:b];
}

- (void)startLoading{
    NSURLRequest *request = [[self class] canonicalRequestForRequest:self.request];
    self.connection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];
    self.tb_request = request;
}

#pragma mark - NSURLConnectionDataDelegate

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    [[self client] URLProtocol:self didReceiveResponse:response cacheStoragePolicy:NSURLCacheStorageAllowed];
    self.tb_response = response;
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [self.client URLProtocol:self didLoadData:data];
    [self.tb_data appendData:data];
}

- (void) connectionDidFinishLoading:(NSURLConnection *)connection {
    [self.client URLProtocolDidFinishLoading:self];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    [self.client URLProtocol:self didFailWithError:error];
}


- (void)stopLoading{
    [self.connection cancel];
}


@end
