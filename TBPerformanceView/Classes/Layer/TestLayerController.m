//
//  TestLayerController.m
//  TBPerformanceView
//
//  Created by BinTong on 2019/3/27.
//

#import "TestLayerController.h"

@interface TestLayerController ()

@end

@implementation TestLayerController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self buildTestView];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)buildTestView {
    UIView *a = [[UIView alloc] initWithFrame:CGRectMake(140, 140, 50, 50)];
    a.backgroundColor = [UIColor redColor];
    [self.view addSubview:a];
    
    UIView *b = [[UIView alloc] initWithFrame:CGRectMake(200, 200, 50, 50)];
    b.backgroundColor = [UIColor blackColor];
    [self.view addSubview:a];
    
    UIView *c = [[UIView alloc] initWithFrame:CGRectMake(140, 200, 60, 60)];
    c.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:c];
    
    UIView *d = [[UIView alloc] initWithFrame:CGRectMake(200, 140, 50, 50)];
    d.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:d];
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
