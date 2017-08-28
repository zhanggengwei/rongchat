//
//  RCIMInviteMessage.h
//  rongchat
//
//  Created by VD on 2017/8/28.
//  Copyright © 2017年 vd. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger,RCIMInviteMessageStatus) {
    RCIMInviteMessageStatusCustom,
    RCIMInviteMessageStatusRejected,
    RCIMInviteMessageStatusAgree
};

@interface RCIMInviteMessage : NSObject

@property (nonatomic, strong) NSString * sourceUserId;
@property (nonatomic, strong) NSString * targetUserId;
@property (nonatomic, strong) NSString * message;
@property (nonatomic, assign) RCIMInviteMessageStatus status;
@property (nonatomic, assign) BOOL read;//是否读取
@end
