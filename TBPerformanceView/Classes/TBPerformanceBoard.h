//
//  TBPerformanceBoard.h
//  TimeAndLoop
//
//  Created by BinTong on 2019/2/26.
//  Copyright © 2019 TongBin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TBPerformanceBoard : NSObject

+ (TBPerformanceBoard *)sharedInstance;


/**
 create Board On View

 @param view Up on view
 */
- (void)createPeroformanceBoardUpOnView:(UIView *)view ;

- (void)createPeroformanceWithDeviceInfo:(UIView *)view;

- (void)createClickPeroformanceWithDeviceInfo:(UIViewController *)ctr;


/**
 begin display link
 */
- (void)open;

/**
 stop display link
 */
- (void)close;

@end

NS_ASSUME_NONNULL_END
