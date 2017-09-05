//
//  PPTDBEngine.h
//  rongChatDemo1
//
//  Created by vd on 2016/11/6.
//  Copyright © 2016年 vd. All rights reserved.
//

#import <Foundation/Foundation.h>
@class RCContactGroupData;
@class RCUserInfoData;
@class RCIMInviteMessage;

@interface PPTDBEngine : NSObject

+ (instancetype)shareManager;
//保存用户的个人信息
- (BOOL)saveUserInfo:(RCUserInfoData *)baseInfo;
//保存用户的好友列表
- (BOOL)saveContactList:(NSArray<RCUserInfoData *> *)contactList;
- (BOOL)addOrUpdateContactGroupLists:(NSArray<RCContactGroupData *>*)contactGroupLists;
- (BOOL)addContactNotificationMessages:(NSArray<RCIMInviteMessage *>*)messages;
//查询好友信息
- (RCUserInfoData *)queryUser_InfoWithIndexId:(NSString *)indexId;
//查询个人信息
- (RCUserInfoData *)queryUser_Info;
//保存个人信息
- (BOOL)updateUserInfo:(RCUserInfoData *)info;
//查询好友列表
- (NSArray *)queryFriendList;

//查询群聊列表
- (NSArray *)contactGroupLists;
//加载userid 数据库
- (void)loadDataBase:(NSString *)userID;
//数据库清理工作
- (void)clearAccount;
//查询未读的好友请求
- (NSInteger)queryUnreadFriendCount;

- (BOOL)deleteContactGroup:(PPTContactGroupModel *)model;



@end
