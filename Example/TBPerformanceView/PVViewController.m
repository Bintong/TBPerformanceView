//
//  PVViewController.m
//  TBPerformanceView
//
//  Created by https://github.com/Bintong/TBCoreAnimation.git on 03/17/2019.
//  Copyright (c) 2019 https://github.com/Bintong/TBCoreAnimation.git. All rights reserved.
//

#import "PVViewController.h"
#import "TBPerformanceBoard.h"
@interface PVViewController ()

@end

@implementation PVViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [[TBPerformanceBoard sharedInstance] createPeroformanceBoardUpOnView:self.view];
    [[TBPerformanceBoard sharedInstance] open];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
