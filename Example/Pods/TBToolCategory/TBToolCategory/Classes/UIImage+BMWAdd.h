//
//  UIImage+BMWAdd.h
//  BMWorkPlatformCategory
//
//  Created by BinTong on 2018/6/28.
//

#import <UIKit/UIKit.h>

@interface UIImage (BMWAdd)

+ (UIImage *)imageFromColor:(UIColor *)customColor;
+ (UIImage *)imageWithView:(UIView *)view;
- (UIImage *)scaleImageToScale:(CGFloat)scaleSize;
- (UIImage *)scaleImageSize:(CGSize)size;

@end
