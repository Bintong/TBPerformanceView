//
//  NSDictionary+LMSafeObjectForKey.h
//  NewConnect
//
//  Created by BinTong on 2018/4/10.
//  Copyright © 2018年 connect. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (LMSafeObjectForKey)

-(id)safeObjectForKey:(NSString*)key;

@end
