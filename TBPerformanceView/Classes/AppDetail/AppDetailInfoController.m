//
//  AppDetailInfoController.m
//  Pods-TBPerformanceView_Example
//
//  Created by BinTong on 2019/7/10.
//

#import "AppDetailInfoController.h"
#import "DetailTableViewCell.h"
#import "DetailUtil.h"
#import <CoreTelephony/CTCellularData.h>
#define getRectNavAndStatusHight  self.navigationController.navigationBar.frame.size.height+[[UIApplication sharedApplication] statusBarFrame].size.height

API_AVAILABLE(ios(9.0))
@interface AppDetailInfoController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic ,strong) UITableView *listView;
@property (nonatomic ,strong) NSMutableArray *datas;

@property (nonatomic, strong) CTCellularData *cellularData;
@property (nonatomic, copy) NSString *authority;


@end

@implementation AppDetailInfoController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self buildListView];
    [self buildDatas];
    
    // Do any additional setup after loading the view.
}


- (void)buildDatas {
    self.datas = [NSMutableArray array];
    // 获取设备名称
    NSString *iphoneName = [DetailUtil iphoneName];
    // 获取当前系统版本号
    NSString *iphoneSystemVersion = [DetailUtil iphoneSystemVersion];
    
    //获取手机型号
    NSString *iphoneType = [DetailUtil iphoneType];
    
    //获取bundle id
    NSString *bundleIdentifier = [DetailUtil bundleIdentifier];
    
    //获取App版本号
    NSString *bundleVersion = [DetailUtil bundleVersion];
    
    //获取App版本Code
    NSString *bundleShortVersionString = [DetailUtil bundleShortVersionString];
    
    //获取手机是否有地理位置权限
    NSString *locationAuthority = [DetailUtil locationAuthority];
    
    //获取网络权限
    if (@available(iOS 9.0, *)) {
        _cellularData = [[CTCellularData alloc]init];
    } else {
        // Fallback on earlier versions
    }
    __weak typeof(self) weakSelf = self;
    if (@available(iOS 9.0, *)) {
        _cellularData.cellularDataRestrictionDidUpdateNotifier = ^(CTCellularDataRestrictedState state) {
            if (state == kCTCellularDataRestricted) {
                weakSelf.authority = @"Restricted";
            }else if(state == kCTCellularDataNotRestricted){
                weakSelf.authority = @"NotRestricted";
            }else{
                weakSelf.authority = @"Unknown";
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.listView reloadData];
            });
            
        };
    } else {
        // Fallback on earlier versions
    }
    
    //获取push权限
    NSString *pushAuthority = [DetailUtil pushAuthority];
    
    //获取拍照权限
    NSString *cameraAuthority = [DetailUtil cameraAuthority];
    
    //获取麦克风权限
    NSString *audioAuthority = [DetailUtil audioAuthority];
    
    //获取相册权限
    NSString *photoAuthority = [DetailUtil photoAuthority];
    
    //获取通讯录权限
    NSString *addressAuthority = [DetailUtil addressAuthority];
    
    //获取日历权限
    NSString *calendarAuthority = [DetailUtil calendarAuthority];
    
    //获取提醒事项权限
    NSString *remindAuthority = [DetailUtil remindAuthority];
    
    NSArray *dataArray = @[
                           @{
                               @"title":@"手机信息",
                               @"array":@[
                                       @{
                                           @"title":@"设备名称",
                                           @"value":iphoneName
                                           },
                                       @{
                                           @"title": @"手机型号",
                                           @"value":iphoneType
                                           },
                                       @{
                                           @"title": @"系统版本",
                                           @"value":iphoneSystemVersion
                                           }
                                       ]
                               },
                           @{
                               @"title": @"App信息",
                               @"array":@[@{
                                              @"title":@"Bundle ID",
                                              @"value":bundleIdentifier
                                              },
                                          @{
                                              @"title":@"Version",
                                              @"value":bundleVersion
                                              },
                                          @{
                                              @"title":@"VersionCode",
                                              @"value":bundleShortVersionString
                                              }
                                          ]
                               },
                           @{
                               @"title": @"权限信息",
                               @"array":@[@{
                                              @"title": @"地理位置权限",
                                              @"value":locationAuthority
                                              },
                                          @{
                                              @"title": @"网络权限",
                                              @"value":@"Unknown"
                                              },
                                          @{
                                              @"title": @"推送权限",
                                              @"value":pushAuthority
                                              },
                                          @{
                                              @"title": @"相机权限",
                                              @"value":cameraAuthority
                                              },
                                          @{
                                              @"title": @"麦克风权限",
                                              @"value":audioAuthority
                                              },
                                          @{
                                              @"title": @"相册权限",
                                              @"value":photoAuthority
                                              },
                                          @{
                                              @"title": @"通讯录权限",
                                              @"value":addressAuthority
                                              },
                                          @{
                                              @"title": @"日历权限",
                                              @"value":calendarAuthority
                                              },
                                          @{
                                              @"title": @"提醒事项权限",
                                              @"value":remindAuthority
                                              }
                                          ]
                               }
                           ];
    _datas = [NSMutableArray arrayWithArray:dataArray];
    [ self.listView reloadData];
}

- (void)buildListView {
    self.listView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:UITableViewStyleGrouped];
    self.listView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleTopMargin;
    self.listView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    self.listView.height = kScreenHeight - getRectNavAndStatusHight;
    self.listView.backgroundColor = [UIColor clearColor];
    
    self.listView.showsVerticalScrollIndicator = NO;
    
    self.listView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.listView.delegate = self;
    self.listView.dataSource = self;
    self.listView.bounces = NO;
    
    [self.view addSubview:self.listView];
    
}

#pragma mark - UITableView Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _datas.count;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *array = _datas[section][@"array"];
    return array.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 60;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *sectionView = [[UIView alloc] initWithFrame:CGRectMake(15, 0, kScreenWidth - 30, 60)];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(32,10,kScreenWidth - 63, 40)];
    NSDictionary *dic = _datas[section];
    titleLabel.text = dic[@"title"];
    titleLabel.font = [UIFont systemFontOfSize:14];
    titleLabel.textColor = [UIColor redColor];
    
    [sectionView addSubview:titleLabel];
    return sectionView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"DetailTableViewCell";
    DetailTableViewCell *myCell = (DetailTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellID];
    if (myCell == nil) {
        myCell = [[DetailTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    NSArray *array = _datas[indexPath.section][@"array"];
    NSDictionary *item = array[indexPath.row];
    if (indexPath.section == 2 && indexPath.row == 1 && self.authority) {
        NSMutableDictionary *tempItem = [item mutableCopy];
        [tempItem setValue:self.authority forKey:@"value"];
        [myCell renderUIWithData:tempItem];
    }else{
        [myCell renderUIWithData:item];
    }
    return myCell;
}
@end
