//
//  RCConversationCacheObj.h
//  rongchat
//
//  Created by Donald on 16/12/15.
//  Copyright © 2016年 vd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RCConversationCacheObj : NSObject


- (RCUserInfo *)searchUserInfoByUserId:(NSString *)indexId;

- (RCUserInfo *)refreshUserInfo:(RCUserInfo *)userInfo byUserId:(NSString *)indexId;

- (void)saveUserInfoList:(NSArray <RCUserInfo *> *)userList;



@end
