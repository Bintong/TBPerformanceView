//
//  WPCommonDefine.h
//  BMWorkVisitor
//
//  Created by BinTong on 2018/5/7.
//  Copyright © 2018年 yaxun_123@163.com. All rights reserved.
//

#ifndef WPCommonDefine_h
#define WPCommonDefine_h

#define kISiPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)
#define kStatusBarHeight [[UIApplication sharedApplication] statusBarFrame].size.height
#define kNavBarHeight 44.0
//注意：请直接获取系统的tabbar高度，若没有用系统tabbar，建议判断屏幕高度；之前判断状态栏高度的方法不妥，如果正在通话状态栏会变高，导致判断异常，下面只是一个例子，请勿直接使用！
#define kTabBarHeight (kISiPhoneX?83.f:49.f)
#define kBottomHeight (kISiPhoneX?83.f - 49.f:0)
#define kTopHeight (kStatusBarHeight + kNavBarHeight)


//状态栏高度
#define STATUSBAR_HEIGHT ((IS_IPHONE_X == YES || IS_IPHONE_Xr == YES || IS_IPHONE_Xs == YES || IS_IPHONE_Xs_Max == YES) ? 44.0 : 20.0)
//标题部分高度
#define NAVBAR_HEIGHT ((IS_IPHONE_X == YES || IS_IPHONE_Xr == YES || IS_IPHONE_Xs == YES || IS_IPHONE_Xs_Max == YES) ? 88.0 : 64.0)
//底部导航栏高度高度
#define TABBAR_HEIGHT ((IS_IPHONE_X == YES || IS_IPHONE_Xr == YES || IS_IPHONE_Xs == YES || IS_IPHONE_Xs_Max == YES) ? 83.0 : 49.0)
//距离底部高度
#define BOTTOM_HEIGHT ((IS_IPHONE_X == YES || IS_IPHONE_Xr == YES || IS_IPHONE_Xs == YES || IS_IPHONE_Xs_Max == YES)?34:0)
#define TOP_HEIGHT ((IS_IPHONE_X == YES || IS_IPHONE_Xr == YES || IS_IPHONE_Xs == YES || IS_IPHONE_Xs_Max == YES)?44:0)

/** 获取APP名称 */
#define APP_NAME ([[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"])
/** 程序版本号 */
#define APP_VERSION [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]
/** 获取APP build版本 */
#define APP_BUILD ([[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"])
// 判断iPHoneXr
#define IS_IPHONE_Xr ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(828, 1792), [[UIScreen mainScreen] currentMode].size) && !isPad : NO)
// 判断iPhoneXs
#define IS_IPHONE_Xs ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) && !isPad : NO)
// 判断iPhoneXs Max
#define IS_IPHONE_Xs_Max ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2688), [[UIScreen mainScreen] currentMode].size) && !isPad : NO)
// 判断iPhone6系列
#define kiPhone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) && !isPad : NO)
//判断iphone6+系列
#define kiPhone6Plus ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) && !isPad : NO)
// 判断iPhoneX
#define IS_IPHONE_X ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) && !isPad : NO)

// 判断是否是ipad
#define isPad ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
// 判断iPhone4系列
#define kiPhone4 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) && !isPad : NO)
// 判断iPhone5系列
#define kiPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) && !isPad : NO)


// 加载图片
#define IMAGE(NAME)          [UIImage imageNamed:(NAME)]

// 颜色(RGB)
#define RGBCOLOR(r, g, b, a)   [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]

#define ScreenWidth   [UIScreen mainScreen].bounds.size.width
#define ScreenHeight  [UIScreen mainScreen].bounds.size.height
#define kScale        [UIScreen mainScreen].scale

// MainScreen Height&Width
#define kScreenWidth  ScreenWidth
#define kScreenHeight ScreenHeight

#define SCREEN_WIDTH  ScreenWidth
#define SCREEN_HEIGHT ScreenHeight




#ifdef DEBUG
#define NSLog(s, ...)                   NSLog(@"<%@(%d)> %@", [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, [NSString stringWithFormat:(s), ## __VA_ARGS__])
#else
#define NSLog(s, ...)
#endif
#endif /* WPCommonDefine_h */
