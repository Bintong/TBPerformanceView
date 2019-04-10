//
//  TBPerformanceUtils.m
//  TBPerformanceView
//
//  Created by BinTong on 2019/4/10.
//

#import "TBPerformanceUtils.h"

@implementation TBPerformanceUtils

// byte格式化为
+ (NSString *)formatByte:(CGFloat)byte{
    double convertedValue = byte;
    int multiplyFactor = 0;
    NSArray *tokens = [NSArray arrayWithObjects:@"B",@"KB",@"MB",@"GB",@"TB",nil];
    
    while (convertedValue > 1024) {
        convertedValue /= 1024;
        multiplyFactor++;
    }
    return [NSString stringWithFormat:@"%4.2f%@",convertedValue, [tokens objectAtIndex:multiplyFactor]]; ;
}

@end
