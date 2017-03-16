//
//  RCContactUserInfo.h
//  rongchat
//
//  Created by vd on 2016/12/8.
//  Copyright © 2016年 vd. All rights reserved.
//

#import <RongIMLib/RongIMLib.h>

@interface RCContactUserInfo : NSObject

@property (nonatomic,strong,readonly) NSString * nickNameChar;
@property (nonatomic,strong,readonly) RCUserInfo * info;
@property (nonatomic,strong,readonly) NSString * name;

- (instancetype)transFromPPUserBaseInfoToRCContactUserInfo:(PPUserBaseInfo *)baseInfo;


@end
