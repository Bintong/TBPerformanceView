//
//  UILabel+WPAdd.h
//  BMBookClub
//
//  Created by BinTong on 2018/8/3.
//

#import <UIKit/UIKit.h>

@interface UILabel (WPAdd)
+ (UILabel *)labelWithFontSize:(int)fontSize
                     FontColor:(UIColor *)fontColor
                         frame:(CGRect)frame
                          Text:(NSString *)text;

+ (UILabel *)bold_labelWithFontSize:(int)fontSize
                          FontColor:(UIColor *)fontColor
                              frame:(CGRect)frame
                               Text:(NSString *)text;
@end
