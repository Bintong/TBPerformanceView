//
//  UIView+Coordinate.m
//  JiuFuWallet
//
//  Created by BinTong on 2017/11/22.
//  Copyright © 2017年 jayden. All rights reserved.
//

#import "UIView+Coordinate.h"

@implementation UIView (Coordinate)

- (CGFloat)left {
    
    return self.frame.origin.x;
}

- (void)setLeft:(CGFloat)x {
    
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (CGFloat)top {
    
    return self.frame.origin.y;
}

- (void)setTop:(CGFloat)y {
    
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)right {
    
    return self.frame.origin.x + self.frame.size.width;
}

- (void)setRight:(CGFloat)right {
    
    CGRect frame = self.frame;
    frame.origin.x = right - frame.size.width;
    self.frame = frame;
}

- (CGFloat)bottom {
    
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setBottom:(CGFloat)bottom {
    
    CGRect frame = self.frame;
    frame.origin.y = bottom - frame.size.height;
    self.frame = frame;
}

- (CGFloat)centerX {
    
    return self.center.x;
}

- (void)setCenterX:(CGFloat)centerX {
    
    self.center = CGPointMake(centerX,self.center.y);
}

- (CGFloat)centerY {
    
    return self.center.y;
}

- (void)setCenterY:(CGFloat)centerY {
    
    self.center = CGPointMake(self.center.x,centerY);
}

- (CGFloat)width {
    
    return self.frame.size.width;
}

- (void)setWidth:(CGFloat)width {
    
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (CGFloat)height {
    
    return self.frame.size.height;
}

- (void)setHeight:(CGFloat)height {
    
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (CGPoint)origin {
    
    return self.frame.origin;
}

- (void)setOrigin:(CGPoint)origin {
    
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}

- (CGSize)size {
    
    return self.frame.size;
}

- (void)setSize:(CGSize)size {
    
    CGRect frame = self.frame;
    frame.size = size;self.frame = frame;
}

- (CGFloat)rightToSuper {
    
    return self.superview.bounds.size.width-self.frame.size.width-self.frame.origin.x;
}

- (void)setRightToSuper:(CGFloat)rightToSuper {
    
    CGRect frame = self.frame;
    frame.origin.x = self.superview.bounds.size.width-self.frame.size.width-rightToSuper;
    self.frame = frame;
}

- (CGFloat)bottomToSuper {
    
    return self.superview.bounds.size.height-self.frame.size.height-self.frame.origin.y;
}

- (void)setBottomToSuper:(CGFloat)bottomToSuper {
    
    CGRect frame = self.frame;
    frame.origin.y = self.superview.bounds.size.height-self.frame.size.height-bottomToSuper;
    self.frame = frame;
}

@end
