//
//  CheckLayerManager.h
//  TBPerformanceView
//
//  Created by BinTong on 2019/3/28.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CheckLayerManager : NSObject

+ (CheckLayerManager *)shareInstance;

- (void)show;

- (void)hidden;

@end

NS_ASSUME_NONNULL_END
