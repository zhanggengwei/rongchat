//
//  PPTUserInfoEngine.h
//  rongChatDemo1
//
//  Created by vd on 2016/11/14.
//  Copyright © 2016年 vd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PPTUserInfoEngine : NSObject

@property (nonatomic,copy,readonly) NSString * userId;
@property (nonatomic,copy,readonly) NSString * token;
//自己的信息数据
@property (nonatomic,strong,readonly) RCUserInfoData * user_Info;
//联系人数据
@property (nonatomic,strong,readonly) NSArray * contactList;
//群组数据
@property (nonatomic,strong,readonly) NSArray<RCContactGroup *> *contactGroupList;
@property (nonatomic,strong,readonly) NSArray<RCUserInfoData *> * contactBlackList;

- (instancetype)init __attribute__((unavailable("user shareEngine init")));

+ (instancetype)shareEngine;

- (RCUserInfoData *)quertyUserInfoByUserId:(NSString *)userId;

- (void)loginSucessed:(PPUserInfoTokenResponse *)response;//登录成功后调用这个方法 进行个人数据信息的保存 请求

- (void)logoutSucessed;//退出登陆成功后进行数据的清理

- (BOOL)addContactNotificationMessages:(NSArray<RCIMInviteMessage *>*)messages;



@end
