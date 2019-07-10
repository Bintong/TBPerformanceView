//
//  NSDate+TZDateString.h
//  disUser
//
//  Created by YXY on 2019/1/29.
//  Copyright © 2019 songshupinpin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDate (TZDateString)

/**
 yyyy-MM-dd HH:mm

 @param date date
 @return string with yyyy-MM-dd HH:mm
 */
+ (NSString *)stringWithYearMonthDayHourMinusWithDate:(NSDate *)date;

//yyyy-MM-dd
+ (NSString *)stringWithYearMonthDayWithDate:(NSDate *)date;

//MM-dd
+ (NSString *)stringWithMonthDayWithDate:(NSDate *)date;

//yyyy年mm月
+ (NSString *)stringWithYearMonthAsChineseWithDate:(NSDate *)date;

//yyyy年MM月dd日
+ (NSString *)stringWithYearMonthDayAsChineseWithDate:(NSDate *)date;
//MM月dd日
+ (NSString *)stringWithMonthDayAsChineseWithDate:(NSDate *)date;
//MM月dd日 HH:mm
+ (NSString *)stringWithMonthHHMMDayAsChineseWithDate:(NSDate *)date;
//获取date间隔month月份的日期
+ (NSDate *)getDateIntervalMonth:(NSInteger)month WithDate:(NSDate *)date;

+ (NSString *)stringWithYearMonthDayHourMinusSecondsWithDate:(NSDate *)date;

//timefrom string
+ (NSTimeInterval)timeFromString:(NSString *)timeStr format:(NSString *)formatStr;

@end

NS_ASSUME_NONNULL_END
