//
//  TBNetMonitorManager.h
//  TBPerformanceView
//
//  Created by BinTong on 2019/4/10.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TBNetMonitorManager : NSObject

@property (strong, nonatomic) NSMutableArray *logArray;

+ (TBNetMonitorManager *)sharedInstance;

- (void)handleRequest:(NSURLRequest *)request response:(NSURLResponse *)respones;


@end

NS_ASSUME_NONNULL_END
