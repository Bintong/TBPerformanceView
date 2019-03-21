//
//  TBDeviceInfo.h
//  Pods-TBPerformanceView_Example
//
//  Created by BinTong on 2019/3/17.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface TBDeviceInfo : NSObject


/**
 应用版本号
 
 @return 应用版本号
 */
+ (NSString *)applicationVersion;

/**
 系统版本号
 
 @return 系统版本号
 */
+ (NSString *)phoneSystemVersion;


/**
 电池状态
 
 @return 电池状态
 */
+ (CGFloat)batteryLevel;

@end

NS_INLINE NSDictionary * appInfoDictionary (void){
    
    return [[NSBundle mainBundle] infoDictionary];
}

NS_INLINE UIDevice * currentDevice (void){
    
    return [UIDevice currentDevice];
}
