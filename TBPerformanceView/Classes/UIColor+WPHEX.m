//
//  UIColor+WPHEX.m
//  BMWorkVisitor_Example
//
//  Created by BinTong on 2018/5/7.
//  Copyright © 2018年 yaxun_123@163.com. All rights reserved.
//

#import "UIColor+WPHEX.h"

#define DEFAULTCOLOR   [UIColor clearColor]


@implementation UIColor (WPHEX)

+ (UIColor *)colorHexString:(NSString *)hex {
    
    return [UIColor colorHexString:hex alpha:1.0f];
}
    
+ (UIColor *)colorHexString:(NSString *)hex alpha:(CGFloat)alpha {
    
    NSCharacterSet *character = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    NSString *cString = [[hex stringByTrimmingCharactersInSet:character] uppercaseString];
    
    if ([cString length] < 6)
    {
        return DEFAULTCOLOR;
    }
    
    if ([cString hasPrefix:@"#"])
    {
        cString = [cString substringFromIndex:1];
    }
    
    if ([cString length] != 6)
    {
        return DEFAULTCOLOR;
    }
    
    NSRange range;
    
    range.location = 0;
    range.length = 2;
    
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    
    NSString *bString = [cString substringWithRange:range];
    
    unsigned int r, g, b;
    
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    if (alpha < 0.0f || 1.0f < alpha)
    {
        alpha = 1.0f;
    }
    
    return [UIColor colorWithRed:((CGFloat)r/255.0f) green:((CGFloat)g/255.0f) blue:((CGFloat)b/255.0f) alpha:alpha];
}
    
@end
