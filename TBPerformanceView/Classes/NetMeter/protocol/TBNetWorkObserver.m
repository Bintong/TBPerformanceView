//
//  TBNetWorkObserver.m
//  TBPerformanceView
//
//  Created by BinTong on 2019/4/12.
//

#import "TBNetWorkObserver.h"
#import <objc/runtime.h>
#import <objc/message.h>
#import <dispatch/queue.h>
#import "TBPerRuntimeUtils.h"
#import "TBInternalRequestState.h"
#import "TBNetMonitorManager.h"

NSString *const kTBNetworkObserverEnabledStateChangedNotification = @"kTBNetworkObserverEnabledStateChangedNotification";
static NSString *const kTBNetworkObserverEnabledDefaultsKey = @"com.tb.TBNetworkObserver.enableOnLaunch";
typedef void (^NSURLSessionAsyncCompletion)(id fileURLOrData, NSURLResponse *response, NSError *error);


@interface TBNetWorkObserver ()

@property (nonatomic, strong) NSMutableDictionary<NSString *, TBInternalRequestState *> *requestStatesForRequestIDs;
@property (nonatomic, strong) dispatch_queue_t queue;

@property (strong, nonatomic) NSURLRequest *tb_request;
@property (strong, nonatomic) NSURLSessionTask *tb_sessionTask;
@property (strong, nonatomic) NSMutableData *tb_data;

@end

@implementation TBNetWorkObserver

#pragma mark - Publich Function
+ (void)load {
    
}

#pragma mark - self Init

+ (instancetype)sharedObserver {
    static TBNetWorkObserver *sharedObserver = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedObserver = [[[self class] alloc] init];
    });
    return sharedObserver;
}

- (id)init {
    self = [super init];
    if (self) {
        self.requestStatesForRequestIDs = [NSMutableDictionary dictionary];
        self.queue = dispatch_queue_create("com.observer.net", DISPATCH_QUEUE_SERIAL);
        self.tb_data = [NSMutableData data];

    }
    return self;
}

+ (NSString *)nextRequestID {
    return [[NSUUID UUID] UUIDString];
}


+ (NSString *)mechanismFromClassMethod:(SEL)selector onClass:(Class)class
{
    return [NSString stringWithFormat:@"+[%@ %@]", NSStringFromClass(class), NSStringFromSelector(selector)];
}

//面向切面编程  iOS 中 AOP 的实现是基于 Objective-C 的 Runtime 机制，实现 Hook 的三种方式分别为：Method Swizzling、NSProxy 和 Fishhook。前两者适用于 Objective-C 实现的库，如 NSURLConnection 和 NSURLSession ，Fishhook 则适用于 C 语言实现的库，如 CFNetwork
+ (void)startUpNetworkObserver {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [TBNetWorkObserver injectIntoAllNSURLConnectionDelegateClasses];
    });
    
}

#pragma mark - Delegate Injection

