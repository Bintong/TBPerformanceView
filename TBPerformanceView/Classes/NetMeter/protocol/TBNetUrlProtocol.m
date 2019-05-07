//
//  TBNetUrlProtocol.m
//  TBPerformanceView
//
//  Created by BinTong on 2019/4/9.
//

#import "TBNetUrlProtocol.h"
#import <objc/runtime.h>
#import "TBNetMonitorManager.h"

#import "TBDeviceInfo.h"
#import "TBSSLCredential.h"
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
    self.tb_data = [NSMutableData data];
}

#pragma mark - NSURLConnectionDataDelegate

//- (void)connection:(NSURLConnection *)connection willSendRequestForAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
//    // 判断是否是信任服务器证书
//    if(challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust) {
//        // 告诉服务器，客户端信任证书
//        // 创建凭据对象
//        NSURLCredential *credntial = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
//        // 告诉服务器信任证书
//        [challenge.sender useCredential:credntial forAuthenticationChallenge:challenge];
//    }
//}

- (BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace {
    
    return [protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust];
}

- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
//
//    NSBundle *bundle = [NSBundle bundleForClass:[TBDeviceInfo class]];
//    NSURL *bundleURL = [bundle URLForResource:@"TBPerformanceView" withExtension:@"bundle"];
//    NSString *certPath = [[NSBundle bundleWithURL:bundleURL] pathForResource:@"xiaozhu" ofType:@"cer"];
//

    NSURLCredential *ce = [TBSSLCredential defaultXZSSLCredential];
    [[challenge sender] useCredential:ce forAuthenticationChallenge:challenge];
    
    return;
    // 提取二进制内容
    NSData *derCA = [TBSSLCredential defaultXZSSLCredential];//NSData dataWithContentsOfFile:certPath];
    
    // 根据二进制内容提取证书信息
    SecCertificateRef caRef = SecCertificateCreateWithData(NULL, (__bridge CFDataRef)derCA);
    // 形成钥匙链
    NSArray * chain = [NSArray arrayWithObject:(__bridge id)(caRef)];
    
    CFArrayRef caChainArrayRef = CFBridgingRetain(chain);
    
    // 取出服务器证书
    SecTrustRef trust = [[challenge protectionSpace] serverTrust];
    
    SecTrustResultType trustResult = 0;
    // 设置为我们自有的CA证书钥匙连
    int err = SecTrustSetAnchorCertificates(trust, caChainArrayRef);
    if (err == noErr) {
        // 用CA证书验证服务器证书
        err = SecTrustEvaluate(trust, &trustResult);
    }
    CFRelease(trust);
    // 检查结果
    BOOL trusted = (err == noErr) && ((trustResult == kSecTrustResultProceed)||(trustResult == kSecTrustResultConfirm) || (trustResult == kSecTrustResultUnspecified));
    if (trusted) {
        [challenge.sender useCredential:[NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust] forAuthenticationChallenge:challenge];
    } else {
        [challenge.sender cancelAuthenticationChallenge:challenge];
    }
    
}

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
