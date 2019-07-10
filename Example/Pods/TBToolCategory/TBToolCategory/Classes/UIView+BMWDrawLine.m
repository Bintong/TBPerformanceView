//
//  UIView+BMWDrawLine.m
//  BMWorkPlatformCategory
//
//  Created by BinTong on 2018/6/28.
//

#import "UIView+BMWDrawLine.h"

@implementation UIView (BMWDrawLine)


#pragma mark -
#pragma mark Draw Horizontal

- (void)drawX:(CGFloat)x lineY:(CGFloat)y width:(CGFloat)width color:(UIColor *)color value:(UIViewAutoresizing)value {
    
    if (!color)
    {
        color = kLineColor;
    }
    
    CGRect rect = CGRectMake(x,y,width,kLineSpace);
    UIView *lineView = [[UIView alloc] initWithFrame:rect];
    lineView.autoresizingMask = value;
    lineView.userInteractionEnabled = NO;
    lineView.backgroundColor = color;
    
    if ([self isKindOfClass:[UITableViewCell class]])
    {
        [[(UITableViewCell *)self contentView] addSubview:lineView];
    }
    else
    {
        [self addSubview:lineView];
    }
    
}

- (void)lineX:(CGFloat)x lineY:(CGFloat)y width:(CGFloat)width color:(UIColor *)color {
    
    [self drawX:x lineY:y width:width color:color value:UIViewAutoresizingNone];
}

- (void)topLineX:(CGFloat)x width:(CGFloat)width color:(UIColor *)color {
    
    [self drawX:x lineY:0 width:width color:color value:UIViewAutoresizingFlexibleBottomMargin];
}

- (void)bottomLineX:(CGFloat)x width:(CGFloat)width color:(UIColor *)color {
    
    [self drawX:x lineY:self.frame.size.height - kLineSpace width:width color:color value:UIViewAutoresizingFlexibleTopMargin];
}

+ (void)drawLineX:(CGFloat)x lineY:(CGFloat)y width:(CGFloat)width space:(CGFloat)space color:(UIColor *)color {
    
    if (!color)
    {
        color = kLineColor;
    }
    
    CGRect rect = CGRectMake(x,y,width,space);
    UIView *lineView = [[UIView alloc] initWithFrame:rect];
    lineView.autoresizingMask = UIViewAutoresizingNone;
    lineView.userInteractionEnabled = NO;
    lineView.backgroundColor = color;
    
    
}

#pragma mark -
#pragma mark Draw Vertical

- (void)lineX:(CGFloat)x lineY:(CGFloat)y height:(CGFloat)height color:(UIColor *)color {
    
    if (!color)
    {
        color = kLineColor;
    }
    
    CGRect rect = CGRectMake(x,y,kLineSpace,height);
    UIView *lineView = [[UIView alloc] initWithFrame:rect];
    lineView.userInteractionEnabled = NO;
    lineView.backgroundColor = color;
    
    if ([self isKindOfClass:[UITableViewCell class]])
    {
        [[(UITableViewCell *)self contentView] addSubview:lineView];
    }
    else
    {
        [self addSubview:lineView];
    }
    
    
    
}

- (void)centreLineY:(CGFloat)y height:(CGFloat)height color:(UIColor *)color {
    
    return [self lineX:(self.frame.size.width - kLineSpace)/2 lineY:y height:height color:color];
}

@end
