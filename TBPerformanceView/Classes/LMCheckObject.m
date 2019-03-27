//
//  LMCheckObject.m
//  NewConnect
//
//  Created by BinTong on 2018/4/2.
//  Copyright © 2018年 connect. All rights reserved.
//

#import "LMCheckObject.h"

@implementation LMCheckObject

+ (BOOL)checkStringValid:(NSString *)string {
    
    if (string && [string isKindOfClass:[NSString class]])
    {
        NSString *str2 = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];

        
        if (0 < str2.length)
        {
            return YES;
        }
    }
    
    return NO;
}

+ (BOOL)checkArrayValid:(NSArray *)array {
    
    if (array && [array isKindOfClass:[NSArray class]])
    {
        if (0 < array.count)
        {
            return YES;
        }
    }
    
    return NO;
}

+ (BOOL)checkDictionaryValid:(NSDictionary *)dictionary {
    
    if (dictionary && [dictionary isKindOfClass:[NSDictionary class]])
    {
        if (0 < dictionary.count)
        {
            return YES;
        }
    }
    
    return NO;
}

@end
