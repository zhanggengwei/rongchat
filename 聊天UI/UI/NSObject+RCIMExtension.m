//
//  NSObject+RCIMExtension.m
//  rongchat
//
//  Created by VD on 2017/7/8.
//  Copyright © 2017年 vd. All rights reserved.
//

#import "NSObject+RCIMExtension.h"
@implementation NSObject (RCIMExtension)


- (NSString *)RCIM_registerCell:(NSString *)reuseIdentifier
{
    if(!reuseIdentifier)
    {
        return nil;
    }
    return [[reuseIdentifier stringByReplacingOccurrencesOfString:@"MessageDirection_SEND" withString:@""]stringByReplacingOccurrencesOfString:@"MessageDirection_RECEIVE" withString:@""];
}

- (NSString *)RCIM_registerCellReuseIdentifier:(RCMessage *)message
{
    NSMutableString *reuseIdentifier = [NSMutableString new];
    if([message.objectName isEqualToString:RCTextMessageTypeIdentifier])
    {
        [reuseIdentifier appendString:@"RCChatTextMessageCell"];
    }
    else if([message.objectName isEqualToString:RCImageMessageTypeIdentifier])
    {
         [reuseIdentifier appendString:@"RCChatImageMessageCell"];
    }else if ([message.objectName isEqualToString:RCTimeMessageTypeIdentifier])
    {
        [reuseIdentifier appendString:@"RCChatSystemMessageCell"];
        
    }
    switch (message.messageDirection) {
        case MessageDirection_SEND:
            [reuseIdentifier appendString:@"MessageDirection_SEND"];
            break;
        case MessageDirection_RECEIVE:
             [reuseIdentifier appendString:@"MessageDirection_RECEIVE"];
            break;
        default:
            break;
    }
    
    return reuseIdentifier;
}

- (RCMessageDirection)getMessageOwerTypeWithReuseIdentifier:(NSString *)reuseIdentifier
{
    if([reuseIdentifier containsString:RCCellIdentifierOwnerOther])
    {
        return MessageDirection_RECEIVE;
    }else if ([reuseIdentifier containsString:RCCellIdentifierOwnerSelf])
    {
        return MessageDirection_SEND;
    }
    return RCMessageSystemMesage;
}
@end
