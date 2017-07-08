//
//  RCBubbleImageFactory.m
//  rongchat
//
//  Created by VD on 2017/7/8.
//  Copyright © 2017年 vd. All rights reserved.
//

#import "RCBubbleImageFactory.h"
#import "UIImage+RCIMExtension.h"

@implementation RCBubbleImageFactory
+ (UIImage *)bubbleImageViewForType:(RCMessageOwnerType)owner
                        messageType:(RCIMMessageMediaType)messageMediaType
                      isHighlighted:(BOOL)isHighlighted
{
    BOOL isCustomMessage = NO;
    NSString *messageTypeString = @"message_";
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
@end
