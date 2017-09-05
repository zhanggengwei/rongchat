//
//  RCIMMessageManager.m
//  rongchat
//
//  Created by VD on 2017/8/4.
//  Copyright © 2017年 vd. All rights reserved.
//

#import "RCIMMessageManager.h"
#import "RCIMInviteMessage.h"
#import "PPDataDef.h"
// 创建群聊的通知
#define GroupNotificationMessage_GroupOperationCreate @"Create"

@interface RCIMMessageManager ()<RCIMClientReceiveMessageDelegate,RCConnectionStatusChangeDelegate>
{
    RCIMClient * _client;
    
    //创建一个子线程用于查询历史消息
    dispatch_queue_t _queryMessageQueue;
    //创建一个查询会话数据
    dispatch_queue_t _queryConversationListQueue;
    
}
@property (nonatomic,strong) NSString * unReadMessageCount;
@end
@implementation RCIMMessageManager
+ (instancetype)shareManager
{
    static RCIMMessageManager * manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [RCIMMessageManager  new];
    });
    return manager;
}

- (instancetype)init
{
    if(self=[super init])
    {
        _client = [RCIMClient sharedRCIMClient];
        [_client setReceiveMessageDelegate:self object:nil];
        _queryMessageQueue = dispatch_queue_create("queryMessageQueue", DISPATCH_QUEUE_SERIAL);//创建一个串行的队列
        _queryConversationListQueue = dispatch_queue_create("queryConversationListQueue", DISPATCH_QUEUE_SERIAL);//创建一个串行的队列
    }
    return self;
}

- (void)onReceived:(RCMessage *)message left:(int)nLeft object:(id)object
{
    static BOOL refresh;
    if([self customMessage:message])
    {
        refresh = YES;
        if([message.objectName isEqualToString:RCGroupNotificationMessageIdentifier])
        {
            [self managerContactGroupMessage:message];
        }
        if([self.delegate respondsToSelector:@selector(onReceived:left:object:)])
        {
            [self.delegate onReceived:message left:nLeft object:object];
        }
    }
    else
    {
        [self managerAddContactRequest:message];
    }
    if(nLeft<=0)
    {
        if(refresh)
        {
            [[NSNotificationCenter defaultCenter]postNotificationName:RCDidReceiveMessagesDidChanged object:nil];
        }
        refresh = NO;
    }
}

- (void)managerContactGroupMessage:(RCMessage *)message
{
    [[[PPTUserInfoEngine  shareEngine]getContactGroupByGroupId:message.targetId]subscribeNext:^(PPTContactGroupModel * model) {
        RCGroupNotificationMessage * messageContent = (RCGroupNotificationMessage *)message.content;
        if([messageContent.operation isEqualToString:GroupNotificationMessage_GroupOperationCreate])
        {
           
        }else if ([messageContent.operation isEqualToString:GroupNotificationMessage_GroupOperationBulletin])
        {
            
        }else if ([messageContent.operation isEqualToString:GroupNotificationMessage_GroupOperationKicked])
        {
        }else if ([messageContent.operation isEqualToString:GroupNotificationMessage_GroupOperationQuit])
        {
        }else if ([messageContent.operation isEqualToString:GroupNotificationMessage_GroupOperationRename])
        {
        }else if ([messageContent.operation isEqualToString:GroupNotificationMessage_GroupOperationAdd])
        {
            
        }
        
    }];
}
//
- (BOOL)customMessage:(RCMessage*)message
{
    if([message.objectName isEqualToString:@"RCContactNotificationMessageIdentifier"])
    {
        return NO;
    }
    return YES;
}
//处理添加好友的网络请求
- (void)managerAddContactRequest:(RCMessage *)message
{
    dispatch_async(dispatch_get_main_queue(), ^{
        RCContactNotificationMessage * contactNotificationMessage = (RCContactNotificationMessage *)message.content;
        RCIMInviteMessage * inviteMessage = [RCIMInviteMessage new];
        inviteMessage.sourceUserId = contactNotificationMessage.sourceUserId;
        inviteMessage.targetUserId = contactNotificationMessage.targetUserId;
        inviteMessage.message = contactNotificationMessage.message;
        inviteMessage.date = [NSDate dateWithTimeIntervalSince1970:message.sentTime/1000];
        if([contactNotificationMessage.operation isEqualToString:ContactNotificationMessage_ContactOperationRequest])
        {
            inviteMessage.status = RCIMContactRequestFriend;
            //好友申请
            [[PPTUserInfoEngine shareEngine]addContactNotificationMessages:@[inviteMessage]];
            
        }else if ([contactNotificationMessage.operation isEqualToString:ContactNotificationMessage_ContactOperationAcceptResponse])
        {
            inviteMessage.status = RCIMContactCustom;
            [[PPTUserInfoEngine shareEngine]addContactNotificationMessages:@[inviteMessage]];
        }else
        {
            //拒绝
            
        }
    });

}

