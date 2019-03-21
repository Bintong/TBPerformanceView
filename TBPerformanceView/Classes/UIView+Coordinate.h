//
//  UIView+Coordinate.h
//  JiuFuWallet
//
//  Created by BinTong on 2017/11/22.
//  Copyright © 2017年 jayden. All rights reserved.
//

#import <UIKit/UIKit.h>

#define SCREEN_SIZE            SCREEN_BOUNDS.size
#define SCREEN_WIDTH           SCREEN_SIZE.width
#define SCREEN_HEIGHT          SCREEN_SIZE.height
#define SCREEN_BOUNDS          [[UIScreen mainScreen] bounds]

@interface UIView (Coordinate)

@property (nonatomic) CGFloat left;

@property (nonatomic) CGFloat top;

@property (nonatomic) CGFloat right;

@property (nonatomic) CGFloat bottom;

@property (nonatomic) CGFloat width;

@property (nonatomic) CGFloat height;

@property (nonatomic) CGFloat centerX;

@property (nonatomic) CGFloat centerY;

@property (nonatomic) CGPoint origin;

@property (nonatomic) CGSize size;

@property (nonatomic) CGFloat rightToSuper;

@property (nonatomic) CGFloat bottomToSuper;

@end
