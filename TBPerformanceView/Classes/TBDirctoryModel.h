//
//  TBDirctoryModel.h
//  TBPerformanceView
//
//  Created by BinTong on 2019/3/27.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TBDirctoryModel : NSObject

@property (copy,nonatomic)NSString *name;
@property (copy,nonatomic)NSString *mb;
@property (strong,nonatomic) NSArray *subfiles;

@property (copy,nonatomic)NSString *subString;


@end

NS_ASSUME_NONNULL_END
