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
        default:
            groupKey = @"";
            break;
    }
    
    if ([message lcck_isCustomMessage]) {
        return [self cellIdentifierForCustomMessageConfiguration:(AVIMTypedMessage *)message groupKey:groupKey];
    }
    return [self cellIdentifierForDefaultMessageConfiguration:(LCCKMessage *)message groupKey:groupKey];
}

+ (NSString *)cellIdentifierForDefaultMessageConfiguration:(RCMessage *)message groupKey:(NSString *)groupKey {
    RCMessageOwnerType messageOwner = message.ownerType;
    RCIMMessageMediaType messageType = message.mediaType;
    if ([message lcck_isCustomLCCKMessage]) {
        messageType = kAVIMMessageMediaTypeText;
    }
    NSNumber *key = [NSNumber numberWithInteger:messageType];
    Class aClass = [LCCKChatMessageCellMediaTypeDict objectForKey:key];
    NSString *typeKey = NSStringFromClass(aClass);
    NSString *ownerKey;
    switch (messageOwner) {
        case LCCKMessageOwnerTypeSystem:
            ownerKey = LCCKCellIdentifierOwnerSystem;
            break;
        case LCCKMessageOwnerTypeOther:
            ownerKey = LCCKCellIdentifierOwnerOther;
            break;
        case LCCKMessageOwnerTypeSelf:
            ownerKey = LCCKCellIdentifierOwnerSelf;
            break;
        default:
            NSAssert(NO, @"Message Owner Unknow");
            break;
    }
    NSAssert(typeKey.length > 0, @"🔴类名与方法名：%@（在第%@行），描述：%@,%@", @(__PRETTY_FUNCTION__), @(__LINE__), @(message.mediaType), NSStringFromClass([message class]));
    NSString *cellIdentifier = [NSString stringWithFormat:@"%@_%@_%@", typeKey, ownerKey, groupKey];
    return cellIdentifier;
}

+ (NSString *)cellIdentifierForCustomMessageConfiguration:(RCIMMessageMediaType *)message groupKey:(NSString *)groupKey {
    AVIMMessageIOType messageOwner = message.ioType;
    AVIMMessageMediaType messageType = message.mediaType;
    if (![message lcck_isSupportThisCustomMessage]) {
        messageType = kAVIMMessageMediaTypeText;
    }
    NSNumber *key = [NSNumber numberWithInteger:messageType];
    NSString *typeKey = NSStringFromClass([LCCKChatMessageCellMediaTypeDict objectForKey:key]);
    NSAssert(typeKey.length > 0, @"🔴类名与方法名：%@（在第%@行），描述：%@,%@", @(__PRETTY_FUNCTION__), @(__LINE__), @(message.mediaType), NSStringFromClass([message class]));
    NSString *ownerKey;
    switch (messageOwner) {
        case AVIMMessageIOTypeOut:
            ownerKey = LCCKCellIdentifierOwnerSelf;
            break;
        case AVIMMessageIOTypeIn:
            ownerKey = LCCKCellIdentifierOwnerOther;
            break;
        default:
            NSAssert(NO, @"Message Owner Unknow");
            break;
    }
    
    NSString *cellIdentifier = [NSString stringWithFormat:@"%@_%@_%@", typeKey, ownerKey, groupKey];
    return cellIdentifier;
}

+ (NSString *)cacheKeyForMessage:(id)message {
    if (![message lcck_isCustomMessage]) {
        LCCKMessage *message_ = (LCCKMessage *)message;
        return message_.messageId ?: message_.systemText;
    }
    AVIMTypedMessage *message_ = (AVIMTypedMessage *)message;
    return message_.messageId;
}

@end