+ (void)injectIntoAllNSURLConnectionDelegateClasses {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        const SEL selectors[] = {
            //目前仅仅 nsurlsession
            @selector(URLSession:task:willPerformHTTPRedirection:newRequest:completionHandler:),
            @selector(URLSession:dataTask:didReceiveData:),
            @selector(URLSession:dataTask:didReceiveResponse:completionHandler:),
            @selector(URLSession:task:didCompleteWithError:),
            @selector(URLSession:dataTask:didBecomeDownloadTask:),
            @selector(URLSession:downloadTask:didWriteData:totalBytesWritten:totalBytesExpectedToWrite:),
            @selector(URLSession:downloadTask:didFinishDownloadingToURL:)
        };
        
        const int numSelectors = sizeof(selectors) / sizeof(SEL);
        Class *classes = NULL;
        int numClasses = objc_getClassList(NULL, 0);
        if (numClasses > 0) {
            classes = (__unsafe_unretained Class *)malloc(sizeof(Class) *numClasses);
            numClasses = objc_getClassList(classes, numClasses);
            for (NSInteger classIndex = 0; classIndex < numClasses; ++classIndex) {
                Class class = classes[classIndex];
                if (class == [TBNetWorkObserver class]) {
                    continue;
                }
                BOOL isOk = class_conformsToProtocol(class, @protocol(NSURLSessionDelegate));
                if (isOk) {
                    [self injectIntoDelegateClass:class];
                }
//
//                if ([class conformsToProtocol:@protocol(NSURLSessionTaskDelegate)] || [class conformsToProtocol:@protocol(NSURLSessionDataDelegate)]) {
//                    //
//                    [self injectIntoDelegateClass:class];
//                }

//
//                unsigned int methodCount = 0;
//                Method *methods = class_copyMethodList(class, &methodCount);
//                BOOL matchingSelectorFound = NO;
//                for (unsigned int methodIndex = 0;methodIndex < methodCount; methodIndex ++) {
//
//                    for (int selectorIndex = 0; selectorIndex < numSelectors; selectorIndex ++) {
//                        if (method_getName(methods[methodIndex]) == selectors[selectorIndex]) {
//                            [self injectIntoDelegateClass:class];
//                            matchingSelectorFound = YES;
//                            break;
//                        }
//                    }
//                    if (matchingSelectorFound) {
//                        break;
//                    }
//                }
//                free(methods);
            }
            
            free(classes);
        }
        
        
        [self injectIntoNSURLSessionTaskResume];
        [self injectIntoNSURLSessionAsyncDataAndDownloadTaskMethods];
        
    
    });
}

+ (void)injectIntoDelegateClass:(Class)cls {
    
    // Sessions
    [self injectTaskWillPerformHTTPRedirectionIntoDelegateClass:cls];
    [self injectTaskDidReceiveDataIntoDelegateClass:cls];
    [self injectTaskDidReceiveResponseIntoDelegateClass:cls];
    [self injectTaskDidCompleteWithErrorIntoDelegateClass:cls];
    
    [self injectRespondsToSelectorIntoDelegateClass:cls];
    // Data tasks
    [self injectDataTaskDidBecomeDownloadTaskIntoDelegateClass:cls];
    
    // Download tasks
    [self injectDownloadTaskDidWriteDataIntoDelegateClass:cls];
//    [self injectDownloadTaskDidFinishDownloadingIntoDelegateClass:cls];
}

+ (void)injectTaskWillPerformHTTPRedirectionIntoDelegateClass:(Class)cls {
//    SEL selector = @selector(URLSession:task:willPerformHTTPRedirection:newRequest:completionHandler:);
//    SEL swizzledSelector = [TBPerRuntimeUtils swizzledSelectorForSelector:selector];
//
//    Protocol *protocol = @protocol(NSURLSessionTaskDelegate);
//    struct objc_method_description methodDescription = protocol_getMethodDescription(protocol, selector, NO, YES);
//
//    typedef void (^NSURLSessionWillPerformHTTPRedirectionBlock)(id <NSURLSessionTaskDelegate> slf, NSURLSessionTask *session, NSURLSessionTask *task ,NSHTTPURLResponse *response, NSURLRequest *newRequest, void(^completionHandler)(NSURLRequest *));
//    NSURLSessionWillPerformHTTPRedirectionBlock undefinedBlock = ^(id <NSURLSessionTaskDelegate> slf, NSURLSessionTask *session, NSURLSessionTask *task ,NSHTTPURLResponse *response, NSURLRequest *newRequest, void(^completionHandler)(NSURLRequest *)) {
//
//        NSLog(@"log request is %@",newRequest);
//        completionHandler(newRequest);
//    };
//
//    NSURLSessionWillPerformHTTPRedirectionBlock implementationBlock = ^(id <NSURLSessionTaskDelegate> slf, NSURLSessionTask *session, NSURLSessionTask *task ,NSHTTPURLResponse *response, NSURLRequest *newRequest, void(^completionHandler)(NSURLRequest *)) {
//        [TBPerRuntimeUtils sniffWithOutDuplicationForObject:session selector:selector sniffingBlock:^{
//            undefinedBlock(slf,session,task,response,newRequest,completionHandler);
//        } originalImplementationBlock:^{
//            ((id(*)(id, SEL, id, id, id, id, void(^)(NSURLRequest *)))objc_msgSend)(slf, swizzledSelector, session, task, response, newRequest, completionHandler);
//        }];
//    };
//
//    [TBPerRuntimeUtils replaceImplementationOfSelector:selector withSelector:swizzledSelector forClass:cls withMethodDescription:methodDescription implementationBlock:implementationBlock  undefinedBlock:undefinedBlock];
    
}


