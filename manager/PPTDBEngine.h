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
- (BOOL)saveUserInfo:(PPUserBaseInfo *)baseInfo;
- (PPUserBaseInfo *)queryUser_Info;
- (void)loadDataBase:(NSString *)userID;



@end
