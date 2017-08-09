//
//  RCMessage+RCTimeShow.h
//  rongchat
//
//  Created by VD on 2017/8/7.
//  Copyright © 2017年 vd. All rights reserved.
//

#import <RongIMLib/RongIMLib.h>

@interface RCMessage (RCTimeShow)
- (void)RCIM_shouldDisplayTimestampForMessages:(NSArray *)messages callback:(RCIMShouldDisplayTimestampCallBack)callback;
- (NSTimeInterval)RCIM_messageTimestamp;
+ (instancetype)systemMessageWithTimestamp:(NSTimeInterval)time;
@end

