//
//  NSDictionary+LMSafeObjectForKey.m
//  NewConnect
//
//  Created by BinTong on 2018/4/10.
//  Copyright © 2018年 connect. All rights reserved.
//

#import "NSDictionary+LMSafeObjectForKey.h"

@implementation NSDictionary (LMSafeObjectForKey)


-(id)safeObjectForKey:(NSString*) key{
    id object = [self objectForKey:key];
    if ([object isKindOfClass:[NSNull class]]) {
        object = nil;
    }
    return object;
}

@end
