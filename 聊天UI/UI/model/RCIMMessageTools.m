//
//  RCIMMessageTools.m
//  rongchat
//
//  Created by VD on 2017/9/5.
//  Copyright © 2017年 vd. All rights reserved.
//

#import "RCIMMessageTools.h"

@implementation RCIMMessageTools
+ (NSString *)transFromMessageToSystemTip:(RCGroupNotificationMessage *)message
{
    NSString * data = message.data;
    NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:[data dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
    NSString * operatorNickname = dict[@"operatorNickname"];
    NSMutableString * resultString = [NSMutableString new];
    if([message.operation isEqualToString:GroupNotificationMessage_GroupOperationCreate])
    {
        if([message.operatorUserId isEqualToString:[PPTUserInfoEngine shareEngine].userId])
        {
            [resultString appendString:@"你创建了一个群组"];
        }else
        {
           
           [resultString appendFormat:@"%@邀请你加入了群聊",operatorNickname];
        }
    }else if ([message.operation isEqualToString:GroupNotificationMessage_GroupOperationAdd])
    {
        NSString * targetUserDisplayNames = [dict[@"targetUserDisplayNames"] componentsJoinedByString:@","];
            [resultString appendFormat:@"%@加入了群聊",targetUserDisplayNames];
    }
    return resultString;
}
@end
