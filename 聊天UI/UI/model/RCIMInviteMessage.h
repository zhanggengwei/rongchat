//
//  RCIMInviteMessage.h
//  rongchat
//
//  Created by VD on 2017/8/28.
//  Copyright © 2017年 vd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RCIMInviteMessage : NSObject

@property (nonatomic, strong) NSString * sourceUserId;
@property (nonatomic, strong) NSString * targetUserId;
@property (nonatomic, strong) NSString * message;
@property (nonatomic, assign) RCIMContactStatus status;
@property (nonatomic, assign) BOOL read;//是否读取
@property (nonatomic, strong) NSDate * date;
@end
