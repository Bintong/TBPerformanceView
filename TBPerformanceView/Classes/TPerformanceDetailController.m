//
//  TPerformanceDetailController.m
//  TBPerformanceView
//
//  Created by BinTong on 2019/3/21.
//

#import "TPerformanceDetailController.h"
#import "UIView+Coordinate.h"
#import "TBDirctoryController.h"
#import "TestLayerController.h"
#import "TBPerformanceBoard.h"
#import "TBNetDetailController.h"


@interface TPerformanceDetailController()<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) UITableView *listView;
@property (strong, nonatomic) NSArray *dataArray;

@end

@implementation TPerformanceDetailController


- (void)viewDidLoad {
    [super viewDidLoad];
    [TBPerformanceBoard sharedInstance].showedDetails = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    self.dataArray = @[@"沙盒路径",@"App 详细信息",@"网络请求",@"页面Layder"];
    [self buildTableView];
    
    // Do any additional setup after loading the view.
}

- (void)viewWillDisappear:(BOOL)animated {
    [TBPerformanceBoard sharedInstance].showedDetails = NO;
}

- (void)buildTableView {
    self.listView = [[UITableView alloc] initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
    self.listView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleTopMargin;
    
    self.listView.height = SCREEN_HEIGHT - 20;
    self.listView.backgroundColor = [UIColor clearColor];
    self.listView.rowHeight = 46;
    self.listView.showsVerticalScrollIndicator = NO;
    self.listView.pagingEnabled = NO;
    
    self.listView.delegate = self;
    self.listView.dataSource = self;
    [self.view addSubview:self.listView];
    //header
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellID = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    cell.textLabel.text = [self.dataArray objectAtIndex:indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UIViewController *ctr ;
    if (indexPath.row == 0) {
        ctr = [[TBDirctoryController alloc] init];
    }else if(indexPath.row == 1){
//        ctr = [[SculptDrawImgController alloc] init];
    }else if(indexPath.row == 2){
        ctr = [[TBNetDetailController alloc] init];
    }else if(indexPath.row == 3){
        ctr = [[TestLayerController alloc] init];
    }
    [self.navigationController pushViewController:ctr animated:YES];
}

 

@end
