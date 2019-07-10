//
//  DetailTableViewCell.m
//  TBPerformanceView
//
//  Created by BinTong on 2019/7/10.
//

#import "DetailTableViewCell.h"
@interface DetailTableViewCell ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *valueLabel;

@end

@implementation DetailTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.titleLabel = [[UILabel alloc] init];
        self.titleLabel.textColor = [UIColor colorHexString:@"333333"];
        self.titleLabel.font = [UIFont systemFontOfSize:16];
        [self.contentView addSubview:self.titleLabel];
        
        self.valueLabel = [[UILabel alloc] init];
        self.valueLabel.textColor =[UIColor colorHexString:@"555555"];
        self.valueLabel.font = [UIFont systemFontOfSize:16];
        self.valueLabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:self.valueLabel];
    }
    return self;
}

- (void)renderUIWithData:(NSDictionary *)data{
    NSString *title = data[@"title"];
    NSString *value = data[@"value"];
    
    self.titleLabel.text = title;
    
    NSString *cnValue = nil;
    if([value isEqualToString:@"NotDetermined"]){
        cnValue = @"用户没有选择";
    }else if([value isEqualToString:@"Restricted"]){
        cnValue = @"家长控制";
    }else if([value isEqualToString:@"Denied"]){
        cnValue = @"用户没有授权";
    }else if([value isEqualToString:@"Authorized"]){
        cnValue = @"用户已经授权";
    }else{
        cnValue = value;
    }
    
    self.valueLabel.text = cnValue;
    
    
    self.titleLabel.frame = CGRectMake(15, 15, kScreenWidth/2 - 30, 30);
    self.valueLabel.frame = CGRectMake(kScreenWidth/2 - 15, 15, kScreenWidth/2 - 30, 30);
}

@end