+ (void)injectIntoNSURLSessionAsyncDataAndDownloadTaskMethods {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [NSURLSession class];
        SEL selector = @selector(dataTaskWithRequest:);
        SEL swizzledSelector = [TBPerRuntimeUtils swizzledSelectorForSelector:selector];
        
        NSURLSessionTask *(^asyncDataOrDownloadSwizzleBlock)(Class, id) = ^NSURLSessionTask *(Class slf, id argument){
            NSURLSessionTask *task = nil;
            task = ((id(*)(id, SEL, id))objc_msgSend)(slf, swizzledSelector, argument);
//            NSLog(@"recode task is %@ -- header is %@",task.originalRequest,task.originalRequest.allHTTPHeaderFields);
            
            return task;
        };
        [TBPerRuntimeUtils replaceImplementationOfKnownSelector:selector onClass:class withBlock:asyncDataOrDownloadSwizzleBlock swizzledSelector:swizzledSelector];
        
    });
}

static char const * const kRequestIDKey = "kRequestIDKey";


+ (void)injectIntoNSURLSessionAsyncDataAndDownloadTaskMethods_Completion {
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        Class class = [NSURLSession class];
//        const SEL selectors[] = {
//            @selector(dataTaskWithRequest:completionHandler:),
//            @selector(dataTaskWithURL:completionHandler:),
//            @selector(downloadTaskWithRequest:completionHandler:),
//            @selector(downloadTaskWithResumeData:completionHandler:),
//            @selector(downloadTaskWithURL:completionHandler:)
//        };
//
//        const int numSelectors = sizeof(selectors) / sizeof(SEL);
//        for (int selectorIndex = 0 ; selectorIndex < numSelectors; selectorIndex++) {
//            SEL selector = selectors[selectorIndex];
//            SEL swizzledSelector = [TBPerRuntimeUtils swizzledSelectorForSelector:selector];
//            if ([TBPerRuntimeUtils instanceRespondsButDoseNotImplementSeletor:selector class:class]) {
//                class = [[NSURLSession sharedSession] class];
//            }
//
//            NSURLSessionTask *(^asyncDataOrDownloadSwizzleBlock)(Class, id, NSURLSessionAsyncCompletion) = ^NSURLSessionTask *(Class slf, id argument, NSURLSessionAsyncCompletion completion){
//                NSURLSessionTask *task = nil;
//                if (completion) {
//                    NSString *requestID = [self nextRequestID];
////                    NSString *mechanism = [self mechanismFromClassMethod:selector onClass:class];
//                    NSURLSessionAsyncCompletion completionWrapper = ^(id fileURLOrData, NSURLResponse *response, NSError *error) {
//                        NSLog(@"---");
//                    };
//
//                    task = ((id(*)(id, SEL, id, id))objc_msgSend)(slf, swizzledSelector, argument, completionWrapper);
//                    objc_setAssociatedObject(task, kRequestIDKey, requestID, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
//                } else {
//                     task = ((id(*)(id, SEL, id, id))objc_msgSend)(slf, swizzledSelector, argument,completion);
//                }
//                return task;
//            };
//            [TBPerRuntimeUtils replaceImplementationOfKnownSelector:selector onClass:class withBlock:asyncDataOrDownloadSwizzleBlock swizzledSelector:swizzledSelector];
//        }
//    });
}
//- (void)URLSession:(NSURLSession *)session
//          dataTask:(NSURLSessionDataTask *)dataTask
//    didReceiveData:(NSData *)data

