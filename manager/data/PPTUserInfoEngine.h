//
//  PPTUserInfoEngine.h
//  rongChatDemo1
//
//  Created by vd on 2016/11/14.
//  Copyright © 2016年 vd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PPTUserInfoEngine : NSObject
@property (nonatomic,strong,readonly) PPUserBaseInfo * user_Info;
@property (nonatomic,strong,readonly) NSArray * contactList;

+ (instancetype)shareEngine;

- (BOOL)saveUserInfo:(PPUserBaseInfo *)baseInfo;

- (void)asynFriendList;

- (RCUserInfo *)quertyUserInfoByUserId:(NSString *)userId;


@end
