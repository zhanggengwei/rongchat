//
//  PPChatTools.m
//  rongChatDemo1
//
//  Created by vd on 2016/11/14.
//  Copyright © 2016年 vd. All rights reserved.
//

#import "PPChatTools.h"
#import <RongIMLib/RongIMLib.h>


@interface PPChatTools ()<RCConnectionStatusChangeDelegate,RCIMClientReceiveMessageDelegate>

@property (nonatomic,strong)RCIMClient * client;

@end

@implementation PPChatTools


+ (instancetype)shareManager
{
    static PPChatTools * shareInstance;
    static dispatch_once_t token;
    
    dispatch_once(&token, ^{
        shareInstance = [PPChatTools new];
       
        shareInstance.client = [RCIMClient sharedRCIMClient];
        [shareInstance.client setRCConnectionStatusChangeDelegate:shareInstance];
        [shareInstance.client setReceiveMessageDelegate:shareInstance object:nil];
        [shareInstance initRCIM];
        
        
        
    });
    return shareInstance;
}
- (void)initRCIM
{
    [self setAppKey:@"n19jmcy59f1q9"];
   
}
- (void)setAppKey:(NSString *)key
{
    [self.client initWithAppKey:key];
    
}

- (void)setDeviceToken:(NSString *)deviceToken
{
    
}



- (void)logout
{
    [SFHFKeychainUtils deleteItemForUsername:kPPUserInfoUserID andServiceName:kPPServiceName error:nil];
    [SFHFKeychainUtils deleteItemForUsername:kPPLoginPassWord andServiceName:kPPServiceName error:nil];
    [SFHFKeychainUtils deleteItemForUsername:kPPLoginToekn andServiceName:kPPServiceName error:nil];
    [SFHFKeychainUtils deleteItemForUsername:kPPUserInfoUserID andServiceName:kPPServiceName error:nil];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:OBJC_APPIsLogin];
    
    [self.client logout];
    
}

- (void)autoLogin
{
    
}

- (void)connectWithToken:(NSString *)token sucessBlock:(void (^)(NSString * content))block failBlock:(void(^)(RCConnectErrorCode code))failBlock tokenIncorrectBlock:(void(^)(void))tokenIncorrectBlock
{
    [self.client connectWithToken:token success:block error:failBlock tokenIncorrect:tokenIncorrectBlock];
}
- (void)disconnect
{
    [self.client disconnect];
    
}

- (void)disconnectConnection:(BOOL)isReceivePush
{
    [self.client disconnect:isReceivePush];
    
}

#pragma mark RCConnectionStatusChangeDelegate

- (void)onConnectionStatusChanged:(RCConnectionStatus)status
{
    
}
#pragma mark RCIMClientReceiveMessageDelegate

/*!
 接收消息的回调方法
 
 @param message     当前接收到的消息
 @param nLeft       还剩余的未接收的消息数，left>=0
 @param object      消息监听设置的key值
 
 @discussion 如果您设置了IMlib消息监听之后，SDK在接收到消息时候会执行此方法。
 其中，left为还剩余的、还未接收的消息数量。比如刚上线一口气收到多条消息时，通过此方法，您可以获取到每条消息，left会依次递减直到0。
 您可以根据left数量来优化您的App体验和性能，比如收到大量消息时等待left为0再刷新UI。
 object为您在设置消息接收监听时的key值。
 */
- (void)onReceived:(RCMessage *)message left:(int)nLeft object:(id)object
{
    
}
/*!
 消息被撤回的回调方法
 
 @param messageId 被撤回的消息ID
 
 @discussion 被撤回的消息会变更为RCRecallNotificationMessage，App需要在UI上刷新这条消息。
 */
- (void)onMessageRecalled:(long)messageId
{
    
}

/*!
 请求消息已读回执（收到需要阅读时发送回执的请求，收到此请求后在会话页面已经展示该 messageUId 对应的消息或者调用 getHistoryMessages 获取消息的时候，包含此 messageUId 的消息，需要调用
 sendMessageReadReceiptResponse 接口发送消息阅读回执）
 
 @param messageUId 请求已读回执的消息ID
 */
- (void)onMessageReceiptRequest:(RCConversationType)conversationType targetId:(NSString *)targetId messageUId:(NSString *)messageUId
{
    
}

/*!
 消息已读回执响应（收到阅读回执响应，可以按照 messageUId 更新消息的阅读数）
 
 @param messageUId 已读回执的消息ID
 */
- (void)onMessageReceiptResponse:(RCConversationType)conversationType targetId:(NSString *)targetId messageUId:(NSString *)messageUId readerList:(NSMutableDictionary *)userIdList
{
    
}



@end