+ (void)injectTaskDidReceiveDataIntoDelegateClass:(Class)cls {
    //data
    
    SEL selector = @selector(URLSession:dataTask:didReceiveData:);
    SEL swizzledSelector = [TBPerRuntimeUtils swizzledSelectorForSelector:selector];
    
    Protocol *protocol = @protocol(NSURLSessionDataDelegate);
    struct objc_method_description methodDescription = protocol_getMethodDescription(protocol, selector, NO, YES);
    typedef void (^NSURLSessionDidReceiveDataBlock)(id <NSURLSessionDataDelegate> slf, NSURLSession *session , NSURLSessionTask *dataTask, NSData *data);
    
    NSURLSessionDidReceiveDataBlock undefineBlock = ^(id <NSURLSessionDataDelegate> slf , NSURLSession *session, NSURLSessionTask *dataTask, NSData *data) {
        [[TBNetWorkObserver sharedObserver] performBlock:^{
            [[TBNetWorkObserver sharedObserver].tb_data appendData:data];
        }];
       
    };
    NSURLSessionDidReceiveDataBlock implementationBlock = ^(id <NSURLSessionDataDelegate> slf , NSURLSession *session, NSURLSessionTask *dataTask, NSData *data) {
        [TBPerRuntimeUtils sniffWithOutDuplicationForObject:session selector:selector sniffingBlock:^{
            undefineBlock(slf, session, dataTask, data);
        } originalImplementationBlock:^{
            ((void(*)(id ,SEL , id, id ,id))objc_msgSend)(slf,swizzledSelector,session,dataTask,data);
        }];
    };
    [TBPerRuntimeUtils replaceImplementationOfSelector:selector withSelector:swizzledSelector forClass:cls withMethodDescription:methodDescription implementationBlock:implementationBlock undefinedBlock:undefineBlock];
}

+ (void)injectTaskDidReceiveResponseIntoDelegateClass:(Class)cls {
    
    SEL selector = @selector(URLSession:dataTask:didReceiveResponse:completionHandler:);
    SEL swizzledSelector = [TBPerRuntimeUtils swizzledSelectorForSelector:selector];
    Protocol *protocol = @protocol(NSURLSessionDataDelegate);
    struct objc_method_description methodDescription = protocol_getMethodDescription(protocol, selector, NO, YES);
    typedef void (^NSURLSessionDidReceiveResponseBlock)(id <NSURLSessionDelegate> slf, NSURLSession *session, NSURLSessionDataTask *dataTask, NSURLResponse *response, void(^completionHandler)(NSURLSessionResponseDisposition disposition));
    
    NSURLSessionDidReceiveResponseBlock undefinedBlock = ^(id <NSURLSessionDelegate> slf, NSURLSession *session, NSURLSessionDataTask *dataTask, NSURLResponse *response, void(^completionHandler)(NSURLSessionResponseDisposition disposition)) {
//        [TBNetWorkObserver sharedObserver].tb_response = response;
//        [TBNetWorkObserver sharedObserver].tb_request = dataTask.currentRequest;
//        [[TBNetMonitorManager sharedInstance] handleRequest:[TBNetWorkObserver sharedObserver].tb_request response:[TBNetWorkObserver sharedObserver].tb_response andData:[TBNetWorkObserver sharedObserver].tb_data];
        completionHandler(NSURLSessionResponseAllow);
        NSLog(@"recode is Did didReceiveResponse  completionHandler task %@",dataTask.response);

    };
    
    NSURLSessionDidReceiveResponseBlock implementationBlock = ^(id <NSURLSessionDelegate> slf, NSURLSession *session, NSURLSessionDataTask *dataTask, NSURLResponse *response, void(^completionHandler)(NSURLSessionResponseDisposition disposition)) {
        [TBPerRuntimeUtils sniffWithOutDuplicationForObject:session selector:selector sniffingBlock:^{
            undefinedBlock(slf,session,dataTask,response,completionHandler);
        } originalImplementationBlock:^{
            ((void(*)(id, SEL, id, id, id, void(^)(NSURLSessionResponseDisposition)))objc_msgSend)(slf, swizzledSelector, session, dataTask, response, completionHandler);
        }];
    };
    
    [TBPerRuntimeUtils replaceImplementationOfSelector:selector withSelector:swizzledSelector forClass:cls withMethodDescription:methodDescription implementationBlock:implementationBlock undefinedBlock:undefinedBlock];
    
    
}


