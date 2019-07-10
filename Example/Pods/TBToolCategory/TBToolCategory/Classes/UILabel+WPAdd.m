//
//  UILabel+WPAdd.m
//  BMBookClub
//
//  Created by BinTong on 2018/8/3.
//

#import "UILabel+WPAdd.h"

@implementation UILabel (WPAdd)
+ (UILabel *)labelWithFontSize:(int)fontSize
                     FontColor:(UIColor *)fontColor
                         frame:(CGRect)frame
                          Text:(NSString *)text{
    UILabel *lbTitle = [[UILabel alloc] initWithFrame:frame];
    lbTitle.backgroundColor = [UIColor clearColor];
    lbTitle.font = [UIFont systemFontOfSize:fontSize];
    lbTitle.textColor = fontColor;
    lbTitle.textAlignment = NSTextAlignmentLeft;
    lbTitle.text = text;
    return lbTitle;
    
}

+ (UILabel *)bold_labelWithFontSize:(int)fontSize
                          FontColor:(UIColor *)fontColor
                              frame:(CGRect)frame
                               Text:(NSString *)text{
    UILabel *lbTitle = [[UILabel alloc] initWithFrame:frame];
    lbTitle.backgroundColor = [UIColor clearColor];
    lbTitle.font = [UIFont boldSystemFontOfSize:fontSize];
    lbTitle.textColor = fontColor;
    lbTitle.textAlignment = NSTextAlignmentLeft;
    lbTitle.text = text;
    return lbTitle;
    
}
@end
