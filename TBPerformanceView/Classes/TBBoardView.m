//
//  TBBoardView.m
//  TBPerformanceView
//
//  Created by BinTong on 2019/5/10.
//

#import "TBBoardView.h"
@interface TBBoardView ()
@property (nonatomic, assign) CGFloat left;
@property (nonatomic, assign) CGFloat top;

@end

@implementation TBBoardView

#pragma mark - touch delegate
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    _left = point.x;
    _top = point.y;
}


-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self.window];
    self.frame = CGRectMake(point.x- _left, point.y - _top, self.frame.size.width, self.frame.size.height);
    CGPoint topPoint = [touch locationInView:self.window];
    //    [self.boardView topView:self.boardView.window Point:topPoint];
    
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
}

@end
