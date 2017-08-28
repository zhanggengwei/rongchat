//
//  RCConversationCacheObj.h
//  rongchat
//
//  Created by Donald on 16/12/15.
//  Copyright © 2016年 vd. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface RCConversationCacheObj : NSObject



+ (instancetype)shareManager;


- (RCUserInfo *)searchUserInfoByUserId:(NSString *)indexId;

- (void)refreshUserInfo:(RCUserInfoData *)userInfo byUserId:(NSString *)indexId;

- (void)saveUserInfoList:(NSArray <RCUserInfoData *> *)userList;



@end
