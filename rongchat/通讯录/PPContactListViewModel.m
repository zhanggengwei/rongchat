//
//  PPContactListViewModel.m
//  rongchat
//
//  Created by VD on 2017/8/24.
//  Copyright © 2017年 vd. All rights reserved.
//

#import "PPContactListViewModel.h"

@interface PPContactListViewModel ()


@end

@implementation PPContactListViewModel
- (instancetype)init
{
    if(self = [super init])
    {
        [self loadFriendList];
        
    }
    return self;
}

- (void)loadFriendList
{
    RAC(self,contactList) = RACObserve([PPTUserInfoEngine shareEngine], contactList);
    
    
}
@end
