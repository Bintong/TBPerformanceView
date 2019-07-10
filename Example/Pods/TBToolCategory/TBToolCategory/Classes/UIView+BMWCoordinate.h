//
//  UIView+BMWCoordinate.h
//  BMWorkPlatformCategory
//
//  Created by BinTong on 2018/6/28.
//

#import <UIKit/UIKit.h>

@interface UIView (BMWCoordinate)


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
