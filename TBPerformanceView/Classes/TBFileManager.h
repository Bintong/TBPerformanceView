//
//  TBFileManager.h
//  TBPerformanceView
//
//  Created by BinTong on 2019/3/27.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TBFileManager : NSObject

+ (NSString *)sizeAtPath:(NSString *)path;
+ (NSArray *)subContentFiles:(NSString *)path;
+ (NSString *)makeDetailFilesInfo:(NSString *)path;

@end

NS_ASSUME_NONNULL_END
