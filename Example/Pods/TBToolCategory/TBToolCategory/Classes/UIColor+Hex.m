//
//  UIColor+Hex.m
//  MobileSale
//
//  Created by tongbin on 15/12/22.
//  Copyright © 2015年 MobileSale. All rights reserved.
//

#import "UIColor+Hex.h"

#define DEFAULTCOLOR   [UIColor clearColor]

@implementation UIColor (Hex)

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

CGFloat sd_colorComponentFrom(NSString *string, NSUInteger start, NSUInteger length) {
    NSString *substring = [string substringWithRange:NSMakeRange(start, length)];
    NSString *fullHex = length == 2 ? substring : [NSString stringWithFormat: @"%@%@", substring, substring];
    
    unsigned hexComponent;
    [[NSScanner scannerWithString: fullHex] scanHexInt: &hexComponent];
    return hexComponent / 255.0;
}


 
+ (UIColor *)sd_colorWithHex:(UInt32)hex{
    return [UIColor sd_colorWithHex:hex andAlpha:1];
}
+ (UIColor *)sd_colorWithHex:(UInt32)hex andAlpha:(CGFloat)alpha{
    return [UIColor colorWithRed:((hex >> 16) & 0xFF)/255.0
                           green:((hex >> 8) & 0xFF)/255.0
                            blue:(hex & 0xFF)/255.0
                           alpha:alpha];
}

+ (UIColor *)sd_colorWithHexString:(NSString *)hexString {
    CGFloat alpha, red, blue, green;
    
    NSString *colorString = [[hexString stringByReplacingOccurrencesOfString:@"#" withString:@""] uppercaseString];
    switch ([colorString length]) {
        case 3: // #RGB
            alpha = 1.0f;
            red   = sd_colorComponentFrom(colorString, 0, 1);
            green = sd_colorComponentFrom(colorString, 1, 1);
            blue  = sd_colorComponentFrom(colorString, 2, 1);
            break;
            
        case 4: // #ARGB
            alpha = sd_colorComponentFrom(colorString, 0, 1);
            red   = sd_colorComponentFrom(colorString, 1, 1);
            green = sd_colorComponentFrom(colorString, 2, 1);
            blue  = sd_colorComponentFrom(colorString, 3, 1);
            break;
            
        case 6: // #RRGGBB
            alpha = 1.0f;
            red   = sd_colorComponentFrom(colorString, 0, 2);
            green = sd_colorComponentFrom(colorString, 2, 2);
            blue  = sd_colorComponentFrom(colorString, 4, 2);
            break;
            
        case 8: // #AARRGGBB
            alpha = sd_colorComponentFrom(colorString, 0, 2);
            red   = sd_colorComponentFrom(colorString, 2, 2);
            green = sd_colorComponentFrom(colorString, 4, 2);
            blue  = sd_colorComponentFrom(colorString, 6, 2);
            break;
            
        default:
            return nil;
    }
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

- (NSString *)sd_HEXString{
    UIColor* color = self;
    if (CGColorGetNumberOfComponents(color.CGColor) < 4) {
        const CGFloat *components = CGColorGetComponents(color.CGColor);
        color = [UIColor colorWithRed:components[0]
                                green:components[0]
                                 blue:components[0]
                                alpha:components[1]];
    }
    if (CGColorSpaceGetModel(CGColorGetColorSpace(color.CGColor)) != kCGColorSpaceModelRGB) {
        return [NSString stringWithFormat:@"#FFFFFF"];
    }
    return [NSString stringWithFormat:@"#%02X%02X%02X", (int)((CGColorGetComponents(color.CGColor))[0]*255.0),
            (int)((CGColorGetComponents(color.CGColor))[1]*255.0),
            (int)((CGColorGetComponents(color.CGColor))[2]*255.0)];
}

+ (UIColor *)sd_colorWithWholeRed:(CGFloat)red
                            green:(CGFloat)green
                             blue:(CGFloat)blue
                            alpha:(CGFloat)alpha
{
    return [UIColor colorWithRed:red/255.f
                           green:green/255.f
                            blue:blue/255.f
                           alpha:alpha];
}

+ (UIColor *)sd_colorWithWholeRed:(CGFloat)red
                            green:(CGFloat)green
                             blue:(CGFloat)blue
{
    return [self sd_colorWithWholeRed:red
                                green:green
                                 blue:blue
                                alpha:1.0];
}


+ (CAGradientLayer *)setGradualChangingColor:(UIView *)view fromColor:(UIColor *)fromHexColorStr toColor:(UIColor *)toHexColorStr{
    //    CAGradientLayer类对其绘制渐变背景颜色、填充层的形状(包括圆角)
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = view.bounds;
    //  创建渐变色数组，需要转换为CGColor颜色
    gradientLayer.colors = @[(__bridge id)fromHexColorStr.CGColor,(__bridge id)toHexColorStr.CGColor];
    //  设置渐变颜色方向，左上点为(0,0), 右下点为(1,1)
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(1, 1);
    //  设置颜色变化点，取值范围 0.0~1.0
    gradientLayer.locations = @[@0,@1];
    
    return gradientLayer;
}

+ (instancetype)sd_colorGradientChangeWithSize:(CGSize)size
                                     direction:(SDGradientChangeDirection)direction
                                    startColor:(UIColor *)startcolor
                                      endColor:(UIColor *)endColor {
    if (CGSizeEqualToSize(size, CGSizeZero) || !startcolor || !endColor) {
        return nil;
    }
    
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = CGRectMake(0, 0, size.width, size.height);
    
    CGPoint startPoint = CGPointZero;
    if (direction == SDGradientChangeDirectionDownDiagonalLine) {
        startPoint = CGPointMake(0.0, 1.0);
    }
    gradientLayer.startPoint = startPoint;
    
    CGPoint endPoint = CGPointZero;
    switch (direction) {
        case SDGradientChangeDirectionLevel:
            endPoint = CGPointMake(1.0, 0.0);
            break;
        case SDGradientChangeDirectionVertical:
            endPoint = CGPointMake(0.0, 1.0);
            break;
        case SDGradientChangeDirectionUpwardDiagonalLine:
            endPoint = CGPointMake(1.0, 1.0);
            break;
        case SDGradientChangeDirectionDownDiagonalLine:
            endPoint = CGPointMake(1.0, 0.0);
            break;
        default:
            break;
    }
    gradientLayer.endPoint = endPoint;
    
    gradientLayer.colors = @[(__bridge id)startcolor.CGColor, (__bridge id)endColor.CGColor];
    UIGraphicsBeginImageContext(size);
    [gradientLayer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage*image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return [UIColor colorWithPatternImage:image];
}

@end
