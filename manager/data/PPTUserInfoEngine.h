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
//联系人数据
@property (nonatomic,strong,readonly) NSArray * contactList;
- (instancetype)init __attribute__((unavailable("user shareEngine init")));

+ (instancetype)shareEngine;
- (BOOL)saveUserInfo:(PPUserBaseInfo *)baseInfo;
- (void)saveUserInfoList:(NSArray<PPUserBaseInfo *> *) friendList;
- (PPUserBaseInfo *)quertyUserInfoByUserId:(NSString *)userId;
@end
