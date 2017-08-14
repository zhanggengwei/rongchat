//
//  RCIMBuglyConfig.m
//  rongchat
//
//  Created by VD on 2017/8/14.
//  Copyright © 2017年 vd. All rights reserved.
//

#import "RCIMBuglyConfig.h"

@implementation RCIMBuglyConfig
+ (instancetype)shareInstanceStartBugly
{
    static RCIMBuglyConfig * manager;
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        manager = [RCIMBuglyConfig new];
    });
    return manager;
}

- (instancetype)init
{
    if(self = [super init])
    {
        
    }
    return self;
}


@end
