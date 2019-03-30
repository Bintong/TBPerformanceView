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
//@property (nonatomic, strong) DoraemonVisualInfoWindow *viewInfoWindow;//顶部被探测到的view的信息显示的UIwindow

@end

@implementation CheckLayerView
-(instancetype)init{
    self = [super init];
    if (self) {
        self.frame = CGRectMake(SCREEN_WIDTH/2 - kViewCheckSize/2, SCREEN_HEIGHT/2-kViewCheckSize/2, kViewCheckSize, kViewCheckSize);
        self.backgroundColor = [UIColor clearColor];
        self.layer.zPosition = FLT_MAX;
        
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
    
//    CGPoint topPoint = [touch locationInView:self.window];
//    UIView *view = [self topView:self.window Point:topPoint];
//    CGRect frame = [self.window convertRect:view.bounds fromView:view];
//    _viewBound.frame = frame;
    //    _viewInfoWindow.hidden = NO;
//    _viewInfoLabel.attributedText = [self viewInfo:view];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    _left = point.x;
    _top = point.y;
    CGPoint topPoint = [touch locationInView:self.window];
//    UIView *view = [self topView:self.window Point:topPoint];
//    CGRect frame = [self.window convertRect:view.bounds fromView:view];
//    _viewBound.frame = frame;
//    [self.window addSubview:_viewBound];
    
    //    _viewInfoWindow.hidden = NO;
//    _viewInfoLabel.attributedText = [self viewInfo:view];
    
}

@end
