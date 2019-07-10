////
////  WPHUDHelper.m
////  BMWorkVisitor_Example
////
////  Created by BinTong on 2018/5/7.
////  Copyright © 2018年 yaxun_123@163.com. All rights reserved.
////
//
//#import "WPHUDHelper.h"
//#import <MBProgressHUD/MBProgressHUD.h>
//
//@implementation WPHUDHelper
//
//+ (void)hidenInView:(UIView *)view {
//    [MBProgressHUD hideHUDForView:view animated:YES];
//}
//
//+ (void)showMessage:(NSString *)message {
//    UIView * _parentView = nil;
//    NSArray* windows = [UIApplication sharedApplication].windows;
//    UIWindow *_window = [windows objectAtIndex:0];
//    //keep the first subview
//    if(_window.subviews.count > 0){
//        _parentView = [_window.subviews objectAtIndex:0];
//    }
//    
//    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:_parentView.window animated:YES];
//    hud.mode = MBProgressHUDModeText;
////    hud.label.text = message;
//    hud.detailsLabel.text = message;
//    [hud hideAnimated:YES afterDelay:2];
//}
//
//+ (void)hiddenHudViewOnWindow {
//    UIView * _parentView = nil;
//    NSArray* windows = [UIApplication sharedApplication].windows;
//    UIWindow *_window = [windows objectAtIndex:0];
//    //keep the first subview
//    if(_window.subviews.count > 0){
//        _parentView = [_window.subviews objectAtIndex:0];
//    }
//
//    [MBProgressHUD hideHUDForView:_parentView.window animated:YES];
//}
//
//+ (void)showLoadingOnWindow {
//    [self hiddenHudViewOnWindow];
//    UIView * _parentView = nil;
//    NSArray* windows = [UIApplication sharedApplication].windows;
//    UIWindow *_window = [windows objectAtIndex:0];
//    //keep the first subview
//    if(_window.subviews.count > 0){
//        _parentView = [_window.subviews objectAtIndex:0];
//    }
//    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:_parentView.window animated:YES];
////    hud.mode = MBProgressHUDModeIndeterminate;
////    hud.label.text = CtoE(@"main.loading");
//    [hud hideAnimated:YES afterDelay:20];
//}
//
//@end
