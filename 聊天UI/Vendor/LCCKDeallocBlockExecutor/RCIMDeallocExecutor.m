//
//  RCIMDeallocExecutor.m
//  RCIMDeallocExecutor
//
//  v0.8.5 Created by 微博@iOS程序犭袁 (http://weibo.com/luohanchenyilong/) on 15/12/27.
//  Copyright © 2015年 https://github.com/ChenYilong . All rights reserved.
//

#import "RCIMDeallocExecutor.h"

@interface RCIMDeallocExecutor()

@property (nonatomic, copy) DeallocExecutorBlock deallocExecutorBlock;

@end

@implementation RCIMDeallocExecutor

- (id)initWithBlock:(DeallocExecutorBlock)deallocExecutorBlock {
    self = [super init];
    if (self) {
        _deallocExecutorBlock = [deallocExecutorBlock copy];
    }
    return self;
}

- (void)dealloc {
    _deallocExecutorBlock ? _deallocExecutorBlock() : nil;
}

@end