- (void)onMessageRecalled:(long)messageId
{
    if([self.delegate respondsToSelector:@selector(onMessageRecalled:)])
    {
        [self.delegate onMessageRecalled:messageId];
    }
}

- (void)onRCIMConnectionStatusChanged:(RCConnectionStatus)status
{
    if([self.conectDelegate respondsToSelector:@selector(onConnectionStatusChanged:)])
    {
        [self.conectDelegate onConnectionStatusChanged:status];
    }
}
#pragma mark queryMessage
- (void)queryLastedMessageWithConversationType:(RCConversationType) converstionType withConversationId:(NSString *)conversationId withCount:(NSInteger)count withHandle:(RCQueryMessagesBlock)block
{
    dispatch_async(_queryMessageQueue, ^{
        NSArray<RCMessage *> *messageArray = [_client getLatestMessages:converstionType targetId:conversationId count:(int)count];
        dispatch_async(dispatch_get_main_queue(), ^{
            !block ?:block([[messageArray reverseObjectEnumerator]allObjects],nil);
        });
    });
}

- (void)queryHistoryMessageWithConversationType:(RCConversationType) converstionType withConversationId:(NSString *)conversationId withCount:(NSInteger)count oldesetMessageId:(NSUInteger) messageId withHandle:(RCQueryMessagesBlock)block
{
    dispatch_async(_queryMessageQueue, ^{
        NSArray<RCMessage *> *messageArray = [_client getHistoryMessages:converstionType targetId:conversationId oldestMessageId:messageId count:(int)count];
        dispatch_async(dispatch_get_main_queue(), ^{
            !block ?:block([[messageArray reverseObjectEnumerator] allObjects],nil);
        });
    });
}
#pragma mark deleteMessage

- (void)deleteMessageWithMessageId:(int)messageId withHandle:(RCErrorBlock)block
{
    
}
#pragma makr recallMessage 撤回消息

#pragma mark 查询会话的消息
- (void)queryLastConversationListWithConversationTypeArray:(NSArray *)conversationTypeArr WithHandle:(RCQueryConversationListBlock)block
{
    dispatch_async(_queryConversationListQueue, ^{
        NSArray <RCConversation *> *conversationList = [_client getConversationList:conversationTypeArr];
        dispatch_async(dispatch_get_main_queue(), ^{
            !block ?:block(conversationList,nil);
        });
    });
}

- (void)getUnReadMessageCountWithConversationTypeArray:(NSArray *)conversationType withHandle:(RCIntegerResultBlock)block
{
    dispatch_async(dispatch_get_main_queue(), ^{
        int count = [_client getUnreadCount:conversationType];
        !block ?: block(count,nil);
    });
}

