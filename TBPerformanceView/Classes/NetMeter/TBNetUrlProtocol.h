//
//  TBNetUrlProtocol.h
//  TBPerformanceView
//
//  Created by BinTong on 2019/4/9.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol TBNetworkLoggerInfoDelegate <NSObject>

- (void)callbackSendNetWorkData:(NSDictionary *)parameter request:(NSURLRequest *)request respones:(NSURLResponse *)response;


@end

@interface TBNetUrlProtocol : NSURLProtocol

@property (class,nonatomic, weak) id<TBNetworkLoggerInfoDelegate> info_delegate;

+ (void)injectNSURLSessionConfiguration;

@end

NS_ASSUME_NONNULL_END
