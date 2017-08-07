//
//  RCMessage+RCTimeShow.m
//  rongchat
//
//  Created by VD on 2017/8/7.
//  Copyright © 2017年 vd. All rights reserved.
//

#import "RCMessage+RCTimeShow.h"

@implementation RCMessage (RCTimeShow)


- (NSTimeInterval)lcck_messageTimestamp {
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
- (void)lcck_shouldDisplayTimestampForMessages:(NSArray *)messages callback:(RCIMShouldDisplayTimestampCallBack)callback {

    BOOL containsMessage= [messages containsObject:self];
    if (!containsMessage) {
        return;
    }
    NSTimeInterval selfMessageTimestamp = [self lcck_messageTimestamp];
    
    NSUInteger index = [messages indexOfObject:self];
    if (index == 0) {
        !callback ?: callback(YES, selfMessageTimestamp);
        return;
    }
    id lastMessage = [messages objectAtIndex:index - 1];
    
    NSTimeInterval lastMessageTimestamp = [lastMessage lcck_messageTimestamp];
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

@end
