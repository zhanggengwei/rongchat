//
//  RCConversationCacheObj.m
//  rongchat
//
//  Created by Donald on 16/12/15.
//  Copyright © 2016年 vd. All rights reserved.
//

#import "RCConversationCacheObj.h"
#import <FMDB/FMDB.h>
#import "PPTDBEngine.h"


@interface RCConversationCacheObj ()
@property (nonatomic,strong) NSCache * cache;
@end


@implementation RCConversationCacheObj


+(instancetype)shareManager
{
    static RCConversationCacheObj * manager;
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        manager = [RCConversationCacheObj new];
       
        
    });
    return manager;
}

-(instancetype)init
{
    if(self = [super init])
    {
        self.cache = [NSCache new];
    }
    return self;
}


- (RCUserInfoData *)searchUserInfoByUserId:(NSString *)indexId
{
   // [self.cache removeObjectForKey:indexId];
    RCUserInfoData * info = [self.cache objectForKey:indexId];
    if(!info)
    {
        info = [[PPTDBEngine shareManager]queryUser_InfoWithIndexId:indexId];
        if(info)
        {
           [self.cache setObject:info forKey:indexId];
        }else
        {
            return nil;
        }
        
        
    }
    return info;
    
}

- (void)refreshUserInfo:(RCUserInfoData *)userInfo byUserId:(NSString *)indexId
{
    //判断是否存在
    BOOL exists = [[PPTDBEngine shareManager]queryUser_InfoWithIndexId:indexId];
    if(exists)
    {
        [[PPTDBEngine shareManager]updateUserInfo:userInfo];
    }else
    {
        [[PPTDBEngine shareManager]saveUserInfo:userInfo];
    }
    
    [self.cache setObject:userInfo forKey:indexId];
    
}
- (void)saveUserInfoList:(NSArray <RCUserInfoData *> *)userList
{
    [userList enumerateObjectsUsingBlock:^(RCUserInfoData * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.cache setObject:obj forKey:obj.user.userId];
    }];
    [[PPTDBEngine shareManager]saveContactList:userList];
}

@end
