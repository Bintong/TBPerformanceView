//
//  CheckLayerManager.m
//  TBPerformanceView
//
//  Created by BinTong on 2019/3/28.
//

#import "CheckLayerManager.h"
#import "CheckLayerView.h"
@interface CheckLayerManager ()

@property (nonatomic, strong) CheckLayerView *viewCheckView;

@end

@implementation CheckLayerManager

+ (CheckLayerManager *)shareInstance {
    static CheckLayerManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (void)show {
    if (!_viewCheckView) {
        _viewCheckView = [[CheckLayerView alloc] init];
        _viewCheckView.hidden = YES;
        UIWindow *delegateWindow = [[UIApplication sharedApplication].delegate window];
        [delegateWindow addSubview:_viewCheckView];
    }
    [_viewCheckView show];
}

- (void)hidden {
    [_viewCheckView hidden];
}

@end
