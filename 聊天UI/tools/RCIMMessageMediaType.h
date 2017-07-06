//
//  RCIMMessageMediaType.h
//  rongchat
//
//  Created by VD on 2017/7/7.
//  Copyright © 2017年 vd. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef int8_t RCIMMessageMediaType;

//SDK定义的消息类型，自定义类型使用大于0的值
enum : RCIMMessageMediaType {
    kRCIMMessageMediaTypeNone = 0,
    kRCIMMessageMediaTypeText = -1,
    kRCIMMessageMediaTypeImage = -2,
    kRCIMMessageMediaTypeAudio = -3,
    kRCIMMessageMediaTypeVideo = -4,
    kRCIMMessageMediaTypeLocation = -5,
    kRCIMMessageMediaTypeFile = -6
};

