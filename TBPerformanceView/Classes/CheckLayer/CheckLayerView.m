//
//  CheckLayerView.m
//  TBPerformanceView
//
//  Created by BinTong on 2019/3/28.
//

#import "CheckLayerView.h"

static CGFloat const kViewCheckSize = 62;


@interface CheckLayerView ()
@property (nonatomic, assign) CGFloat left;
@property (nonatomic, assign) CGFloat top;

@property (nonatomic, strong) NSMutableArray *info_views;
@property (nonatomic, strong) NSMutableArray *info_superViews;
//@property (nonatomic, strong) DoraemonVisualInfoWindow *viewInfoWindow;//顶部被探测到的view的信息显示的UIwindow

@end

@implementation CheckLayerView
-(instancetype)init{
    self = [super init];
    if (self) {
        self.frame = CGRectMake(SCREEN_WIDTH/2 - kViewCheckSize/2, SCREEN_HEIGHT/2-kViewCheckSize/2, kViewCheckSize, kViewCheckSize);
        self.backgroundColor = [UIColor clearColor];
        self.layer.zPosition = FLT_MAX;
        self.info_views = [NSMutableArray array];
        self.info_superViews = [NSMutableArray array];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        imageView.backgroundColor = [UIColor redColor];
        
        [self addSubview:imageView];
        
    }
    return self;
    
}
- (void)show {
    
    self.hidden = NO;
}

- (void)hide {
 
    self.hidden = YES;
}

-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self.window];
    self.frame = CGRectMake(point.x- _left, point.y - _top, self.frame.size.width, self.frame.size.height);
    CGPoint topPoint = [touch locationInView:self.window];
    [self topView:self.window Point:topPoint];
    
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    _left = point.x;
    _top = point.y;
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (self.delegate && [self.delegate respondsToSelector:@selector(showDetailViewSuperViews:)]) {
        [self.delegate showDetailViewSuperViews:self.info_superViews];
    }
    [_info_views removeAllObjects];
    [_info_superViews removeAllObjects];
}

// view 为self.window
- (void)topView:(UIView *)view Point:(CGPoint)point {
    [_info_views removeAllObjects];
    [_info_superViews removeAllObjects];
    [self hitTest:view Point:point];
    UIView *top_view = [_info_views lastObject];
//    NSLog(@"info views is %@",_info_views);
//    NSLog(@"super views is \n");
    [self printSuperViewFrom:top_view];
}

-(void)hitTest:(UIView*)view Point:(CGPoint) point{
    if ([view isKindOfClass:[UIScrollView class]]) {
        point.x += ((UIScrollView *)view).contentOffset.x;
        point.y += ((UIScrollView *)view).contentOffset.y;
    }
    
    if ([view pointInside:point withEvent:nil] && ![view isDescendantOfView:self]) {
        //便利点击的view 所有的子view===/ 用poin 的点view 的位置，来判断 点击的是是不是最顶端的view
        [_info_views addObject:view];
        for (UIView *subView in view.subviews) {
            CGPoint subPoint = CGPointMake(point.x - subView.frame.origin.x, point.y - subView.frame.origin.y);
//            NSLog(@"--- %@", NSStringFromCGPoint(subPoint));
#warning todo: 耗能 cpu fps 递归
#warning todo: 耗能 textview 渲染
            [self hitTest:subView Point:subPoint];
        }
    }
}

- (void)printSuperViewFrom:(UIView *)view {
    UIView *tempView = view;
    while (tempView.superview) {
        NSLog(@"temp-%@",tempView.superview);
        [_info_superViews addObject:tempView.superview];
        tempView = tempView.superview;
        
    }
}

@end
