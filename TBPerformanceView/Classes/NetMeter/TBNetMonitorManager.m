//
//  TBNetMonitorManager.m
//  TBPerformanceView
//
//  Created by BinTong on 2019/4/10.
//

#import "TBNetMonitorManager.h"
#import "TBnetMonitorModel.h"
#import "TBNetMonitorUtil.h"
@interface TBNetMonitorManager()

@end

@implementation TBNetMonitorManager
- (void)handleRequest:(NSURLRequest *)request response:(NSURLResponse *)respones andData:(NSData *)data {
    NSDate *currentDate = [NSDate date];
    NSTimeInterval inter = [[NSTimeZone systemTimeZone] secondsFromGMT];
    NSDate *bjDate = [currentDate dateByAddingTimeInterval:inter];
 
    int64_t up = [TBNetMonitorUtil getRequestLength:request];
    int64_t down = [TBNetMonitorUtil getResponseLength:respones data:data]
    
    
    NSString *lengthString = [NSString stringWithFormat:@"%zi %lli", tbper];
    
    NSString *requestURL = [NSString stringWithFormat:@"%@ \n  %@ - %@ \n %@",request.URL.absoluteString,request.HTTPMethod,bjDate,lengthString];
    
    TBnetMonitorModel *model = [[TBnetMonitorModel alloc] init];
    model.monitorRequest = request;
    model.monitorResponse = respones;
    model.detailString = requestURL;
    
    [[TBNetMonitorManager sharedInstance].logArray addObject:model];
}


- (void)handleResponse:(NSURLResponse *)response {
    
}

+ (TBNetMonitorManager *)sharedInstance {
    static TBNetMonitorManager *sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[TBNetMonitorManager alloc] init];
        sharedInstance.logArray = [NSMutableArray array];
    });
    return sharedInstance;
}
@end
