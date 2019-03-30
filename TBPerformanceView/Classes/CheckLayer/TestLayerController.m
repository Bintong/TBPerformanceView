//
//  TestLayerController.m
//  TBPerformanceView
//
//  Created by BinTong on 2019/3/27.
//

#import "TestLayerController.h"
#import "TestCusView.h"
#import "CheckLayerManager.h"

@interface TestLayerController ()

@end

@implementation TestLayerController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self buildTestView];

    [[CheckLayerManager shareInstance] show];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)buildTestView {
    
    UIView *a = [[UIView alloc] initWithFrame:CGRectMake(140, 140, 50, 50)];
    a.backgroundColor = [UIColor redColor];
    [self.view addSubview:a];
    
    UIView *b = [[UIView alloc] initWithFrame:CGRectMake(200, 200, 50, 50)];
    b.backgroundColor = [UIColor blackColor];
    [self.view addSubview:b];
    
    UIView *c = [[UIView alloc] initWithFrame:CGRectMake(140, 200, 260, 260)];
    c.backgroundColor = [UIColor orangeColor];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 50, 50);
    button.backgroundColor = [UIColor blackColor];
    
    UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 5, 6)];
    img.backgroundColor = [UIColor redColor];
    [button addSubview:img];
    [c addSubview:button];
    TestCusView *cus = [[TestCusView alloc] initWithFrame:CGRectMake(0, 50, 50, 50)];
    cus.backgroundColor = [UIColor purpleColor];
    [c addSubview:cus];
    [self.view addSubview:c];
    
    UIView *d = [[UIView alloc] initWithFrame:CGRectMake(200, 140, 50, 50)];
    d.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:d];
    
    
    [self listSubviewsOfView:self.view];
}

- (void)getLayersInView:(UIView *)v {
    
}

- (void)listBrotherViewsOfView:(UIView *)view {
    UIView *s_v = [view superview];
    if (!s_v) {
        return;
    }
    //s_v.subviews//涉及到查找
    for (UIView *v in s_v.subviews) {
        NSLog(@"brother view  is %@",v );
    }
}

- (void)listSupViewsOfTopView:(UIView *)view {
    UIView *s_v = [view superview];
    if (!s_v) {
        return;
    }
    NSLog(@"supview is %@",s_v);
    [self listSupViewsOfTopView:s_v];
}


- (void)listSubviewsOfView:(UIView *)view {
    
    // Get the subviews of the view
    NSArray *subviews = [view subviews];
    
    // Return if there are no subviews
    if ([subviews count] == 0) return; // COUNT CHECK LINE
    
    for (UIView *subview in subviews) {
        
        // Do what you want to do with the subview
        NSLog(@"subview is  %@", subview);
        
        // List the subviews of subview
        [self listSubviewsOfView:subview];
    }
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
