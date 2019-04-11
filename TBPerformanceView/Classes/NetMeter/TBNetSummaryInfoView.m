//
//  TBNetSummaryInfoView.m
//  TBPerformanceView
//
//  Created by BinTong on 2019/4/11.
//

#import "TBNetSummaryInfoView.h"
#import "UILabel+wpadd.h"
#import "TBNetSummaryInfo.h"
@interface TBNetSummaryInfoView ()

@property (strong, nonatomic) UILabel *totalFlowLab;
@property (strong, nonatomic) UILabel *totalRequestNumLab;
@property (strong, nonatomic) UILabel *requestLab;
@property (strong, nonatomic) UILabel *responseLab;
@property (strong, nonatomic) UILabel *errorLab;

@end

@implementation TBNetSummaryInfoView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _totalFlowLab = [UILabel labelWithFontSize:14 FontColor:[UIColor blackColor] frame:CGRectMake(15, 0, SCREEN_WIDTH, 40) Text:@"总流量"];
        _totalRequestNumLab = [UILabel labelWithFontSize:14 FontColor:[UIColor blackColor] frame:CGRectMake(15, _totalFlowLab.bottom, SCREEN_WIDTH- 30, 40) Text:@"请求次数"];
        _requestLab = [UILabel labelWithFontSize:14 FontColor:[UIColor blackColor] frame:CGRectMake(15, _totalRequestNumLab.bottom, SCREEN_WIDTH- 30, 40) Text:@"request流量"];
        _responseLab = [UILabel labelWithFontSize:14 FontColor:[UIColor blackColor] frame:CGRectMake(15, _requestLab.bottom, SCREEN_WIDTH - 30, 40) Text:@"response 流量"];
        _errorLab = [UILabel labelWithFontSize:14 FontColor:[UIColor blackColor] frame:CGRectMake(15, _responseLab.bottom, SCREEN_WIDTH- 30, 40) Text:@"错误次数"];
//        总流量",@"请求次数",@"request 流量",@"response 流量",@"错误次数",
        [self addSubview:_totalFlowLab];
        [self addSubview:_totalRequestNumLab];
        [self addSubview:_requestLab];
        [self addSubview:_responseLab];
        [self addSubview:_errorLab];
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)refreshSummerInfoView:(NSArray *)infos {
    TBNetSummaryInfo * s_info = [[TBNetSummaryInfo alloc] init];
    s_info.reqestModels = infos;
    _totalFlowLab.text = [NSString stringWithFormat:@"总流量: %@",s_info.totalsFlow];
    _totalRequestNumLab.text = [NSString stringWithFormat:@"请求次数: %ld",s_info.summaryNum];
    _requestLab.text = [NSString stringWithFormat:@"request流量: %@",s_info.requestFlow];
    _responseLab.text = [NSString stringWithFormat:@"response流量: %@",s_info.responseFlow];
    _errorLab.text = [NSString stringWithFormat:@"daikaifa"];
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
