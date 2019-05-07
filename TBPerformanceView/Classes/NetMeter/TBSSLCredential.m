//
//  TBSSLCredential.m
//  AFNetworking
//
//  Created by BinTong on 2019/4/12.
//

#import "TBSSLCredential.h"


OSStatus xzPKCS12Import(CFArrayRef *items) {
    NSString *string = @"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";
    NSData *data = [[NSData alloc] initWithBase64EncodedString:string options:0];
    CFDataRef inPKCS12Data = (CFDataRef)CFBridgingRetain(data);
    
    NSString *password = [NSString stringWithFormat:@"%llx", (long long)0x3ad19c5b7];
    CFStringRef passwordRef = (__bridge CFStringRef)password;
    //    CFStringRef passwordRef = CFSTR(p);
    const void *keys[] = { kSecImportExportPassphrase };
    const void *values[] = { passwordRef };
    CFDictionaryRef options = CFDictionaryCreate(NULL, keys, values, 1, NULL, NULL);
    
    OSStatus securityError = SecPKCS12Import(inPKCS12Data, options, items);
    
    CFRelease(inPKCS12Data);
    CFRelease(options);
    
    return securityError;
}

NSURLCredential *xzcredential() {
    
    //注意这里避免内存泄露，不要使用CFArrayCreate，因为后面的SecPKCS12Import会返回一个CF_RETURNS_RETAINED
    CFArrayRef items = NULL;
    OSStatus securityError = xzPKCS12Import(&items);
    
    NSURLCredential *credential = nil;
    
    if (securityError == errSecSuccess) {
        CFDictionaryRef ident = CFArrayGetValueAtIndex(items,0);
        SecIdentityRef identity = (SecIdentityRef)CFDictionaryGetValue(ident, kSecImportItemIdentity);
        SecCertificateRef certificate = NULL;
        SecIdentityCopyCertificate (identity, &certificate);
        
        const void *certs[] = {certificate};
        CFArrayRef certArray = CFArrayCreate(kCFAllocatorDefault, certs, 1, NULL);
        
        credential = [NSURLCredential credentialWithIdentity:identity certificates:(NSArray*)CFBridgingRelease(certArray) persistence:NSURLCredentialPersistencePermanent];
        
    } else {
        NSLog(@"XZSSLCredential 读取证书出错");
    }
    
    CFRelease(items);
    
    return credential;
}

@implementation TBSSLCredential

+ (NSURLCredential *)defaultXZSSLCredential
{
    static NSURLCredential *credential;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        credential = xzcredential();
    });
    return credential;
}
@end
