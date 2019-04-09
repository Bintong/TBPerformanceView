//
//  TBNetDetailController.m
//  TBPerformanceView
//
//  Created by BinTong on 2019/4/9.
//

#import "TBNetDetailController.h"
#import "TBPerformanceBoard.h"
#import "TBNetUrlProtocol.h"

@interface TBNetDetailController ()

@end

@implementation TBNetDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[TBPerformanceBoard sharedInstance] close];
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    NSArray *segmentedArray = [NSArray arrayWithObjects:@"概况",@"列表",nil];
    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc]initWithItems:segmentedArray];
    segmentedControl.frame = CGRectMake(0, 0, 180, 30);
    segmentedControl.selectedSegmentIndex = 0;
    segmentedControl.tintColor = [UIColor redColor];
    [segmentedControl addTarget:self action:@selector(indexDidChangeForSegmentedControl:) forControlEvents:UIControlEventValueChanged];
    
    [self.navigationItem setTitleView:segmentedControl];
    
    [self beginRegister];
    // Do any additional setup after loading the view.
}

- (void)beginRegister {
    [NSURLProtocol registerClass:[TBNetUrlProtocol class]];
}

- (void)indexDidChangeForSegmentedControl:(UISegmentedControl *)seg {

}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
