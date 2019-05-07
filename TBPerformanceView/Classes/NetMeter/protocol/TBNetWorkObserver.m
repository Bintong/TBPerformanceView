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

//@interface TBNetWorkObserver (NSURLConnectionHelpers)
//
//- (void)connection:(NSURLConnection *)connection willSendRequest:(NSURLRequest *)request redirectResponse:(NSURLResponse *)response delegate:(id <NSURLConnectionDelegate>)delegate;
//- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response delegate:(id <NSURLConnectionDelegate>)delegate;
//- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data delegate:(id <NSURLConnectionDelegate>)delegate;
//- (void)connectionDidFinishLoading:(NSURLConnection *)connection delegate:(id <NSURLConnectionDelegate>)delegate;
//- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error delegate:(id <NSURLConnectionDelegate>)delegate;
//- (void)connectionWillCancel:(NSURLConnection *)connection;
//
//@end

@interface TBNetWorkObserver (NSURLSessionTaskHelpers)

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task willPerformHTTPRedirection:(NSHTTPURLResponse *)response newRequest:(NSURLRequest *)request completionHandler:(void (^)(NSURLRequest *))completionHandler delegate:(id <NSURLSessionDelegate>)delegate;
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition disposition))completionHandler delegate:(id <NSURLSessionDelegate>)delegate;
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data delegate:(id <NSURLSessionDelegate>)delegate;
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
didBecomeDownloadTask:(NSURLSessionDownloadTask *)downloadTask delegate:(id <NSURLSessionDelegate>)delegate;
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error delegate:(id <NSURLSessionDelegate>)delegate;
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite delegate:(id <NSURLSessionDelegate>)delegate;
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location data:(NSData *)data delegate:(id <NSURLSessionDelegate>)delegate;

- (void)URLSessionTaskWillResume:(NSURLSessionTask *)task;

@end


@interface TBNetWorkObserver ()

@property (nonatomic, strong) NSMutableDictionary<NSString *, TBInternalRequestState *> *requestStatesForRequestIDs;
@property (nonatomic, strong) dispatch_queue_t queue;

@property (strong, nonatomic) NSURLRequest *tb_request;
@property (strong, nonatomic) NSURLResponse *tb_response;
@property (strong, nonatomic) NSMutableData *tb_data;


@end

@implementation TBNetWorkObserver

#pragma mark - Publich Function

- (void)monitoringNetwork {
    [TBNetWorkObserver injectIntoAllNSURLConnectionDelegateClasses];
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
    [self injectIntoAllNSURLConnectionDelegateClasses];
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
                
                unsigned int methodCount = 0;
                Method *methods = class_copyMethodList(class, &methodCount);
                BOOL matchingSelectorFound = NO;
                for (unsigned int methodIndex = 0;methodIndex < methodCount; methodIndex ++) {
                    for (int selectorIndex = 0; selectorIndex < numSelectors; selectorIndex ++) {
                        if (method_getName(methods[methodIndex]) == selectors[selectorIndex]) {
                            [self injectIntoDelegateClass:class];
                            matchingSelectorFound = YES;
                            break;
                        }
                    }
                    if (matchingSelectorFound) {
                        break;
                    }
                }
                free(methods);
            }
            
            free(classes);
        }
        
        [self injectIntoNSURLSessionTaskResume];
//        [self injectIntoNSURLSessionAsyncDataAndDownloadTaskMethods];
        [self testIntoNSURLSessionAsyncDataAndDownloadTaskMethods];
//        [self injectIntoNSURLSessionAsyncUploadTaskMethods];
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
    SEL selector = @selector(URLSession:task:willPerformHTTPRedirection:newRequest:completionHandler:);
    SEL swizzledSelector = [TBPerRuntimeUtils swizzledSelectorForSelector:selector];
