//
//  TBNetMonitorUtil.m
//  TBPerformanceView
//
//  Created by BinTong on 2019/4/10.
//

#import "TBNetMonitorUtil.h"

@implementation TBNetMonitorUtil


+ (NSUInteger)getRequestLength:(NSURLRequest *)request{
 
    NSDictionary<NSString *, NSString *> *headerFields = request.allHTTPHeaderFields;
    NSDictionary<NSString *, NSString *> *cookiesHeader = [self getCookies:request];
    if (cookiesHeader.count) {
        NSMutableDictionary *headerFieldsWithCookies = [NSMutableDictionary dictionaryWithDictionary:headerFields];
        [headerFieldsWithCookies addEntriesFromDictionary:cookiesHeader];
        headerFields = [headerFieldsWithCookies copy];
    }
    
    NSUInteger headersLength = [self getHeadersLength:headerFields];
    NSData *httpBody = [self getHttpBodyFromRequest:request];
    NSUInteger bodyLength = [httpBody length];
    return headersLength + bodyLength;
}

+ (NSUInteger)getHeadersLength:(NSDictionary *)headers {
   
    NSUInteger headersLength = 0;
    if (headers) {
        NSData *data = [NSJSONSerialization dataWithJSONObject:headers
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:nil];
        headersLength = data.length;
    }
    
    return headersLength;
}


+ (NSDictionary<NSString *, NSString *> *)getCookies:(NSURLRequest *)request {
    if (request == nil) {
        return [NSDictionary dictionary];
    }
    NSDictionary<NSString *, NSString *> *cookiesHeader;
    NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    NSArray<NSHTTPCookie *> *cookies = [cookieStorage cookiesForURL:request.URL];
    if (cookies.count) {
        cookiesHeader = [NSHTTPCookie requestHeaderFieldsWithCookies:cookies];
    }
    return cookiesHeader;
}

+ (NSData *)getHttpBodyFromRequest:(NSURLRequest *)request{
    NSData *httpBody;
    if (request.HTTPBody) {
        httpBody = request.HTTPBody;
    }else{
        if ([request.HTTPMethod isEqualToString:@"POST"]) {
            if (!request.HTTPBody) {
                uint8_t d[1024] = {0};
                NSInputStream *stream = request.HTTPBodyStream;
                NSMutableData *data = [[NSMutableData alloc] init];
                [stream open];
                while ([stream hasBytesAvailable]) {
                    NSInteger len = [stream read:d maxLength:1024];
                    if (len > 0 && stream.streamError == nil) {
                        [data appendBytes:(void *)d length:len];
                    }
                }
                httpBody = [data copy];
                [stream close];
            }
        }
    }
    return httpBody;
}


+ (int64_t)getResponseLength:(NSURLSessionTask *)task {
   
    int64_t responseLength = 0;
    
    if (task.response) {
        int64_t contentLength = task.countOfBytesReceived;//sizeof();//task.countOfBytesReceived;
        responseLength = contentLength; //缺少 header
        if ([task.response.URL.absoluteString containsString:@"b7462b7a"]) {
            NSLog(@"responseLength is %f",responseLength);
        };
    }
    return responseLength;
}


//json
+ (NSString *)convertJsonFromData:(NSData *)data{
    if (!data) {
        return nil;
    }
    NSString *jsonString = nil;
    
    id jsonObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
    if ([NSJSONSerialization isValidJSONObject:jsonObject]) {
        jsonString = [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:jsonObject options:NSJSONWritingPrettyPrinted error:NULL] encoding:NSUTF8StringEncoding];
        // NSJSONSerialization escapes forward slashes. We want pretty json, so run through and unescape the slashes.
        jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\\/" withString:@"/"];
    } else {
        jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    }
    return jsonString;
}

@end
