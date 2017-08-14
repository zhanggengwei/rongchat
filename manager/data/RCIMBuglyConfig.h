//
//  RCIMBuglyConfig.h
//  rongchat
//
//  Created by VD on 2017/8/14.
//  Copyright © 2017年 vd. All rights reserved.
//
#import <Bugly/Bugly.h>

#define  RCIMLogError BLYLogError(fmt, ...)
#define  RCIMLogWarn BLYLogWarn(fmt, ...)
#define  RCIMLogInfo BLYLogInfo(fmt, ...)
#define  RCIMLogDebug BLYLogDebug(fmt, ...)
#define  RCIMLogVerbose BLYLogVerbose(fmt, ...)

#import <Foundation/Foundation.h>
// bugly 工具日志
@interface RCIMBuglyConfig : NSObject
+ (instancetype)shareInstanceStartBugly;
@end
