//
//  TBPerformanceBoard.m
//  TimeAndLoop
//
//  Created by BinTong on 2019/2/26.
//  Copyright © 2019 TongBin. All rights reserved.
//

#import "TBPerformanceBoard.h"

#import "TBCupUse.h"
#import "TBMemeryUse.h"
#import "TBDeviceInfo.h"
#import "TPerformanceDetailController.h"
#import "CheckLayerView.h"
#import "TBWindow.h"
//#import "TBNetReachability.h"
//#import "AppDelegate.h"
#import "TBBoardView.h"

typedef NS_ENUM(NSInteger, PerformanceBoardType) {
    PB_Normarl = 0,                         // no button type
    PB_DeviceInfo,
    PB_Detail,
    
};

@interface TBPerformanceBoard()<CheckLayerViewDeleaget>

@property (nonatomic , strong , nonnull) TBWindow *tbWindow  ;

@property (strong ,nonatomic) CADisplayLink *displayLink;
@property (strong ,nonatomic) TBBoardView *boardView;
@property (strong ,nonatomic) UITextView *detailBoardView;
@property (strong ,nonatomic) UILabel *topLabel;
@property (strong ,nonatomic) UIViewController *rootViewController;
@property (assign, nonatomic) NSTimeInterval lastTime;
@property (assign, nonatomic) NSUInteger count;
@property (assign, nonatomic) PerformanceBoardType type;

@property (nonatomic, assign) CGFloat left;
@property (nonatomic, assign) CGFloat top;

@end


@implementation TBPerformanceBoard

#pragma mark CheckLayerViewDelegate
- (void)showDetailViewSuperViews:(NSArray *)views {
    
    if (_boardView.height < 300) {

      
        UITextView *text = [[UITextView alloc] initWithFrame:CGRectMake(15,100, SCREEN_WIDTH - 30, 300)];
        text.textColor = [UIColor redColor];
        text.font = [UIFont systemFontOfSize:14];
        text.editable = NO;
        
        text.backgroundColor = [UIColor clearColor];
        _detailBoardView = text;
        _boardView.height += 330;
        UIButton *closeBt = [UIButton buttonWithType:UIButtonTypeCustom];
        closeBt.frame = CGRectMake(0, text.bottom, SCREEN_WIDTH - 30, 30);
        [closeBt setTitle:@"关闭" forState:UIControlStateNormal];
        [closeBt setTintColor:[UIColor whiteColor]];
        [closeBt addTarget:self action:@selector(closeDetailView:) forControlEvents:UIControlEventTouchUpInside];
        [_boardView addSubview:text];
       
        [_boardView addSubview:closeBt];
 
    }else {
        _detailBoardView.hidden = NO;
    }
    _detailBoardView.text = [[views valueForKey:@"description"] componentsJoinedByString:@"👻 \n 🍎🍎🍎🍎 \n"];
    
}

- (void)closeDetailView:(UIButton *)button {
    _detailBoardView.hidden = YES;
    _boardView.height -= 330;
}


- (void)dealloc {
    [_displayLink setPaused:YES];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

+ (TBPerformanceBoard *)sharedInstance {
    static TBPerformanceBoard *sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[TBPerformanceBoard alloc] init];
    });
    return sharedInstance;
}

- (void)open{
    [self.displayLink setPaused:NO];
}

- (void)close {
    NSLog(@"close fps");
    [_boardView removeFromSuperview];
    [_displayLink setPaused:YES];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)startWorkingOnViewController:(UIViewController *)ctr {
    // start working
    if (_displayLink && (!_displayLink.paused)) {
        _displayLink.paused = YES;
    }
    
    
    [self createShowView:ctr.view];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidBecomeActiveNotification:) name:UIApplicationDidBecomeActiveNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillResignActiveNotification:) name:UIApplicationWillResignActiveNotification object:nil];
    
    _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(displayLinkTick:)];
    _displayLink.frameInterval = 1;
    [_displayLink setPaused:YES];
    [_displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    
     [self open];
}
    
- (void)createPeroformanceWithDeviceInfo:(UIView *)view {
    if (_displayLink && (!_displayLink.paused)) {
        _displayLink.paused = YES;
    }
    _type = PB_DeviceInfo;
    [self createPeroformanceBoardUpOnView:view];
}


- (void)createPeroformanceBoardUpOnView:(UIView *)view {
    
    if (_displayLink && (!_displayLink.paused)) {
        _displayLink.paused = YES;
    }
    [self createShowView:view];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidBecomeActiveNotification:) name:UIApplicationDidBecomeActiveNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillResignActiveNotification:) name:UIApplicationWillResignActiveNotification object:nil];
    
    _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(displayLinkTick:)];
    _displayLink.frameInterval = 1;
    [_displayLink setPaused:YES];
    [_displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    
}


