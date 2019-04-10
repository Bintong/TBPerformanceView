//
//  TBNetUrlProtocol.m
//  TBPerformanceView
//
//  Created by BinTong on 2019/4/9.
//

#import "TBNetUrlProtocol.h"
#import <objc/runtime.h>
#import "TBNetMonitorManager.h"
static NSString *const TBHTTP = @"TBHTTP";
static id<TBNetworkLoggerInfoDelegate> _info_delegate;

@interface TBNetUrlProtocol() <NSURLConnectionDelegate, NSURLConnectionDataDelegate>

@property (strong, nonatomic) NSURLConnection *connection;
@property (strong, nonatomic) NSURLRequest *tb_request;
@property (strong, nonatomic) NSURLResponse *tb_response;
@property (strong, nonatomic) NSMutableData *tb_data;



@end

@implementation TBNetUrlProtocol

+ (id<TBNetworkLoggerInfoDelegate>)info_delegate {
    return _info_delegate;
}

+ (void)setInfo_delegate:(id<TBNetworkLoggerInfoDelegate>)info_delegate{
    _info_delegate = info_delegate;
}
//+ (BOOL)canInitWithTask:(NSURLSessionTask *)task {
//
//}

+ (BOOL)canInitWithRequest:(NSURLRequest *)request {
    if ([NSURLProtocol propertyForKey:TBHTTP inRequest:request]) {
        return NO;
    }
    if ([request.URL.scheme isEqualToString:@"http"] || [request.URL.scheme isEqualToString:@"https"]) {
        NSLog(@"TBNetUrlProtocol ==== %@",request.URL.absoluteString);
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
    
//    if ([_info_delegate respondsToSelector:@selector(callbackSendNetWorkData:request:respones:)]) {
//        [_info_delegate callbackSendNetWorkData:_tb_request.allHTTPHeaderFields request:_tb_request respones:_tb_response];
//
//    }
    [[TBNetMonitorManager sharedInstance] handleRequest:self.tb_request response:self.tb_response andData:_tb_data];
    
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    [self.client URLProtocol:self didFailWithError:error];
}

- (void)stopLoading{
    [self.connection cancel];
}
 

#warning inject
+ (void)injectNSURLSessionConfiguration{
    Class cls = NSClassFromString(@"__NSCFURLSessionConfiguration") ?: NSClassFromString(@"NSURLSessionConfiguration");
    Method originalMethod = class_getInstanceMethod(cls, @selector(protocolClasses));
    Method stubMethod = class_getInstanceMethod([self class], @selector(protocolClasses));
    if (!originalMethod || !stubMethod) {
        [NSException raise:NSInternalInconsistencyException format:@"Couldn't load NEURLSessionConfiguration."];
    }
    method_exchangeImplementations(originalMethod, stubMethod);
}

- (NSArray *)protocolClasses {
    return @[[TBNetUrlProtocol class]];
}

@end
