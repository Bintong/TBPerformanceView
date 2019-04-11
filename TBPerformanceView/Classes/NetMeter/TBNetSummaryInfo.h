//
//  TBNetSummaryInfo.h
//  TBPerformanceView
//
//  Created by BinTong on 2019/4/10.
//

#import <Foundation/Foundation.h>
#import "TBnetMonitorModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface TBNetSummaryInfo : NSObject

@property (strong, nonatomic) NSArray *reqestModels;

/**
 请求次数
 */
@property (assign,nonatomic) NSInteger summaryNum;

/**
 总流量
 */
@property (copy,nonatomic) NSString *totalsFlow;

/**
 总请求流量
 */
@property (copy,nonatomic) NSString *requestFlow;

/**
 总返回流量
 */
@property (copy,nonatomic) NSString *responseFlow;


/**
 总错误流量
 */
@property (copy,nonatomic) NSString *errorNum;

@end

NS_ASSUME_NONNULL_END
