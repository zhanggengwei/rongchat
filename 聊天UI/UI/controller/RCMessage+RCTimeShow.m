//
//  RCMessage+RCTimeShow.m
//  rongchat
//
//  Created by VD on 2017/8/7.
//  Copyright © 2017年 vd. All rights reserved.
//

#import "RCMessage+RCTimeShow.h"

@implementation RCMessage (RCTimeShow)


- (NSTimeInterval)RCIM_messageTimestamp {
    NSTimeInterval selfMessageTimestamp;
    
        NSTimeInterval sendTime = self.sentTime;
        //如果当前消息是正在发送的消息，则没有时间戳
        if (sendTime == 0) {
            sendTime = RC_CURRENT_TIMESTAMP;
        }
        selfMessageTimestamp = sendTime;
    return selfMessageTimestamp;
}

// 是否显示时间轴Label
- (void)RCIM_shouldDisplayTimestampForMessages:(NSArray *)messages callback:(RCIMShouldDisplayTimestampCallBack)callback {

    BOOL containsMessage= [messages containsObject:self];
    if (!containsMessage) {
        return;
    }
    NSTimeInterval selfMessageTimestamp = [self RCIM_messageTimestamp];
    
    NSUInteger index = [messages indexOfObject:self];
    if (index == 0) {
        !callback ?: callback(YES, selfMessageTimestamp);
        return;
    }
    id lastMessage = [messages objectAtIndex:index - 1];
    
    NSTimeInterval lastMessageTimestamp = [lastMessage RCIM_messageTimestamp];
    NSTimeInterval interval = (selfMessageTimestamp - lastMessageTimestamp) / 1000;
    
    int limitInterval = 60 * 3;
    if (interval > limitInterval) {
        !callback ?: callback(YES, selfMessageTimestamp);
        return;
    }
    !callback ?: callback(NO, selfMessageTimestamp);
}
+ (instancetype)systemMessageWithTimestamp:(NSTimeInterval)time {

    RCMessage *timeMessage = [[RCMessage alloc] init];
    timeMessage.objectName = RCTimeMessageTypeIdentifier;
    timeMessage.sentTime = time;
    return timeMessage;
}
//默认
- (NSString *)fileSizeString:(long long)size
{
    long long byte = size;
    if(byte<1024)
    {
        return [@(byte).stringValue stringByAppendingString:@"B"];
    }
    long long kb = byte/1024.0;
    if(kb<1024)
    {
        return [@(kb).stringValue stringByAppendingString:@"KB"];
    }
    long long MB = kb/1024.0;
    if(MB<1024)
    {
        return [@(MB).stringValue stringByAppendingString:@"MB"];
    }
    return [@(MB/1024.0).stringValue stringByAppendingString:@"G"];
}
+ (BOOL)canReadOpenApp:(RCFileMessage *)messageContent
{
    NSString * type = messageContent.type;
    if([type hasPrefix:@"doc"])
    {
         return YES;
    }else if ([type hasPrefix:@"txt"])
    {
         return YES;
    }else if ([type hasPrefix:@"xls"])
    {
        return YES;
        
    }else if ([type hasPrefix:@"ppt"])
    {
        return YES;
    }
    else if ([type hasPrefix:@"html"])
    {
        return YES;
    }
    return NO;
}
@end
