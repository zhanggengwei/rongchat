//
//  PPTDBEngine.h
//  rongChatDemo1
//
//  Created by vd on 2016/11/6.
//  Copyright © 2016年 vd. All rights reserved.
//

#import <Foundation/Foundation.h>
@class PPUserBaseInfo;

@interface PPTDBEngine : NSObject

+ (instancetype)shareManager;
//保存用户的个人信息
- (BOOL)saveUserInfo:(PPUserBaseInfo *)baseInfo;
//保存用户的好友列表
- (BOOL)saveContactList:(NSArray <PPUserBaseInfo *> *)contactList;
//查询好友信息
- (PPUserBaseInfo *)queryUser_InfoWithIndexId:(NSString *)indexId;
//查询个人信息
- (PPUserBaseInfo *)queryUser_Info;
//保存个人信息
- (BOOL)updateUserInfo:(PPUserBaseInfo *)info;
//查询好友列表
- (NSArray *)queryFriendList;
//查询群聊列表
- (NSArray *)contactGroupLists;
//加载userid 数据库
- (void)loadDataBase:(NSString *)userID;
- (void)createContactGroupMemberTable;



@end
