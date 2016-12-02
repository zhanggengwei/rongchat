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

- (PPUserBaseInfo *)queryUser_InfoWithIndexId:(NSString *)indexId;

- (PPUserBaseInfo *)queryUser_Info;

- (NSArray *)queryFriendList;

- (void)loadDataBase:(NSString *)userID;




@end
