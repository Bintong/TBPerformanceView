//
//  LMCheckObject.h
//  NewConnect
//
//  Created by BinTong on 2018/4/2.
//  Copyright © 2018年 connect. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LMCheckObject : NSObject

+ (BOOL)checkStringValid:(NSString *)string;//判断字符串长度是否大于0


+ (BOOL)checkArrayValid:(NSArray *)array;//判断数组长度是否大于0


+ (BOOL)checkDictionaryValid:(NSDictionary *)dictionary;//判断字典长度是否大于0


@end