- (void)createClickPeroformanceWithDeviceInfo:(UIViewController *)ctr {
    if (_displayLink && (!_displayLink.paused)) {
        _displayLink.paused = YES;
    }
    _type = PB_Detail;
    if (!ctr) {}
   
    [self createPeroformanceBoardUpOnView:ctr.view];
    _rootViewController = ctr;
    _type = PB_Detail;
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushToDetail)];
//    [self.boardView addGestureRecognizer:tap];
}

 


- (void)pushToDetail {
    if (!_showedDetails) {
        TPerformanceDetailController *c = [[TPerformanceDetailController alloc] init];
        
        //    UINavigationController *v = [[UINavigationController alloc] initWithRootViewController:self]
        [self.rootViewController.navigationController pushViewController:c animated:YES];
        self.showedDetails = YES;
    }
}

- (void)createShowView:(UIView *)view{
    if (view && ![view viewWithTag:1001]) {
        TBBoardView *topView = [[TBBoardView alloc] initWithFrame:CGRectMake(1, 150, [UIScreen mainScreen].bounds.size.width - 2, self.type == PB_DeviceInfo? 50: 25)];
        _boardView = topView;
        topView.backgroundColor = [UIColor blackColor];
        topView.layer.cornerRadius = 4;
        topView.layer.masksToBounds = YES;
        topView.tag = 1001;
        
        if (view) {
            [view addSubview:topView];
        }else {
            UIWindow *w = [[UIApplication sharedApplication] keyWindow];
            [w addSubview:topView];
        }
        UILabel *l = [self labelWithFontSize:12 FontColor:[UIColor whiteColor] frame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width - 100, 25) Text:@""];
        l.textAlignment = NSTextAlignmentCenter;
        self.topLabel = l;
        [topView addSubview:l];
    }
}

- (void)displayLinkTick:(CADisplayLink *)disLink {
    
         _count ++;
        //当前时间戳
        if(_lastTime == 0){
            _lastTime = disLink.timestamp;
        }
        CFTimeInterval timePassed = disLink.timestamp - _lastTime;
    
        if(timePassed >= 1.f) {
            CGFloat fps = _count/timePassed;
//            NSLog(@"----fps:%.1f, timePassed:%f\n", fps, timePassed);
    
            [self takeReadingsFromFps:fps];
            //reset
            _lastTime = disLink.timestamp;
            _count = 0;
         }else {
             
         }
}

- (void)takeReadingsFromFps:(CGFloat)fps {
    float cpuUse =  [[TBCupUse sharedInstance] cpuUse];
    float memeryUse = [[TBMemeryUse sharedInstance] usedMemoryInMB];
    NSString *app_version = [TBDeviceInfo applicationVersion];
    NSString *ios_version = [TBDeviceInfo phoneSystemVersion];
    //    [TBNetReachability socketReachabilityTestWithLink:disLink];
    NSString *string;
    if (_type == PB_DeviceInfo) {
        string = [NSString stringWithFormat:@"CPU:%0.2f%%; MEMORY:%0.2fMb; FPS:%0.2f \n AppVersion:%@ / iOS : %@",cpuUse,memeryUse,fps,app_version,ios_version];
        _topLabel.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width - 100, 50);
        _topLabel.numberOfLines = 0;
        _topLabel.textAlignment = NSTextAlignmentCenter;
    }else {
        string = [NSString stringWithFormat:@"CPU:%0.2f%%; MEMERY:%0.2fMb; FPS:%0.2f",cpuUse,memeryUse,fps];
    }
    
    _topLabel.text = string;
}

- (UILabel *)labelWithFontSize:(CGFloat)fontSize FontColor:(UIColor *)fontColor  frame:(CGRect)frame Text:(NSString *)text{
    UILabel *lbTitle = [[UILabel alloc] initWithFrame:frame];
    lbTitle.backgroundColor = [UIColor clearColor];
    lbTitle.font = [UIFont systemFontOfSize:fontSize];
    lbTitle.textColor = fontColor;
    lbTitle.textAlignment = NSTextAlignmentCenter;
    lbTitle.text = text;
    return lbTitle;
}

- (void)applicationDidBecomeActiveNotification:(NSNotificationCenter *)notification {
    [self.displayLink setPaused:NO];
}

- (void)applicationWillResignActiveNotification:(NSNotificationCenter *)notification  {
    [self.displayLink setPaused:YES];
}





@end
