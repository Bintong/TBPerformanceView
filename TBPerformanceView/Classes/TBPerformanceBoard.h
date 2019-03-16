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


- (void)createPeroformanceBoardUpOnView:(UIView *)view ;

- (void)open;

- (void)close;

@end

NS_ASSUME_NONNULL_END
