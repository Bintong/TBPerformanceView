//
//  TZDateFormatter.h
//  disUser
//
//  Created by YXY on 2019/1/29.
//  Copyright © 2019 songshupinpin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TZDateFormatter : NSObject
//yyyy-MM-dd HH:mm:ss

+ (NSDateFormatter *)shareYearMonthDayAndHourMinutesSecondsFormatter;

//yyyy-MM-dd HH:mm
+ (NSDateFormatter *)shareYearMonthDayAndHourMinutesFormatter;

//yyyy-MM-dd
+ (NSDateFormatter *)shareYearMonthDayFormatter;

//MM-dd
+ (NSDateFormatter *)shareMonthDayFormatter;

//yyyy年mm月
+ (NSDateFormatter *)shareYearMonthAsChineseFormatter;

//yyyy年MM月dd日
+ (NSDateFormatter *)shareYearMonthDayAsChineseFormatter;

//MM月dd日
+ (NSDateFormatter *)shareMonthDayAsChineseFormatter;
//MM月dd日 HH:mm
+ (NSDateFormatter *)shareMonthDayHHMMAsChineseFormatter;
@end

NS_ASSUME_NONNULL_END
