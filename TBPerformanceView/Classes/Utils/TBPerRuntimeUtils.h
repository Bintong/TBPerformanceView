//
//  TBPerRuntimeUtils.h
//  TBPerformanceView
//
//  Created by BinTong on 2019/4/12.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>
NS_ASSUME_NONNULL_BEGIN

@interface TBPerRuntimeUtils : NSObject

+ (SEL)swizzledSelectorForSelector:(SEL)selector;

+ (BOOL)instanceRespondsButDoseNotImplementSeletor:(SEL)selecotr class:(Class)cls;

+ (void)replaceImplementationOfSelector:(SEL)selector
                           withSelector:(SEL)swizzledSelector
                               forClass:(Class)cls
                  withMethodDescription:(struct objc_method_description)methodDescription
                    implementationBlock:(id)implementationBlock
                         undefinedBlock:(id)undefinedBlock;


+ (void)replaceImplementationOfKnownSelector:(SEL)originalSelector
                                     onClass:(Class)class withBlock:(id)block swizzledSelector:(SEL)swizzledSelector;


+ (void)sniffWithOutDuplicationForObject:(NSObject *)object selector:(SEL)selector sniffingBlock:(void (^)(void))sniffingBlock originalImplementationBlock:(void (^)(void))originalBlock;
@end

NS_ASSUME_NONNULL_END