//    session
//    The session containing the task whose request resulted in a redirect.
//    task
//    The task whose request resulted in a redirect.
//    response
//    An object containing the server’s response to the original request.
//    request
//    A URL request object filled out with the new location.
//    completionHandler
//    A block that your handler should call with either the value of the request parameter, a modified URL request object, or NULL to refuse the redirect and return the body of the redirect response.
    Protocol *protocol = @protocol(NSURLSessionTaskDelegate);
    struct objc_method_description methodDescription = protocol_getMethodDescription(protocol, selector, NO, YES);
    
    typedef void (^NSURLSessionWillPerformHTTPRedirectionBlock)(id <NSURLSessionTaskDelegate> slf, NSURLSessionTask *session, NSURLSessionTask *task ,NSHTTPURLResponse *response, NSURLRequest *newRequest, void(^completionHandler)(NSURLRequest *));
    NSURLSessionWillPerformHTTPRedirectionBlock undefinedBlock = ^(id <NSURLSessionTaskDelegate> slf, NSURLSessionTask *session, NSURLSessionTask *task ,NSHTTPURLResponse *response, NSURLRequest *newRequest, void(^completionHandler)(NSURLRequest *)) {
        
        NSLog(@"log request is %@",newRequest);
        completionHandler(newRequest);
    };
    
    NSURLSessionWillPerformHTTPRedirectionBlock implementationBlock = ^(id <NSURLSessionTaskDelegate> slf, NSURLSessionTask *session, NSURLSessionTask *task ,NSHTTPURLResponse *response, NSURLRequest *newRequest, void(^completionHandler)(NSURLRequest *)) {
        [TBPerRuntimeUtils sniffWithOutDuplicationForObject:session selector:selector sniffingBlock:^{
            undefinedBlock(slf,session,task,response,newRequest,completionHandler);
        } originalImplementationBlock:^{
            ((id(*)(id, SEL, id, id, id, id, void(^)(NSURLRequest *)))objc_msgSend)(slf, swizzledSelector, session, task, response, newRequest, completionHandler);
        }];
    };
    
    [TBPerRuntimeUtils replaceImplementationOfSelector:selector withSelector:swizzledSelector forClass:cls withMethodDescription:methodDescription implementationBlock:implementationBlock  undefinedBlock:undefinedBlock];
    
}
//
//- (NSURLSessionDataTask *)dataTaskWithRequest:(NSURLRequest *)request
//                               uploadProgress:(nullable void (^)(NSProgress *uploadProgress)) uploadProgressBlock
//                             downloadProgress:(nullable void (^)(NSProgress *downloadProgress)) downloadProgressBlock
//                            completionHandler:(nullable void (^)(NSURLResponse *response, id _Nullable responseObject,  NSError * _Nullable error))completionHandler


+ (void)testIntoNSURLSessionAsyncDataAndDownloadTaskMethods {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [NSURLSession class];
        SEL selector = @selector(dataTaskWithRequest:);
        SEL swizzledSelector = [TBPerRuntimeUtils swizzledSelectorForSelector:selector];
        
        NSURLSessionTask *(^asyncDataOrDownloadSwizzleBlock)(Class, id) = ^NSURLSessionTask *(Class slf, id argument){
            NSString *requestID = [self nextRequestID];
            NSString *mechanism = [self mechanismFromClassMethod:selector onClass:class];

            NSURLSessionTask *task = nil;
          
                task = ((id(*)(id, SEL, id))objc_msgSend)(slf, swizzledSelector, argument);
              NSLog(@"recode task is %@ -- header is %@",task.originalRequest,task.originalRequest.allHTTPHeaderFields);
            [TBNetWorkObserver sharedObserver].tb_request = task.originalRequest;

            return task;
            
        };
        [TBPerRuntimeUtils replaceImplementationOfKnownSelector:selector onClass:class withBlock:asyncDataOrDownloadSwizzleBlock swizzledSelector:swizzledSelector];
        
    });
}

+ (void)injectIntoNSURLSessionAsyncDataAndDownloadTaskMethods {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [NSURLSession class];
        const SEL selectors[] = {
            @selector(dataTaskWithRequest:completionHandler:),
            @selector(dataTaskWithURL:completionHandler:),
            @selector(downloadTaskWithRequest:completionHandler:),
            @selector(downloadTaskWithResumeData:completionHandler:),
            @selector(downloadTaskWithURL:completionHandler:)
        };
        
        const int numSelectors = sizeof(selectors) / sizeof(SEL);
        for (int selectorIndex = 0 ; selectorIndex < numSelectors; selectorIndex++) {
            SEL selector = selectors[selectorIndex];
            SEL swizzledSelector = [TBPerRuntimeUtils swizzledSelectorForSelector:selector];
            
            
            NSURLSessionTask *(^asyncDataOrDownloadSwizzleBlock)(Class, id, NSURLSessionAsyncCompletion) = ^NSURLSessionTask *(Class slf, id argument, NSURLSessionAsyncCompletion completion){
                NSURLSessionTask *task = nil;
                if (completion) {
                    NSString *requestID = @"";
                    NSString *mechanism = @"";
                    NSURLSessionAsyncCompletion completionWrapper = ^(id fileURLOrData, NSURLResponse *response, NSError *error) {
                        NSLog(@"record -- send data url request");

                    };
                    
                    task = ((id(*)(id, SEL, id, id))objc_msgSend)(slf, swizzledSelector, argument, completionWrapper);
                } else {
                     task = ((id(*)(id, SEL, id, id))objc_msgSend)(slf, swizzledSelector, argument,completion);
                }
                return task;
            };
            [TBPerRuntimeUtils replaceImplementationOfKnownSelector:selector onClass:class withBlock:asyncDataOrDownloadSwizzleBlock swizzledSelector:swizzledSelector];
        }
    });
}


