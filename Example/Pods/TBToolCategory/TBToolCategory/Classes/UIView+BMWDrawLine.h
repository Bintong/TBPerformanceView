//
//  UIView+BMWDrawLine.h
//  BMWorkPlatformCategory
//
//  Created by BinTong on 2018/6/28.
//

#import <UIKit/UIKit.h>


#define kLineSpace  (2.0/[UIScreen mainScreen].scale)

#define kLineColor  [UIColor blackColor]

@interface UIView (BMWDrawLine)

#pragma mark -
#pragma mark Draw Horizontal

//画一条横线
- (void)lineX:(CGFloat)x lineY:(CGFloat)y width:(CGFloat)width color:(UIColor *)color;

//在顶部画一条横线
- (void)topLineX:(CGFloat)x width:(CGFloat)width color:(UIColor *)color;

//在底部画一条横线
- (void)bottomLineX:(CGFloat)x width:(CGFloat)width color:(UIColor *)color;

//获取一条横线
+ (void)drawLineX:(CGFloat)x lineY:(CGFloat)y width:(CGFloat)width space:(CGFloat)space color:(UIColor *)color;

#pragma mark -
#pragma mark Draw Vertical

//画一条竖线
- (void)lineX:(CGFloat)x lineY:(CGFloat)y height:(CGFloat)height color:(UIColor *)color;

//在中间画一条竖线
- (void)centreLineY:(CGFloat)y height:(CGFloat)height color:(UIColor *)color;


@end
