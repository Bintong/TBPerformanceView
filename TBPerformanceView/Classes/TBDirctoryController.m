//
//  TBDirctoryController.m
//  TBPerformanceView
//
//  Created by BinTong on 2019/3/25.
//

#import "TBDirctoryController.h"
#import "UILabel+wpadd.h"
#import "TBFileManager.h"
#import "TBDirctoryModel.h"
@interface TBDirctoryController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) UITableView *listView;
@property (strong, nonatomic) NSArray *dataArray;

@end

@implementation TBDirctoryController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    

    [self buildViewContent];
    [self buildTableView];
    
    // Do any additional setup after loading the view.
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
    UIView *pathFullView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 60)];
    NSString *path = NSHomeDirectory();
    UILabel *lab_path  = [UILabel labelWithFontSize:12 FontColor:[UIColor blackColor] frame:CGRectMake(15, 0, SCREEN_WIDTH - 30, 60) Text:path];
    lab_path.numberOfLines = 0;
    [pathFullView addSubview:lab_path];
    self.listView.tableHeaderView = pathFullView;
    
    UIView *foot = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
    self.listView.tableFooterView = foot;

 
}

- (void)buildViewContent {
    
    // 获取沙盒根目录路径
    NSString *homeDir = NSHomeDirectory();
    
    
    TBDirctoryModel *info_d = [[TBDirctoryModel alloc] init];
    info_d.name = @"Documents";
    info_d.mb = [TBFileManager sizeAtPath: [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES) firstObject]];
    
    TBDirctoryModel *info_l = [[TBDirctoryModel alloc] init];
    info_l.name = @"Library";
    info_l.mb = [TBFileManager sizeAtPath:[NSSearchPathForDirectoriesInDomains(NSLibraryDirectory,NSUserDomainMask,YES) lastObject]];
    
    TBDirctoryModel *info_t = [[TBDirctoryModel alloc] init];
    info_t.name = @"tmp";
    info_t.mb = [TBFileManager sizeAtPath:NSTemporaryDirectory()];
    //SystemData less
    self.dataArray = @[info_d,info_l,info_t];

//    // 获取Documents目录路径
//    NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES) firstObject];
//    [NSString folderSizeAtPath:chadocDir];
//    [NSFileManager isFileDirectoryWithF];
//    //获取Library的目录路径
//    NSString *libDir = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory,NSUserDomainMask,YES) lastObject];
    
    // 获取cache目录路径
//    NSString *cachesDir = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask,YES) firstObject];
    
    // 获取tmp目录路径
//    NSString *tmpDir =NSTemporaryDirectory();
    
    // 获取应用程序程序包中资源文件路径的方法：
//    NSString *bundle = [[NSBundle mainBundle] bundlePath];
    
//    NSLog(@"homeDir=%@ \n docDir=%@ \n libDir=%@ \n cachesDir=%@ \n tmpDir=%@ \n bundle=%@", homeDir,docDir, libDir, cachesDir, tmpDir, bundle);

}

//mb
- (float)folderSizeAtPath:(NSString *)folderPath{
    NSFileManager* manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:folderPath]){
       return 0;
    }
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:folderPath] objectEnumerator];
    NSString* fileName;
    long long folderSize = 0;
    while ((fileName = [childFilesEnumerator nextObject]) != nil){
        NSString* fileAbsolutePath = [folderPath stringByAppendingPathComponent:fileName];
        folderSize += [self fileSizeAtPath:fileAbsolutePath];
    }
    return folderSize/(1024.0*1024.0);
}

- (long long) fileSizeAtPath:(NSString*) filePath{
    NSFileManager* manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]){
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0;
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
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
    }
    TBDirctoryModel *m = [self.dataArray objectAtIndex:indexPath.row];
    cell.textLabel.text = m.name;
    cell.detailTextLabel.text = m.mb;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    UIViewController *ctr ;
    if (indexPath.row == 0) {
//        ctr = [[TBDirctoryController alloc] init];
    }else if(indexPath.row == 1){
        //        ctr = [[SculptDrawImgController alloc] init];
    }else if(indexPath.row == 2){
        //        ctr = [[SculptSysController alloc] init];
    }
//    [self.navigationController pushViewController:ctr animated:YES];
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
