//
//  TBnetMonitorModel.h
//  TBPerformanceView
//
//  Created by BinTong on 2019/4/10.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TBnetMonitorModel : NSObject

@property (strong, nonatomic) NSURLResponse *monitorResponse;
@property (strong, nonatomic) NSURLRequest *monitorRequest;
@property (copy,nonatomic)NSString *detailString;

@end

NS_ASSUME_NONNULL_END
