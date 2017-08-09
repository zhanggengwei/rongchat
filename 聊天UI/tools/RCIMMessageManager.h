//
//  RCIMMessageManager.h
//  rongchat
//
//  Created by VD on 2017/8/4.
//  Copyright © 2017年 vd. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol RCIMMessageManagerDelegate <NSObject>

@optional
- (void)onReceived:(RCMessage *)message left:(int)nLeft object:(id)object;
//消息撤回
- (void)onMessageRecalled:(long)messageId;

/*!
 请求消息已读回执（收到需要阅读时发送回执的请求，收到此请求后在会话页面已经展示该 messageUId 对应的消息或者调用 getHistoryMessages 获取消息的时候，包含此 messageUId 的消息，需要调用
 sendMessageReadReceiptResponse 接口发送消息阅读回执）
 
 @param messageUId       请求已读回执的消息ID
 @param conversationType conversationType
 @param targetId         targetId
 */
- (void)onMessageReceiptRequest:(RCConversationType)conversationType targetId:(NSString *)targetId messageUId:(NSString *)messageUId;

/*!
 消息已读回执响应（收到阅读回执响应，可以按照 messageUId 更新消息的阅读数）
 @param messageUId       请求已读回执的消息ID
 @param conversationType conversationType
 @param targetId         targetId
 @param userIdList 已读userId列表
 */
- (void)onMessageReceiptResponse:(RCConversationType)conversationType targetId:(NSString *)targetId messageUId:(NSString *)messageUId readerList:(NSMutableDictionary *)userIdList;

@end

@protocol RCIMMessageManagerConnectionStatusChangeDelegate <NSObject>
@optional
- (void)onConnectionStatusChanged:(RCConnectionStatus)status;

@end



@interface RCIMMessageManager : NSObject

+ (instancetype)shareManager;

@property (nonatomic,weak)id<RCIMMessageManagerDelegate>delegate;
@property (nonatomic,weak)id<RCIMMessageManagerConnectionStatusChangeDelegate>conectDelegate;

- (void)queryLastedMessageWithConversationType:(RCConversationType) converstionType withConversationId:(NSString *)conversationId withCount:(NSInteger)count withHandle:(RCQueryMessagesBlock)block;

- (void)queryHistoryMessageWithConversationType:(RCConversationType) converstionType withConversationId:(NSString *)conversationId withCount:(NSInteger)count oldesetMessageId:(NSUInteger) messageId withHandle:(RCQueryMessagesBlock)block;
#pragma mark 查询会话记录
- (void)queryLastConversationListWithConversationTypeArray:(NSArray *)conversationTypeArr WithHandle:(RCQueryConversationListBlock)block;
#pragma mark 获取未读消息的数目
- (void)getTotalUnreadCountWithHandle:(RCIntegerResultBlock)block;
#pragma mark 会话中的所有消息设置成已读
- (void)setMessageReadStatusWithConversationId:(NSString *)conversationId withConversationType:(RCConversationType)type withHandle:(RCBooleanResultBlock)block;
- (void)deleteMessage:(NSArray<NSNumber *> *)messageIds;

- (void)sendCustomMessages:(RCMessageContent*)messageContent withConversationId:(NSString *)conversationId conversationType:(RCConversationType)type failed:(RCErrorSendMessageBlock)failBlock sucessBlock:(RCSucessedSendMessageBlock)sucessBlock;

- (void)sendMediaMessages:(RCMessageContent*)messageContent withConversationId:(NSString *)conversationId conversationType:(RCConversationType)type withProgress:(RCProgressBlock)progressBlock failed:(RCErrorSendMessageBlock)failBlock sucessBlock:(RCSucessedSendMessageBlock)sucessBlock cancelBlock:(RCCancelSendMessageBlock)cancelBlock;



@end
