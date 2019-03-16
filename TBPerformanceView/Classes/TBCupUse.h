//
//  TBCupUse.h
//  TimeAndLoop
//
//  Created by BinTong on 2019/2/21.
//  Copyright © 2019 TongBin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TBCupUse : NSObject

+ (TBCupUse *)sharedInstance;

- (float)cpuUse;

@end

NS_ASSUME_NONNULL_END
