//
//  TBNetSummaryInfo.m
//  TBPerformanceView
//
//  Created by BinTong on 2019/4/10.
//

#import "TBNetSummaryInfo.h"
#import "TBnetMonitorModel.h"
@implementation TBNetSummaryInfo




- (void)setReqestModels:(NSArray *)reqestModels {
    _reqestModels = reqestModels;
    
    _summaryNum = reqestModels.count;
    float total_u_f = 0;
    float total_d_f = 0;
    for (TBnetMonitorModel *m in reqestModels) {
        total_u_f += m.upFlow;
        total_d_f += m.dowmFlow;
    }
    _requestFlow = [TBPerformanceUtils formatByte:total_u_f];
    _responseFlow = [TBPerformanceUtils formatByte:total_d_f];
    
    _totalsFlow = [TBPerformanceUtils formatByte:(total_u_f + total_d_f)];
    
}
@end
