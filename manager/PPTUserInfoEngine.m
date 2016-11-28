//
//  PPTUserInfoEngine.m
//  rongChatDemo1
//
//  Created by vd on 2016/11/14.
//  Copyright © 2016年 vd. All rights reserved.
//

#import "PPTUserInfoEngine.h"

@interface PPTUserInfoEngine ()
@property (nonatomic,strong) PPUserBaseInfo * user_Info;

@end

@implementation PPTUserInfoEngine
+ (instancetype)shareEngine
{
    static dispatch_once_t token;
    static PPTUserInfoEngine * instance;
    dispatch_once(&token, ^{
        instance = [[self alloc]init];
        [instance loadData];
        
        
    });
    return instance;
}

- (void)loadData
{
    
    self.user_Info = [[PPTDBEngine shareManager]queryUser_Info];
}


@end