- (void)getTotalUnreadCountWithHandle:(RCIntegerResultBlock)block
{
    dispatch_async(dispatch_get_main_queue(), ^{
        int count = [_client getTotalUnreadCount];
        !block ?: block(count,nil);
    });
}
#pragma mark 消息设置成已读
- (void)setMessageReadStatusWithConversationId:(NSString *)conversationId withConversationType:(RCConversationType)type withHandle:(RCBooleanResultBlock)block
{
    dispatch_async(dispatch_get_main_queue(), ^{
        BOOL flag = [_client clearMessagesUnreadStatus:type targetId:conversationId];
        !block ?: block(flag,nil);
    });
}

- (void)deleteMessage:(NSArray<NSNumber *> *)messageIds
{
    BOOL flag =[_client deleteMessages:messageIds];
    if(flag)
    {
        NSLog(@"delete sucessed");
    }else
    {
        NSLog(@"delete failed");
    }
}

- (void)sendCustomMessages:(RCMessageContent*)messageContent withConversationId:(NSString *)conversationId conversationType:(RCConversationType)type failed:(RCErrorSendMessageBlock)failBlock sucessBlock:(RCSucessedSendMessageBlock)sucessBlock
{
    
    void (^sendCustomMessage)(void) = ^(void)
    {
        [_client sendMessage:type targetId:conversationId content:messageContent pushContent:nil pushData:nil success:^(long messageId) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if(sucessBlock)
                {
                    sucessBlock(messageId);
                }
            });
        } error:^(RCErrorCode nErrorCode, long messageId) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if(sucessBlock)
                {
                    failBlock(nErrorCode,messageId);
                }
            });
        }];
    };
    sendCustomMessage();
}
- (void)sendMediaMessages:(RCMessageContent*)messageContent withConversationId:(NSString *)conversationId conversationType:(RCConversationType)type withProgress:(RCProgressBlock)progressBlock failed:(RCErrorSendMessageBlock)failBlock sucessBlock:(RCSucessedSendMessageBlock)sucessBlock cancelBlock:(RCCancelSendMessageBlock)cancelBlock
{
    void (^sendMeidaMessage)(void) = ^(void)
    {
        [_client sendMediaMessage:type targetId:conversationId content:messageContent pushContent:nil pushData:nil progress:^(int progress, long messageId) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if(progressBlock)
                {
                    progressBlock(progress,messageId);
                }
            });
            
            
        } success:^(long messageId) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if(sucessBlock)
                {
                    sucessBlock(messageId);
                }
            });
            
        } error:^(RCErrorCode errorCode, long messageId) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if(failBlock)
                {
                    failBlock(errorCode,messageId);
                }
            });
            
        } cancel:^(long messageId) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if(cancelBlock)
                {
                    cancelBlock(messageId);
                }
            });
        }];
    };
    sendMeidaMessage();
}
- (void)recallMessage:(RCMessage *)message
              success:(void (^)(long messageId))successBlock
                error:(void(^)(RCErrorCode errorcode))errorBlock
{
    RCMessage * recallMessage = [self getMessageByMessagId:message.messageId];
    [_client recallMessage:recallMessage success:successBlock error:errorBlock];
}
- (RCMessage *)getMessageByMessagId:(NSInteger)messageId
{
    return [_client getMessage:messageId];
}
- (void)downloadMediaMessage:(RCMessage *)message withProgress:(RCDownMediaProgressBlock)progressBlock failed:(RCDownFailedBlock)failBlock sucessBlock:(RCDownMediaSucessedBlock)sucessBlock cancelBlock:(RCCancelDownMediaMessageBlock)cancelBlock
{
    [_client downloadMediaMessage:message.messageId progress:^(int progress) {
        dispatch_async(dispatch_get_main_queue(), ^{
            progressBlock(progress);
        });
    } success:^(NSString *mediaPath) {
        dispatch_async(dispatch_get_main_queue(), ^{
            sucessBlock(mediaPath);
        });
    } error:^(RCErrorCode errorCode) {
        dispatch_async(dispatch_get_main_queue(), ^{
            failBlock(errorCode);
        });
    } cancel:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            cancelBlock(message.messageId);
        });
    }];
    
}
@end
