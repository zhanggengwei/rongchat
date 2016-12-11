//
//  RCContactUserInfo.m
//  rongchat
//
//  Created by vd on 2016/12/8.
//  Copyright © 2016年 vd. All rights reserved.
//

#import "RCContactUserInfo.h"
#import "NSString+isValid.h"
@implementation RCContactUserInfo

- (instancetype)transFromPPUserBaseInfoToRCContactUserInfo:(PPUserBaseInfo *)baseInfo
{
    RCContactUserInfo * info = [[RCContactUserInfo alloc]initWithUserId:baseInfo.user.indexId name:([baseInfo.displayName isValid]?baseInfo.displayName:baseInfo.user.nickname) portrait:baseInfo.user.portraitUri];
    return info;
}

@end
