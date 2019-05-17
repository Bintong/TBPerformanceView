//
//  TBNetMonitorDetailController.m
//  TBPerformanceView
//
//  Created by BinTong on 2019/4/10.
//

#import "TBNetMonitorDetailController.h"
#import "TBNetMonitorUtil.h"
#import "UIImageView+WebCache.h"

@interface TBNetMonitorDetailController ()<UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) UITableView *listView;
@property (strong, nonatomic) NSMutableArray  *dataArray;
@end

@implementation TBNetMonitorDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /*-----------UI-----------*
     1 完整链接
     2 完整返回 json
     *-----------UI-----------*
     
     
     */
    // Do any additional setup after loading the view.
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
    

    //header
    UITextView * header_t = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 150)];
    header_t.textColor = [UIColor blackColor];
    header_t.font = [UIFont systemFontOfSize:12];
    header_t.text = _detailModel.monitorRequest.URL.absoluteString;
    
    self.listView.tableHeaderView = header_t;
    //footer

    if ([header_t.text containsString:@".jpg"]||[header_t.text containsString:@".png"]||[header_t.text containsString:@".webp"]) {
//        UIImageView *img = [[UIImageView alloc] initWithImage:[UIImage imageWithData:_detailModel.monitorResponseData]];
        UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
        
        [img sd_setImageWithURL:_detailModel.monitorRequest.URL.absoluteString];
        img.contentMode = UIViewContentModeScaleAspectFit;
        img.backgroundColor = [UIColor blackColor];
        self.listView.tableFooterView = img;
    } else {
        UITextView * header_f = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 150)];
        header_f.textColor = [UIColor whiteColor];
        header_f.font = [UIFont systemFontOfSize:12];
        header_f.backgroundColor = [UIColor blackColor];
        header_f.text = [TBNetMonitorUtil convertJsonFromData:_detailModel.monitorResponseData];
        self.listView.tableFooterView = header_f;

    }
    
    
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    return 88;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellID = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    return cell;
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
