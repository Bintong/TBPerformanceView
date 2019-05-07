//
//  TBNetSessionProtocol.m
//  TBPerformanceView
//
//  Created by BinTong on 2019/4/11.
//

#import "TBNetSessionProtocol.h"
#import <objc/runtime.h>
#import "TBSSLCredential.h"
static NSString * const HJHTTPHandledIdentifier = @"hujiang_http_handled";


@interface TBNetSessionProtocol ()<NSURLSessionTaskDelegate, NSURLSessionDataDelegate>

@property (nonatomic, strong) NSURLSessionDataTask *dataTask;
@property (nonatomic, strong) NSOperationQueue     *sessionDelegateQueue;
@property (nonatomic, strong) NSURLResponse        *response;
@property (nonatomic, strong) NSMutableData        *data;
@property (nonatomic, strong) NSDate               *startDate;
//@property (nonatomic, strong) HJHTTPModel          *httpModel;

@end
@implementation TBNetSessionProtocol
+ (BOOL)canInitWithRequest:(NSURLRequest *)request {

    if (![request.URL.scheme isEqualToString:@"http"] &&
        ![request.URL.scheme isEqualToString:@"https"]) {
        return NO;
    }
    
    if ([NSURLProtocol propertyForKey:HJHTTPHandledIdentifier inRequest:request] ) {
        return NO;
    }
    NSLog(@"protocol url begin is %@",request.URL.absoluteString);

    return YES;
}

+ (NSURLRequest *)canonicalRequestForRequest:(NSURLRequest *)request {
    
    NSMutableURLRequest *mutableReqeust = [request mutableCopy];
    NSLog(@"protocol url begin is %@",request.URL.absoluteString);
    [NSURLProtocol setProperty:@YES
                        forKey:HJHTTPHandledIdentifier
                     inRequest:mutableReqeust];
    return [mutableReqeust copy];
}
//hook
+ (void)exchangeNSURLSessionConfiguration{
    Class cls = NSClassFromString(@"__NSCFURLSessionConfiguration") ?: NSClassFromString(@"NSURLSessionConfiguration");
    Method originalMethod = class_getInstanceMethod(cls, @selector(protocolClasses));
    Method stubMethod = class_getInstanceMethod([self class], @selector(protocolClasses));
    if (!originalMethod || !stubMethod) {
        [NSException raise:NSInternalInconsistencyException format:@"Couldn't load NEURLSessionConfiguration."];
    }
    method_exchangeImplementations(originalMethod, stubMethod);
}

- (NSArray *)protocolClasses{
    //此处不可以使用self，方法替换后self是URLSessionConfigration
    return @[[TBNetSessionProtocol class]];
}

- (void)startLoading {
    self.startDate                                        = [NSDate date];
    self.data                                             = [NSMutableData data];
    NSURLSessionConfiguration *configuration              = [NSURLSessionConfiguration defaultSessionConfiguration];
    configuration.protocolClasses = @[TBNetSessionProtocol.class];
    self.sessionDelegateQueue                             = [[NSOperationQueue alloc] init];
    self.sessionDelegateQueue.maxConcurrentOperationCount = 1;
    self.sessionDelegateQueue.name                        = @"com.hujiang.wedjat.session.queue";
    NSURLSession *session                                 = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:self.sessionDelegateQueue];
    self.dataTask                                         = [session dataTaskWithRequest:self.request];
    [self.dataTask resume];
    
//    httpModel                                             = [[NEHTTPModel alloc] init];
//    httpModel.request                                     = self.request;
//    httpModel.startDateString                             = [self stringWithDate:[NSDate date]];
    
    NSTimeInterval myID                                   = [[NSDate date] timeIntervalSince1970];
    double randomNum                                      = ((double)(arc4random() % 100))/10000;
//    httpModel.myID                                        = myID+randomNum;
}

- (void)stopLoading {
    [self.dataTask cancel];
    self.dataTask           = nil;
//    httpModel.response      = (NSHTTPURLResponse *)self.response;
//    httpModel.endDateString = [self stringWithDate:[NSDate date]];
    NSString *mimeType      = self.response.MIMEType;
    
    // 解析 response，流量统计等
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential *credential))completionHandler {
//    assert([NSThread currentThread] == );
    //判断服务器返回的证书类型, 是否是服务器信任
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
        //强制信任
        NSURLCredential *card = [TBSSLCredential defaultXZSSLCredential];//[[NSURLCredential alloc]initWithTrust:challenge.protectionSpace.serverTrust];
        completionHandler(NSURLSessionAuthChallengeUseCredential, card);
    }
}

#pragma mark - NSURLSessionTaskDelegate

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {
    if (!error) {
        [self.client URLProtocolDidFinishLoading:self];
    } else if ([error.domain isEqualToString:NSURLErrorDomain] && error.code == NSURLErrorCancelled) {
    } else {
        [self.client URLProtocol:self didFailWithError:error];
    }
    self.dataTask = nil;
}

#pragma mark - NSURLSessionDataDelegate

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data {
    [self.client URLProtocol:self didLoadData:data];
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler {
    [[self client] URLProtocol:self didReceiveResponse:response cacheStoragePolicy:NSURLCacheStorageAllowed];
    completionHandler(NSURLSessionResponseAllow);
//    NSLog(@"protocol url : %@",response.URL.absoluteString);
    self.response = response;
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task willPerformHTTPRedirection:(NSHTTPURLResponse *)response newRequest:(NSURLRequest *)request completionHandler:(void (^)(NSURLRequest * _Nullable))completionHandler {
    if (response != nil){
        self.response = response;
        [[self client] URLProtocol:self wasRedirectedToRequest:request redirectResponse:response];
    }
}

@end
