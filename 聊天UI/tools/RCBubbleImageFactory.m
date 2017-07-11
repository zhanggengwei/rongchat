//
//  RCBubbleImageFactory.m
//  rongchat
//
//  Created by VD on 2017/7/8.
//  Copyright © 2017年 vd. All rights reserved.
//
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

#import "RCBubbleImageFactory.h"
#import "UIImage+RCIMExtension.h"
@implementation RCBubbleImageFactory
+ (UIImage *)bubbleImageViewForType:(RCMessageOwnerType)owner
                        messageType:(NSString *)messageIdentifier
                      isHighlighted:(BOOL)isHighlighted
{
    BOOL isCustomMessage = NO;
    NSString *messageTypeString = @"message_";
    RCIMMessageMediaType messageMediaType = [self.class getMessageMediaType:messageIdentifier];
    
    switch (messageMediaType) {
        case kRCIMMessageMediaTypeImage:
        case kRCIMMessageMediaTypeLocation:
            messageTypeString = [messageTypeString stringByAppendingString:@"hollow_"];
            break;
        default:
            break;
    }
    UIEdgeInsets bubbleImageCapInsets = UIEdgeInsetsZero;
    switch (owner) {
        case RCMessageOwnerTypeSelf: {
            // 发送
            switch (messageMediaType) {
                case kRCIMMessageMediaTypeImage:
                case kRCIMMessageMediaTypeLocation:
                    bubbleImageCapInsets = [RCIMSettingService shareManager].rightHollowCapMessageBubbleCustomize;
                    break;
                default:
                    bubbleImageCapInsets = [RCIMSettingService shareManager].rightCapMessageBubbleCustomize;
                    break;
            }
            messageTypeString = [messageTypeString stringByAppendingString:@"sender_"];
            break;
        }
        case RCMessageOwnerTypeOther: {
            // 接收
            switch (messageMediaType) {
                case kRCIMMessageMediaTypeImage:
                case kRCIMMessageMediaTypeLocation:
                    bubbleImageCapInsets = [RCIMSettingService shareManager].leftHollowCapMessageBubbleCustomize;
                    break;
                default:
                    bubbleImageCapInsets = [RCIMSettingService shareManager].leftCapMessageBubbleCustomize;
                    break;
            }
            messageTypeString = [messageTypeString stringByAppendingString:@"receiver_"];
            break;
        }
        case RCMessageOwnerTypeSystem:
            break;
        case RCMessageOwnerTypeUnknown:
            isCustomMessage = YES;
            break;
    }
    if (isCustomMessage) {
        return nil;
    }
    messageTypeString = [messageTypeString stringByAppendingString:@"background_"];
    if (isHighlighted) {
        messageTypeString = [messageTypeString stringByAppendingString:@"highlight"];
    } else {
        messageTypeString = [messageTypeString stringByAppendingString:@"normal"];
    }
    UIImage *bublleImage = [UIImage lcck_imageNamed:messageTypeString bundleName:@"MessageBubble" bundleForClass:[self class]];
    return RC_STRETCH_IMAGE(bublleImage, bubbleImageCapInsets);
    
}
+ (RCIMMessageMediaType) getMessageMediaType:(NSString *)str
{
    if([str isEqualToString:RCTextMessageTypeIdentifier])
    {
        return kRCIMMessageMediaTypeText;
    }else if ([str isEqualToString:RCImageMessageTypeIdentifier])
    {
        return kRCIMMessageMediaTypeImage;
    }else if ([str isEqualToString:RCVoiceMessageTypeIdentifier])
    {
        return kRCIMMessageMediaTypeAudio;
    }else if ([str isEqualToString:RCVideoMessageTypeIdentifier])
    {
        return kRCIMMessageMediaTypeVideo;
    }else if ([str isEqualToString:RCLocationMessageTypeIdentifier])
    {
        return kRCIMMessageMediaTypeLocation;
    }else if ([str isEqualToString:RCFileMessageTypeIdentifier])
    {
        return kRCIMMessageMediaTypeFile;
    }
    return kRCIMMessageMediaTypeNone;
}
@end
