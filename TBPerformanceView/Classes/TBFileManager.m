//
//  TBFileManager.m
//  TBPerformanceView
//
//  Created by BinTong on 2019/3/27.
//

#import "TBFileManager.h"

@implementation TBFileManager

+ (NSString *)documentsPath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return paths[0];
}

+ (NSString *)tempPath {
    return NSTemporaryDirectory ();
}

+ (BOOL)createDirectory:(NSString *)directory {
    NSFileManager *fm = [NSFileManager defaultManager];
    // if directory not exist, then create
    if (![fm fileExistsAtPath:directory]) {
        return [fm createDirectoryAtPath:directory withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return YES;
}

+ (BOOL)removeDirectory:(NSString *)directory {
    NSFileManager *fm = [NSFileManager defaultManager];
    if ([fm fileExistsAtPath:directory]) {
        return [fm removeItemAtPath:directory error:nil];
    }
    return YES;
}

+ (NSArray *)subContentFiles:(NSString *)path {
    NSFileManager *fm = [NSFileManager defaultManager];
    BOOL isDir = YES;
    if (![fm fileExistsAtPath:path isDirectory:&isDir]) {
        return 0;
    };
    unsigned long long fileSize = 0;
    // directory
    if (isDir) {
        NSDirectoryEnumerator *enumerator = [fm enumeratorAtPath:path];
        NSArray *a = [enumerator valueForKey:@"contents"];
        return a;
       
    }
}

+ (NSString *)makeDetailFilesInfo:(NSString *)path {
    NSFileManager *fm = [NSFileManager defaultManager];
    BOOL isDir = YES;
    if (![fm fileExistsAtPath:path isDirectory:&isDir]) {
        return 0;
    };
    unsigned long long fileSize = 0;
    NSMutableString *fullString = [[NSMutableString alloc] initWithString:@"All Data at this path \n"];

    if (isDir) {
        NSDirectoryEnumerator *enumerator = [fm enumeratorAtPath:path];
        while (enumerator.nextObject) {
            [fullString appendFormat: [NSString stringWithFormat:@"%@--%@ \n",enumerator.nextObject, [TBFileManager fileSizeStringConversionWithNumber:enumerator.fileAttributes.fileSize]]];
        }
        NSLog(@"%@" ,fullString);
        
    }
    return fullString;
}

+ (NSString *)sizeAtPath:(NSString *)path {
    NSFileManager *fm = [NSFileManager defaultManager];
    BOOL isDir = YES;
    if (![fm fileExistsAtPath:path isDirectory:&isDir]) {
        return 0;
    };
    unsigned long long fileSize = 0;
    // directory
    if (isDir) {
        NSDirectoryEnumerator *enumerator = [fm enumeratorAtPath:path];
        while (enumerator.nextObject) {
            fileSize += enumerator.fileAttributes.fileSize;
        }
    } else {
        // file
        fileSize = [fm attributesOfItemAtPath:path error:nil].fileSize;
    }
    return [TBFileManager fileSizeStringConversionWithNumber:fileSize];
}


+ (NSString *)fileSizeStringConversionWithNumber:(double)fileSize
{
    NSString *message = nil;
    
    // 1MB = 1024KB 1KB = 1024B
    double size = fileSize;
    if (size > (1024 * 1024))
    {
        size = size / (1024 * 1024);
        message = [NSString stringWithFormat:@"%.2fM", size];
    }
    else if (size > 1024)
    {
        size = size / 1024;
        message = [NSString stringWithFormat:@"%.2fKB", size];
    }
    else if (size > 0.0)
    {
        message = [NSString stringWithFormat:@"%.2fB", size];
    }
    
    return message;
}

@end
