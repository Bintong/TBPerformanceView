//
//  UILabel+wpadd.h
//  TBPerformanceView
//
//  Created by BinTong on 2019/3/25.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UILabel (wpadd)
+ (UILabel *)labelWithFontSize:(int)fontSize
                     FontColor:(UIColor *)fontColor
                         frame:(CGRect)frame
                          Text:(NSString *)text;
@end

NS_ASSUME_NONNULL_END
