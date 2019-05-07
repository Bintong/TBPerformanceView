//
//  TBPerRuntimeUtils.m
//  TBPerformanceView
//
//  Created by BinTong on 2019/4/12.
//

#import "TBPerRuntimeUtils.h"

@implementation TBPerRuntimeUtils

+ (SEL)swizzledSelectorForSelector:(SEL)selector {
    return NSSelectorFromString([NSString stringWithFormat:@"_perform_swizzle_%x_%@", arc4random(), NSStringFromSelector(selector)]);
}

+ (void)replaceImplementationOfKnownSelector:(SEL)originalSelector onClass:(Class)class withBlock:(id)block swizzledSelector:(SEL)swizzledSelector
{

    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    if (!originalMethod) {
        return;
    }
    
    IMP implementation = imp_implementationWithBlock(block);
    class_addMethod(class, swizzledSelector, implementation, method_getTypeEncoding(originalMethod));
    Method newMethod = class_getInstanceMethod(class, swizzledSelector);
    method_exchangeImplementations(originalMethod, newMethod);
}


+ (void)replaceImplementationOfSelector:(SEL)selector
                           withSelector:(SEL)swizzledSelector
                               forClass:(Class)cls
                  withMethodDescription:(struct objc_method_description)methodDescription
                    implementationBlock:(id)implementationBlock
                         undefinedBlock:(id)undefinedBlock {
    if ([self instanceRespondsButDoseNotImplementSeletor:selector class:cls]) {
        return;
    }
    
    IMP implementation = imp_implementationWithBlock((id)([cls instancesRespondToSelector:selector] ? implementationBlock : undefinedBlock));
    
    
    Method oldMethod = class_getInstanceMethod(cls, selector);
    if (oldMethod) {
        class_addMethod(cls, swizzledSelector, implementation, methodDescription.types);
        Method newMethod = class_getInstanceMethod(cls, swizzledSelector);
        method_exchangeImplementations(oldMethod, newMethod);
    } else {
        class_addMethod(cls, selector, implementation, methodDescription.types);
    };
}

+ (BOOL)instanceRespondsButDoseNotImplementSeletor:(SEL)selecotr class:(Class)cls {
    if ([cls instancesRespondToSelector:selecotr]) {
        unsigned int numMethods = 0;
        Method *methods = class_copyMethodList(cls, &numMethods);
        
        BOOL implementsSelector = NO;
        for (int index = 0; index < numMethods; index++) {
            SEL methodSelector = method_getName(methods[index]);
            if (selecotr == methodSelector) {implementsSelector = YES; break;};
        }
        
        free(methods);
        if (!implementsSelector) {
            return YES;
        }
    }
    return NO;
}
//[TBPerRuntimeUtils sniffWithOutDuplicationForObject:session selector:selector sniffingBlock:^{
//    undefineBlock(slf, session, dataTask, data);
//} originalImplementationBlock:^{
//    ((void(*)(id ,SEL , id, id ,id))objc_msgSend)(slf,swizzledSelector,session,dataTask,data);
//}];

+ (void)sniffWithOutDuplicationForObject:(NSObject *)object selector:(SEL)selector sniffingBlock:(void (^)(void))sniffingBlock originalImplementationBlock:(void (^)(void))originalBlock {
    if (!object) {
        originalBlock(); //no inject
        return;
    };
    
    const void *key = selector;
    if (!objc_getAssociatedObject(object, key)) {
        sniffingBlock();
    }
    objc_setAssociatedObject(object, key, @YES, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    originalBlock();
    objc_setAssociatedObject(object, key, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
@end
