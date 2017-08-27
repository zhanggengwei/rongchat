//
//  kPPObserverDef.h
//  rongChatDemo1
//
//  Created by vd on 2016/11/6.
//  Copyright © 2016年 vd. All rights reserved.
//

#import <Foundation/Foundation.h>
#define kPPResponseSucessCode 200

#define kPPLoginToken @"kPPLoginToken"
#define kPPUserInfoUserID @"kPPUserInfoUserID"
#define kPPServiceName  @"kPPServiceName"
//登录成功的通知名称
static NSString * RCIMLoginSucessedNotifaction = @"RCIMLoginSucessedNotifaction";
//退出登录的通知
static NSString * RCIMLogoutSucessedNotifaction = @"RCIMLogoutSucessedNotifaction";

@interface kPPObserverDef : NSObject

@end
