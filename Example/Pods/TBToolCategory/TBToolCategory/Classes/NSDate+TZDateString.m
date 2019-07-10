//
//  NSDate+TZDateString.m
//  disUser
//
//  Created by YXY on 2019/1/29.
//  Copyright © 2019 songshupinpin. All rights reserved.
//

#import "NSDate+TZDateString.h"
#import "TZDateFormatter.h"

@implementation NSDate (TZDateString)

+ (NSTimeInterval)timeFromString:(NSString *)timeStr format:(NSString *)formatStr {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:formatStr];
    NSDate *date = [dateFormatter dateFromString:timeStr];
    NSTimeInterval interval = [date timeIntervalSince1970];
    return interval;
}
+ (NSString *)stringWithYearMonthDayHourMinusSecondsWithDate:(NSDate *)date{
    if (!date) {
        return @"";
    }
    NSString *dateString = [[TZDateFormatter shareYearMonthDayAndHourMinutesSecondsFormatter] stringFromDate:date];
    if (dateString.length <= 0) {
        return @"";
    }
    return dateString;
}

+ (NSString *)stringWithYearMonthDayHourMinusWithDate:(NSDate *)date
{
    if (!date) {
        return @"";
    }
    NSString *dateString = [[TZDateFormatter shareYearMonthDayAndHourMinutesFormatter] stringFromDate:date];
    if (dateString.length <= 0) {
        return @"";
    }
    return dateString;
}

+ (NSString *)stringWithYearMonthDayWithDate:(NSDate *)date
{
    if (!date) {
        return @"";
    }
    NSString *dateString = [[TZDateFormatter shareYearMonthDayFormatter] stringFromDate:date];
    if (dateString.length <= 0) {
        return @"";
    }
    return dateString;
}

+ (NSString *)stringWithMonthDayWithDate:(NSDate *)date
{
    if (!date) {
        return @"";
    }
    NSString *dateString = [[TZDateFormatter shareMonthDayFormatter] stringFromDate:date];
    if (dateString.length <= 0) {
        return @"";
    }
    return dateString;
}

+ (NSString *)stringWithYearMonthAsChineseWithDate:(NSDate *)date
{
    if (!date) {
        return @"";
    }
    NSString *dateString = [[TZDateFormatter shareYearMonthAsChineseFormatter] stringFromDate:date];
    if (dateString.length <= 0) {
        return @"";
    }
    return dateString;
}

+ (NSString *)stringWithYearMonthDayAsChineseWithDate:(NSDate *)date
{
    if (!date) {
        return @"";
    }
    NSString *dateString = [[TZDateFormatter shareYearMonthDayAsChineseFormatter] stringFromDate:date];
    if (dateString.length <= 0) {
        return @"";
    }
    return dateString;
}
+ (NSString *)stringWithMonthDayAsChineseWithDate:(NSDate *)date
{
    if (!date) {
        return @"";
    }
    NSString *dateString = [[TZDateFormatter shareMonthDayAsChineseFormatter] stringFromDate:date];
    if (dateString.length <= 0) {
        return @"";
    }
    return dateString;
}

+ (NSString *)stringWithMonthHHMMDayAsChineseWithDate:(NSDate *)date
{
    if (!date) {
        return @"";
    }
    NSString *dateString = [[TZDateFormatter shareMonthDayHHMMAsChineseFormatter] stringFromDate:date];
    if (dateString.length <= 0) {
        return @"";
    }
    return dateString;
}


+ (NSDate *)getDateIntervalMonth:(NSInteger)month WithDate:(NSDate *)date
{
    NSDateComponents *compinents = [[NSDateComponents alloc] init];
    [compinents setMonth:month];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDate *newDate = [calendar dateByAddingComponents:compinents toDate:date options:0];
    NSDate *nowDate = [NSDate date];
    if ([newDate timeIntervalSinceDate:nowDate] > 0) {
        return nowDate;
    }
    return newDate;
}

@end
