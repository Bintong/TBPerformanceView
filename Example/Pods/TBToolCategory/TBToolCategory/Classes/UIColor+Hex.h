//
//  UIColor+Hex.h
//  MobileSale
//
//  Created by tongbin  on 15/12/22.
//  Copyright © 2015年 MobileSale. All rights reserved.
//

#import <UIKit/UIKit.h>

#define W_COLOR_A       [UIColor colorHexString:@"00C457"] //用于需要突出和强调的文字、按钮和icon
#define W_COLOR_A_ORANGE   [UIColor colorHexString:@"FF5A00"]
#define W_COLOR_A_RED [UIColor colorHexString:@"FF0000"]


#define W_COLOR_B       [UIColor colorHexString:@"636d70"] //用于较为重要的文字信息、内页标题等
#define W_COLOR_C       [UIColor colorHexString:@"778387"]
#define W_COLOR_D       [UIColor colorHexString:@"a2b3b8"] //label 没有内容的文案
#define W_COLOR_PLACEHOLDER       [UIColor colorHexString:@"cdcdcd"] //label 没有内容的文案

#define W_COLOR_E       [UIColor colorHexString:@"B4C2BA"] //
#define W_COLOR_F       [UIColor colorHexString:@"00C457"] //用于模块分割的底色
#define W_COLOR_G       [UIColor colorHexString:@"f2f2f2"] //用于模块分割的底色
#define W_COLOR_H       [UIColor colorHexString:@"f3f3f3"] // bJH


#define W_COLOR_GRAY    [UIColor colorHexString:@"b1b1b1"] //按钮未点击的颜色
#define W_GRAY_Button   [UIColor colorHexString:@"dedede"] //按钮未点击的颜色


#define W_COLOR_LINE [UIColor colorHexString:@"dcdcdc"]
#define W_COLOR_PICKER [UIColor colorHexString:@"ececec"]


typedef NS_ENUM(NSInteger, SDGradientChangeDirection) {
    SDGradientChangeDirectionLevel,
    SDGradientChangeDirectionVertical,
    SDGradientChangeDirectionUpwardDiagonalLine,
    SDGradientChangeDirectionDownDiagonalLine,
};

@interface UIColor (Hex)

+ (UIColor *)colorHexString:(NSString *)hex;

+ (UIColor *)colorHexString:(NSString *)hex alpha:(CGFloat)alpha;


+ (UIColor *)sd_colorWithHex:(UInt32)hex;
+ (UIColor *)sd_colorWithHex:(UInt32)hex andAlpha:(CGFloat)alpha;
+ (UIColor *)sd_colorWithHexString:(NSString *)hexString;
- (NSString *)sd_HEXString;
///值不需要除以255.0
+ (UIColor *)sd_colorWithWholeRed:(CGFloat)red
                            green:(CGFloat)green
                             blue:(CGFloat)blue
                            alpha:(CGFloat)alpha;
///值不需要除以255.0
+ (UIColor *)sd_colorWithWholeRed:(CGFloat)red
                            green:(CGFloat)green
                             blue:(CGFloat)blue;

+ (CAGradientLayer *)setGradualChangingColor:(UIView *)view fromColor:(UIColor *)fromHexColorStr toColor:(UIColor *)toHexColorStr;


/**
 渐变色

 @param size size
 @param direction dirction
 @param startcolor start color
 @param endColor end color
 @return color
 */
+ (instancetype)sd_colorGradientChangeWithSize:(CGSize)size
                                     direction:(SDGradientChangeDirection)direction
                                    startColor:(UIColor *)startcolor
                                      endColor:(UIColor *)endColor;

@end
