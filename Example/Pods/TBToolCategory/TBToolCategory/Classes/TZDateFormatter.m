//
//  TZDateFormatter.m
//  disUser
//
//  Created by YXY on 2019/1/29.
//  Copyright © 2019 songshupinpin. All rights reserved.
//

#import "TZDateFormatter.h"

@implementation TZDateFormatter
+ (NSDateFormatter *)shareYearMonthDayAndHourMinutesSecondsFormatter{
    static NSDateFormatter *dateFormmterA = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dateFormmterA = [[NSDateFormatter alloc] init];
        dateFormmterA.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    });
    return dateFormmterA;
}

+ (NSDateFormatter *)shareYearMonthDayAndHourMinutesFormatter
{
    static NSDateFormatter *dateFormmterA = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dateFormmterA = [[NSDateFormatter alloc] init];
        dateFormmterA.dateFormat = @"yyyy-MM-dd HH:mm";
    });
    return dateFormmterA;
}

+ (NSDateFormatter *)shareYearMonthDayFormatter
{
    static NSDateFormatter *dateFormmterB = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dateFormmterB = [[NSDateFormatter alloc] init];
        dateFormmterB.dateFormat = @"yyyy-MM-dd";
    });
    return dateFormmterB;
}

+ (NSDateFormatter *)shareMonthDayFormatter
{
    static NSDateFormatter *dateFormmterC = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dateFormmterC = [[NSDateFormatter alloc] init];
        dateFormmterC.dateFormat = @"MM-dd";
    });
    return dateFormmterC;
}

+ (NSDateFormatter *)shareYearMonthAsChineseFormatter
{
    static NSDateFormatter *dateFormmterD = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dateFormmterD = [[NSDateFormatter alloc] init];
        dateFormmterD.dateFormat = @"yyyy年MM月";
    });
    return dateFormmterD;
}

+ (NSDateFormatter *)shareYearMonthDayAsChineseFormatter
{
    static NSDateFormatter *dateFormmterE = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dateFormmterE = [[NSDateFormatter alloc] init];
        dateFormmterE.dateFormat = @"yyyy年MM月dd日";
    });
    return dateFormmterE;
}

+ (NSDateFormatter *)shareMonthDayAsChineseFormatter
{
    static NSDateFormatter *dateFormmterE = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dateFormmterE = [[NSDateFormatter alloc] init];
        dateFormmterE.dateFormat = @"MM月dd日";
    });
    return dateFormmterE;
}

+ (NSDateFormatter *)shareMonthDayHHMMAsChineseFormatter
{
    static NSDateFormatter *dateFormmterE = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dateFormmterE = [[NSDateFormatter alloc] init];
        dateFormmterE.dateFormat = @"MM月dd日HH:mm";
    });
    return dateFormmterE;
}

@end