//- (void)URLSession:(__unused NSURLSession *)session
//              task:(NSURLSessionTask *)task
//didCompleteWithError:(NSError *)error
+ (void)injectTaskDidCompleteWithErrorIntoDelegateClass:(Class)cls {
  
    //data finish
    SEL selector = @selector(URLSession:task:didCompleteWithError:);
    SEL swizzledSelector = [TBPerRuntimeUtils swizzledSelectorForSelector:selector];
    
    Protocol *protocol = @protocol(NSURLSessionTaskDelegate);
    struct objc_method_description methodDescription = protocol_getMethodDescription(protocol, selector, NO, YES);
    
    typedef void (^NSURLSessionTaskDidCompleteWithErrorBlock)(id <NSURLSessionTaskDelegate> slf, NSURLSession *session, NSURLSessionTask *task, NSError *error);
    NSURLSessionTaskDidCompleteWithErrorBlock undefineBlock = ^(id <NSURLSessionTaskDelegate> slf, NSURLSession *session, NSURLSessionTask *task, NSError *error) {
        [[TBNetWorkObserver sharedObserver] performBlock:^{
            if (!error) {
                [TBNetWorkObserver sharedObserver].tb_sessionTask = task;
                [TBNetWorkObserver sharedObserver].tb_request = task.currentRequest;
                [[TBNetMonitorManager sharedInstance] handleRequest:[TBNetWorkObserver sharedObserver].tb_request task:task andData:[TBNetWorkObserver sharedObserver].tb_data];
                [[TBNetWorkObserver sharedObserver].tb_data setData:nil];
            }
            NSLog(@"recode is Did Complete task %@",task.response);
        }];
        
    };
    
    
    
    NSURLSessionTaskDidCompleteWithErrorBlock implementationBlock = ^(id <NSURLSessionTaskDelegate> slf, NSURLSession *session, NSURLSessionTask *task, NSError *error) {
        [TBPerRuntimeUtils sniffWithOutDuplicationForObject:session selector:selector sniffingBlock:^{
            undefineBlock(slf, session, task, error);
        } originalImplementationBlock:^{
            ((void(*)(id, SEL, id, id, id))objc_msgSend)(slf, swizzledSelector, session, task, error);
        }];
    };
    
    [TBPerRuntimeUtils replaceImplementationOfSelector:selector withSelector:swizzledSelector forClass:cls withMethodDescription:methodDescription implementationBlock:implementationBlock undefinedBlock:undefineBlock];
}

+ (void)injectRespondsToSelectorIntoDelegateClass:(Class)cls {
    SEL selector = @selector(respondsToSelector:);
    SEL swizzledSelector = [TBPerRuntimeUtils swizzledSelectorForSelector:selector];
    
    Method method = class_getInstanceMethod(cls, selector);
    struct objc_method_description methodDescription = *method_getDescription(method);
    
    BOOL (^undefinedBlock)(id <NSURLSessionTaskDelegate>, SEL) = ^(id slf, SEL sel) {
        return YES;
    };
    
    BOOL (^implementationBlock)(id <NSURLSessionTaskDelegate>, SEL) = ^(id <NSURLSessionTaskDelegate> slf, SEL sel) {
        if (sel == @selector(URLSession:dataTask:didReceiveResponse:completionHandler:)) {
            return undefinedBlock(slf, sel);
        }
        return ((BOOL(*)(id, SEL, SEL))objc_msgSend)(slf, swizzledSelector, sel);
    };
    
    [TBPerRuntimeUtils replaceImplementationOfSelector:selector withSelector:swizzledSelector forClass:cls withMethodDescription:methodDescription implementationBlock:implementationBlock undefinedBlock:undefinedBlock];
}

