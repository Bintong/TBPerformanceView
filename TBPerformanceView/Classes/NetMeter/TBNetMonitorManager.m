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

- (void)handleRequest:(NSURLRequest *)request task:(NSURLSessionTask *)task andData:(NSData *)data {
    
    if (![request.URL.absoluteString containsString:@"amazonaws"]) {
        NSDate *currentDate = [NSDate date];
        NSTimeInterval inter = [[NSTimeZone systemTimeZone] secondsFromGMT];
        NSDate *bjDate = [currentDate dateByAddingTimeInterval:inter];
        
        int64_t up = [TBNetMonitorUtil getRequestLength:request];
        int64_t down = [TBNetMonitorUtil getResponseLength:task];
        
        [TBPerformanceUtils formatByte:up];
        
        NSString *lengthString = [NSString stringWithFormat:@"↑%@ | ↓%@",[TBPerformanceUtils formatByte:up],[TBPerformanceUtils formatByte:down]];
        //url
        
        NSString *sortUrl =  [request.URL.absoluteString substringFromIndex:request.URL.absoluteString.length - 20];
        NSString *requestURL = [NSString stringWithFormat:@"%@ \n  %@ - %@ \n %@", sortUrl,request.HTTPMethod,bjDate,lengthString];
        
        TBnetMonitorModel *model = [[TBnetMonitorModel alloc] init];
        model.monitorRequest = request;
        model.monitorResponse = task.response;
        model.detailString = requestURL;
        model.monitorResponseData = [NSData dataWithData:data];
        model.upFlow = up;
        model.dowmFlow = down;
        [[TBNetMonitorManager sharedInstance].logArray addObject:model];
    }
    

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
