//
//  TBMemeryUse.m
//  TimeAndLoop
//
//  Created by BinTong on 2019/2/23.
//  Copyright © 2019 TongBin. All rights reserved.
//

#import "TBMemeryUse.h"
#import "mach/mach.h"

@interface TBMemeryUse()

@property (assign, nonatomic) NSTimeInterval lastTime;
@property (assign, nonatomic) CGFloat lastMemeryUse;

@end

@implementation TBMemeryUse

+ (TBMemeryUse *)sharedInstance {
    static TBMemeryUse *sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[TBMemeryUse alloc] init];
    });
    return sharedInstance;
}

- (CGFloat)usedMemoryInMB{
    
    int64_t memory = [TBMemeryUse memoryUsage];
    _lastMemeryUse = memory;
    return _lastMemeryUse / 1000.0 / 1000.0;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}


+ (int64_t)memoryUsage {
    int64_t memoryUsageInByte = 0;
    task_vm_info_data_t vmInfo;
    mach_msg_type_number_t count = TASK_VM_INFO_COUNT;
    kern_return_t kernelReturn = task_info(mach_task_self(), TASK_VM_INFO, (task_info_t) &vmInfo, &count);
    if(kernelReturn == KERN_SUCCESS) {
        memoryUsageInByte = (int64_t) vmInfo.phys_footprint;
        NSLog(@"Memory in use (in bytes): %lld", memoryUsageInByte);
        NSLog(@"Memory in use (in mb): %lld", memoryUsageInByte/1000/1000);
    } else {
        NSLog(@"Error with task_info(): %s", mach_error_string(kernelReturn));
    }
    return memoryUsageInByte;
}

@end