+ (void)injectDataTaskDidBecomeDownloadTaskIntoDelegateClass:(Class)cls {
    SEL selector = @selector(URLSession:dataTask:didBecomeDownloadTask:);
    SEL swizzledSelector = [TBPerRuntimeUtils swizzledSelectorForSelector:selector];
    
    Protocol *protocol = @protocol(NSURLSessionDataDelegate);
    
    struct objc_method_description methodDescription = protocol_getMethodDescription(protocol, selector, NO, YES);
    
    typedef void (^NSURLSessionDidBecomeDownloadTaskBlock)(id <NSURLSessionDataDelegate> slf, NSURLSession *session, NSURLSessionDataTask *dataTask, NSURLSessionDownloadTask *downloadTask);
    
    NSURLSessionDidBecomeDownloadTaskBlock undefinedBlock = ^(id <NSURLSessionDataDelegate> slf, NSURLSession *session, NSURLSessionDataTask *dataTask, NSURLSessionDownloadTask *downloadTask) {
      
//        NSLog(@"record URLSession:dataTask:didBecomeDownloadTask:");
    };
    
    NSURLSessionDidBecomeDownloadTaskBlock implementationBlock = ^(id <NSURLSessionDataDelegate> slf, NSURLSession *session, NSURLSessionDataTask *dataTask, NSURLSessionDownloadTask *downloadTask) {
        [TBPerRuntimeUtils sniffWithOutDuplicationForObject:session selector:selector sniffingBlock:^{
            undefinedBlock(slf, session, dataTask, downloadTask);
        } originalImplementationBlock:^{
            ((void(*)(id, SEL, id, id, id))objc_msgSend)(slf, swizzledSelector, session, dataTask, downloadTask);
        }];
    };
    
    [TBPerRuntimeUtils replaceImplementationOfSelector:selector withSelector:swizzledSelector forClass:cls withMethodDescription:methodDescription implementationBlock:implementationBlock undefinedBlock:undefinedBlock];
}

+ (void)injectDownloadTaskDidWriteDataIntoDelegateClass:(Class)cls {
    
}

+ (void)injectDownloadTaskDidFinishDownloadingIntoDelegateClass:(Class)cls {
    
}


#pragma mark - inject

+ (void)injectIntoNSURLSessionTaskResume {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = Nil;
        if (![[NSProcessInfo processInfo] respondsToSelector:@selector(operatingSystemVersion)]) {
            class = NSClassFromString([@[@"__", @"NSC", @"FLocalS", @"ession", @"Task"] componentsJoinedByString:@""]);
        }else if([[NSProcessInfo processInfo] operatingSystemVersion].majorVersion < 9){
            class = [NSURLSessionTask class];
        }else {
            class = NSClassFromString([@[@"__", @"NSC", @"FURLS", @"ession", @"Task"] componentsJoinedByString:@""]);
        }
        SEL selector = @selector(resume);
        SEL swizzledSelector = [TBPerRuntimeUtils swizzledSelectorForSelector:selector];
        Method originalResume = class_getInstanceMethod(class, selector);
        void (^swizzleBlock)(NSURLSessionTask *) = ^(NSURLSessionTask *slf){
            ((void(*)(id , SEL))objc_msgSend)(slf, swizzledSelector);
        };
        IMP implementation = imp_implementationWithBlock(swizzleBlock);
        class_addMethod(class, swizzledSelector, implementation, method_getTypeEncoding(originalResume));
        Method newResume = class_getInstanceMethod(class, swizzledSelector);
        method_exchangeImplementations(originalResume, newResume);
    });
}



#pragma mark - Private Methods

- (void)performBlock:(dispatch_block_t)block {
        dispatch_async(_queue, block);
}

@end


