//
//  TBDirctoryController.m
//  TBPerformanceView
//
//  Created by BinTong on 2019/3/25.
//

#import "TBDirctoryController.h"
#import "UILabel+wpadd.h"
@interface TBDirctoryController ()

@end

@implementation TBDirctoryController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self buildViewContent];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)buildViewContent {
    
    NSString *path = NSHomeDirectory();
    UILabel *lab_path  = [UILabel labelWithFontSize:12 FontColor:[UIColor blackColor] frame:CGRectMake(15, 100, SCREEN_WIDTH - 30, 60) Text:path];
    lab_path.numberOfLines = 0;
    [self.view addSubview:lab_path];
    
    // 获取沙盒根目录路径
    NSString *homeDir = NSHomeDirectory();
    
 
    // 获取Documents目录路径
    NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES) firstObject];
    
    //获取Library的目录路径
    NSString *libDir = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory,NSUserDomainMask,YES) lastObject];
    
    // 获取cache目录路径
    NSString *cachesDir = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask,YES) firstObject];
    
    // 获取tmp目录路径
    NSString *tmpDir =NSTemporaryDirectory();
    
    // 获取应用程序程序包中资源文件路径的方法：
    NSString *bundle = [[NSBundle mainBundle] bundlePath];
    
    NSLog(@"homeDir=%@ \n docDir=%@ \n libDir=%@ \n cachesDir=%@ \n tmpDir=%@ \n bundle=%@", homeDir,docDir, libDir, cachesDir, tmpDir, bundle);

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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
