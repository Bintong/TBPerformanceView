//
//  TBInternalRequestState.h
//  TBPerformanceView
//
//  Created by BinTong on 2019/5/2.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TBInternalRequestState : NSObject

@property (nonatomic, copy) NSURLRequest *request;

@property (nonatomic, strong, nullable) NSMutableData *dataAccumulator;

@end

NS_ASSUME_NONNULL_END
