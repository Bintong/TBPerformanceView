//
//  TBDeviceInfo.m
//  Pods-TBPerformanceView_Example
//
//  Created by BinTong on 2019/3/17.
//

#import "TBDeviceInfo.h"

@implementation TBDeviceInfo

+ (NSString *)applicationVersion {
    return appInfoDictionary()[@"CFBundleShortVersionString"];

}

+ (NSString *)phoneSystemVersion {
    return [currentDevice() systemVersion];
}

+ (CGFloat)batteryLevel {
    currentDevice().batteryMonitoringEnabled = YES;
    return [currentDevice() batteryLevel];
}

@end
