//
//  TBNetDetailController.m
//  TBPerformanceView
//
//  Created by BinTong on 2019/4/9.
//

#import "TBNetDetailController.h"
#import "TBPerformanceBoard.h"
#import "TBNetUrlProtocol.h"
#import "TBNetMonitorManager.h"
#import "TBnetMonitorModel.h"
#import "TBNetMonitorDetailController.h"
#import "TBNetSummaryInfoView.h"

@interface TBNetDetailController ()<UITableViewDelegate,UITableViewDataSource,TBNetworkLoggerInfoDelegate>
@property (strong, nonatomic) UITableView *listView;
@property (strong, nonatomic) NSMutableArray  *dataArray;
@end

@implementation TBNetDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
//
//    [NSURLProtocol registerClass:[TBNetUrlProtocol class]];
//    [TBNetUrlProtocol setInfo_delegate:self];
    self.view.backgroundColor = [UIColor whiteColor];
    self.dataArray = [NSMutableArray array];
    
    //改成header
    
    [self.dataArray addObjectsFromArray:[TBNetMonitorManager sharedInstance].logArray];
    [self buildTableView];
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
    
    
    //header view
    TBNetSummaryInfoView *infoView = [[TBNetSummaryInfoView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 200)];
    [infoView refreshSummerInfoView:[TBNetMonitorManager sharedInstance].logArray];
    self.listView.tableHeaderView = infoView;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 66;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellID = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    TBnetMonitorModel *m  = [self.dataArray objectAtIndex:indexPath.row];
    cell.textLabel.text = m.detailString;
    
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.font = [UIFont systemFontOfSize:10];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    TBNetMonitorDetailController *ctr = [[TBNetMonitorDetailController alloc] init];
    ctr.detailModel = [self.dataArray objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:ctr animated:YES];
}

- (void)indexDidChangeForSegmentedControl:(UISegmentedControl *)seg {

}

#pragma mark - Delegate log
- (void)callbackSendNetWorkData:(NSDictionary *)parameter request:(NSURLRequest *)request respones:(NSURLResponse *)response {
    NSString *str = [NSString stringWithFormat:@"%@-|-%@",request.URL.absoluteString,request.HTTPMethod];
    [self.dataArray addObject:str];
    [self.listView reloadData];
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
