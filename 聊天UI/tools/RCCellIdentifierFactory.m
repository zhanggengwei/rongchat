//
//  RCCellIdentifierFactory.m
//  rongchat
//
//  Created by VD on 2017/7/8.
//  Copyright © 2017年 vd. All rights reserved.
//

#import "RCCellIdentifierFactory.h"

@implementation RCCellIdentifierFactory


+ (NSString *)cellIdentifierForMessageConfiguration:(id)message conversationType:(RCConversationType)conversationType {
    NSString *groupKey;
    switch (conversationType) {
        case ConversationType_GROUP:
            groupKey = RCCellIdentifierGroup;
            break;
        case ConversationType_PRIVATE:
            groupKey = RCCellIdentifierSingle;
            break;
        case ConversationType_DISCUSSION:
            groupKey = RCCellIdentifierDISCUSSION;
            break;
        case ConversationType_CHATROOM:
            groupKey = RCCellIdentifierCHATROOM;
            break;
        case ConversationType_CUSTOMERSERVICE:
            groupKey = RCCellIdentifierCUSTOMERSERVICEM;
            break;
        case ConversationType_SYSTEM:
            groupKey = RCCellIdentifierSystem;
            break;
        case ConversationType_APPSERVICE:
            groupKey = RCCellIdentifierAPPSERVICE;
            break;
        case ConversationType_PUBLICSERVICE:
            groupKey = RCCellIdentifierPUBLICSERVICE;
            break;
        case ConversationType_PUSHSERVICE:
            groupKey = RCCellIdentifierPUSHSERVICE;
            break;
        default:
            groupKey = RCCellIdentifierSingle;
            break;
    }
    return [self cellIdentifierForDefaultMessageConfiguration:message groupKey:groupKey];
}

+ (NSString *)cellIdentifierForDefaultMessageConfiguration:(RCMessage *)message groupKey:(NSString *)groupKey {
    RCMessageDirection messageOwner = message.messageDirection;
    NSString *key = message.objectName;
    Class aClass = [RCChatMessageCellMediaTypeDict objectForKey:key];
    if(aClass==nil)
    {
        aClass = RCChatSystemMessageCell.class;
    }
    NSString *typeKey = NSStringFromClass(aClass);
    NSString *ownerKey;
    switch (messageOwner) {
        case RCMessageSystemMesage:
            ownerKey = RCCellIdentifierOwnerSystem;
            break;
        case MessageDirection_RECEIVE:
            ownerKey = RCCellIdentifierOwnerOther;
            break;
        case MessageDirection_SEND:
            ownerKey = RCCellIdentifierOwnerSelf;
            break;
        default:
            NSAssert(NO, @"Message Owner Unknow");
            break;
    }
    NSAssert(typeKey.length > 0, @"🔴类名与方法名：%@（在第%@行），描述：%@,%@", @(__PRETTY_FUNCTION__), @(__LINE__),message.objectName, NSStringFromClass([message class]));
    NSString *cellIdentifier = [NSString stringWithFormat:@"%@_%@_%@", typeKey, ownerKey, groupKey];
    return cellIdentifier;
}



+ (NSString *)cacheKeyForMessage:(RCMessage *)message {
    
  
        return [NSString stringWithFormat:@"%@%ld",message.objectName,message.messageId];
    
}

@end
