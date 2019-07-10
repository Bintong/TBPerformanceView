//
//  UIImage+BMWAdd.m
//  BMWorkPlatformCategory
//
//  Created by BinTong on 2018/6/28.
//

#import "UIImage+BMWAdd.h"

@implementation UIImage (BMWAdd)

- (UIImage *)scaleImageToScale:(CGFloat)scaleSize {
    
    UIGraphicsBeginImageContext(CGSizeMake(self.size.width*scaleSize,self.size.height*scaleSize));
    [self drawInRect:CGRectMake(0,0,self.size.width*scaleSize,self.size.height*scaleSize)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}

- (UIImage *)scaleImageSize:(CGSize)size {
    
    UIGraphicsBeginImageContext(size);
    [self drawInRect:CGRectMake(0,0,size.width,size.height)];
    UIImage *sourceImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return sourceImage;
}


+ (UIImage *)imageWithView:(UIView *)view {
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.opaque, 0.0);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

+ (UIImage *)imageFromColor:(UIColor *)customColor {
    
    CGRect rect = CGRectMake(0,0,1,1);
    UIGraphicsBeginImageContextWithOptions(rect.size,0,[UIScreen mainScreen].scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context,[customColor CGColor]);
    CGContextFillRect(context,rect);
    UIImage *currentImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return currentImage;
}

+ (UIImage *)imageFromColor:(UIColor *)customColor imageSize:(CGSize)imageSize {
    
    UIGraphicsBeginImageContextWithOptions(imageSize,0,[UIScreen mainScreen].scale);
    [customColor set];
    UIRectFill(CGRectMake(0,0,imageSize.width,imageSize.height));
    UIImage *currentImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return currentImage;
}


@end