+ (void)injectTaskDidReceiveDataIntoDelegateClass:(Class)cls {
    //data
    
    SEL selector = @selector(URLSession:dataTask:didReceiveData:);
    SEL swizzledSelector = [TBPerRuntimeUtils swizzledSelectorForSelector:selector];
    Protocol *protocol = @protocol(NSURLSessionDataDelegate);
    struct objc_method_description methodDescription = protocol_getMethodDescription(protocol, selector, NO, YES);
    typedef void (^NSURLSessionDidReceiveDataBlock)(id <NSURLSessionDataDelegate> slf, NSURLSession *session , NSURLSessionTask *dataTask, NSData *data);
    
    NSURLSessionDidReceiveDataBlock undefineBlock = ^(id <NSURLSessionDataDelegate> slf , NSURLSession *session, NSURLSessionTask *dataTask, NSData *data) {
        [[TBNetWorkObserver sharedObserver].tb_data appendData:data];
        NSLog(@"record define data url is %@",dataTask.originalRequest);
    };
    // deleglate mutable net
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
    
}

+ (void)injectTaskDidCompleteWithErrorIntoDelegateClass:(Class)cls {
    //data finish
    SEL selector = @selector(URLSession:task:didCompleteWithError:);
    SEL swizzledSelector = [TBPerRuntimeUtils swizzledSelectorForSelector:selector];
    
    Protocol *protocol = @protocol(NSURLSessionTaskDelegate);
    struct objc_method_description methodDescription = protocol_getMethodDescription(protocol, selector, NO, YES);
    
    typedef void (^NSURLSessionTaskDidCompleteWithErrorBlock)(id <NSURLSessionTaskDelegate> slf, NSURLSession *session, NSURLSessionTask *task, NSError *error);\
    NSURLSessionTaskDidCompleteWithErrorBlock undefineBlock = ^(id <NSURLSessionTaskDelegate> slf, NSURLSession *session, NSURLSessionTask *task, NSError *error) {
        [TBNetWorkObserver sharedObserver].tb_response = task.response;
           [[TBNetMonitorManager sharedInstance] handleRequest:[TBNetWorkObserver sharedObserver].tb_request response:[TBNetWorkObserver sharedObserver].tb_response andData:[TBNetWorkObserver sharedObserver].tb_data];
        NSLog(@"recode is Did Complete task %@",task.response);
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
    
}

+ (void)injectDataTaskDidBecomeDownloadTaskIntoDelegateClass:(Class)cls {
    
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
            [[TBNetWorkObserver sharedObserver] URLSessionTaskWillResume:slf];
            ((void(*)(id , SEL))objc_msgSend)(slf, swizzledSelector);
        };
        IMP implementation = imp_implementationWithBlock(swizzleBlock);
        class_addMethod(class, swizzledSelector, implementation, method_getTypeEncoding(originalResume));
        Method newResume = class_getInstanceMethod(class, swizzledSelector);
        method_exchangeImplementations(originalResume, newResume);
    });
}






#pragma mark - Private Methods

- (void)performBlock:(dispatch_block_t)block
{
    if ([[self class] isEnabled]) {
        dispatch_async(_queue, block);
    }
}

+ (BOOL)isEnabled {
    return [[NSUserDefaults standardUserDefaults] objectForKey:kTBNetworkObserverEnabledDefaultsKey];
}



@end
 



@implementation TBNetWorkObserver (NSURLConnectionHelpers)

- (void)connectionWillCancel:(NSURLConnection *)connection {
    
}

@end


@implementation TBNetWorkObserver (NSURLSessionTaskHelpers)

- (void)URLSessionTaskWillResume:(NSURLSessionTask *)task {
    
}

@end

