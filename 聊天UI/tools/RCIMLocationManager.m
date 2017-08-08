//
//  RCIMLocationManager.m
//  rongchat
//
//  Created by VD on 2017/8/8.
//  Copyright © 2017年 vd. All rights reserved.
//

#import "RCIMLocationManager.h"

@implementation RCIMLocationManager
+ (instancetype)shareManager
{
    static RCIMLocationManager * manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self.class alloc]init];
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
