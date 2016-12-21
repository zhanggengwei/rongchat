//
//  NSObject+RCIMDeallocBlockExecutor.m
//  RCIMDeallocBlockExecutor
//
//  v0.8.5 Created by 微博@iOS程序犭袁 (http://weibo.com/luohanchenyilong/) on 15/12/27.
//  Copyright © 2015年 https://github.com/ChenYilong . All rights reserved.
//

#import "NSObject+RCIMDeallocBlockExecutor.h"
#import <objc/runtime.h>

const void * deallocExecutorBlockKey = &deallocExecutorBlockKey;

@implementation NSObject (RCIMDeallocBlockExecutor)

- (void)lcck_executeAtDealloc:(DeallocExecutorBlock)block {
    if (block) {
        RCIMDeallocExecutor *executor = [[RCIMDeallocExecutor alloc] initWithBlock:block];
        objc_setAssociatedObject(self,
                                 deallocExecutorBlockKey,
                                 executor,
                                 OBJC_ASSOCIATION_RETAIN);
    }
}

@end
