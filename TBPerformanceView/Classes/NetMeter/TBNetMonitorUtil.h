//
//  TBNetMonitorUtil.h
//  TBPerformanceView
//
//  Created by BinTong on 2019/4/10.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TBNetMonitorUtil : NSObject

+ (int64_t)getResponseLength:(NSURLSessionTask *)task;

+ (NSUInteger)getRequestLength:(NSURLRequest *)request;


+ (NSString *)convertJsonFromData:(NSData *)data;
@end

NS_ASSUME_NONNULL_END
