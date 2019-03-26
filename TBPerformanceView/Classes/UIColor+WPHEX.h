//
//  UIColor+WPHEX.h
//  BMWorkVisitor_Example
//
//  Created by BinTong on 2018/5/7.
//  Copyright © 2018年 yaxun_123@163.com. All rights reserved.
//

#import <UIKit/UIKit.h>

#define LMColor_Main_Color [UIColor colorHexString:@"3674E1"]
#define LMColor_GrayColor_A [UIColor colorHexString:@"222933"] //黑
#define LMColor_GrayColor_B [UIColor colorHexString:@"575D66"] //浅灰
#define LMColor_GrayColor_C [UIColor colorHexString:@"8A9099"] //浅浅灰
#define LMColor_UnEditColor [UIColor colorHexString:@"f5f5f5"] //不可更改背景颜色



#define LM_COLOR_PICKER [UIColor colorHexString:@"ececec"]

#define LM_COLOR_Green [UIColor colorHexString:@"6faa34"]

#define LMColor_Bg_Color [UIColor colorHexString:@"F0F2F5"] //背景颜色

#define LMColor_RedColor_A [UIColor colorHexString:@"F56565"] //字体红色

#define LMColor_CellLine [UIColor colorHexString:@"F5F4F5"] //cell 线的颜色


@interface UIColor (WPHEX)

+ (UIColor *)colorHexString:(NSString *)hex;
    
+ (UIColor *)colorHexString:(NSString *)hex alpha:(CGFloat)alpha;
    
@end
