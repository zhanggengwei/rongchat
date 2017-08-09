//
//  PPChatTools.m
//  rongChatDemo1
//
//  Created by vd on 2016/11/14.
//  Copyright © 2016年 vd. All rights reserved.
//

#import "PPChatTools.h"


#import "PPDateEngine.h"

@interface PPChatTools ()
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
        [shareInstance initRCIM];
    });
    return shareInstance;
}
- (void)initRCIM
{
    //n19jmcy59f1q9  pwe86ga5ph4q6
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
    [self deleteStoreItems];
    [self.client logout];
    [[NSNotificationCenter defaultCenter]postNotificationName:kPPObserverLogoutSucess object:nil];
}

- (void)deleteStoreItems
{
    [SFHFKeychainUtils deleteItemForUsername:kPPUserInfoUserID andServiceName:kPPServiceName error:nil];
    [SFHFKeychainUtils deleteItemForUsername:kPPLoginPassWord andServiceName:kPPServiceName error:nil];
    [SFHFKeychainUtils deleteItemForUsername:kPPLoginToken andServiceName:kPPServiceName error:nil];
    [SFHFKeychainUtils deleteItemForUsername:kPPUserInfoUserID andServiceName:kPPServiceName error:nil];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:OBJC_APPIsLogin];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
}


- (void)autoLogin
{
    
    NSString * token = [SFHFKeychainUtils getPasswordForUsername:kPPLoginToken andServiceName:kPPServiceName error:nil];
    if(token==nil||token.length<=0)
    {
        [[PPChatTools shareManager]logout];
        return;
    }
    [self connectWithToken:token sucessBlock:^(NSString *content) {
        
    } failBlock:^(RCConnectErrorCode code) {
        NSLog(@"code ==%d",code);
        
    } tokenIncorrectBlock:^{
        [[PPChatTools shareManager]logout];
        [PPIndicatorView showString:@"token 错误" duration:1];
        
        
    }];
    
    
}

- (void)connectWithToken:(NSString *)token sucessBlock:(void (^)(NSString * content))block failBlock:(void(^)(RCConnectErrorCode code))failBlock tokenIncorrectBlock:(void(^)(void))tokenIncorrectBlock
{
    
    [self.client connectWithToken:token success:block error:failBlock tokenIncorrect:tokenIncorrectBlock];
}
- (void)disconnect
{
   
    
}

- (void)disconnectConnection:(BOOL)isReceivePush
{
   
}

#pragma mark onRCIMConnectionStatusChangedDelegate

- (void)onRCIMConnectionStatusChanged:(RCConnectionStatus)status
{
    NSLog(@"status == %ld",(long)status);
    if(status==ConnectionStatus_TOKEN_INCORRECT)
    {
        [self logout];
        [PPIndicatorView showString:@"token 失效" duration:1];
        
    }else if (status == ConnectionStatus_KICKED_OFFLINE_BY_OTHER_CLIENT)
    {
        [self logout];
        [PPIndicatorView showString:@"账号在其他设备上登录" duration:1];
        
        
    }
    
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
- (void)onRCIMReceiveMessage:(RCMessage *)message
                        left:(int)left
{
    NSLog(@"message",message);
}
/*!
 当App处于后台时，接收到消息并弹出本地通知的回调方法
 
 @param message     接收到的消息
 @param senderName  消息发送者的用户名称
 @return            当返回值为NO时，SDK会弹出默认的本地通知提示；当返回值为YES时，SDK针对此消息不再弹本地通知提示
 
 @discussion 如果您设置了IMKit消息监听之后，当App处于后台，收到消息时弹出本地通知之前，会执行此方法。
 如果App没有实现此方法，SDK会弹出默认的本地通知提示。
 流程：
 SDK接收到消息 -> App处于后台状态 -> 通过用户/群组/群名片信息提供者获取消息的用户/群组/群名片信息
 -> 用户/群组信息为空 -> 不弹出本地通知
 -> 用户/群组信息存在 -> 回调此方法准备弹出本地通知 -> App实现并返回YES        -> SDK不再弹出此消息的本地通知
 -> App未实现此方法或者返回NO -> SDK弹出默认的本地通知提示
 
 
 您可以通过RCIM的disableMessageNotificaiton属性，关闭所有的本地通知(此时不再回调此接口)。
 
 @warning 如果App在后台想使用SDK默认的本地通知提醒，需要实现用户/群组/群名片信息提供者，并返回正确的用户信息或群组信息。
 参考RCIMUserInfoDataSource、RCIMGroupInfoDataSource与RCIMGroupUserInfoDataSource
 */
-(BOOL)onRCIMCustomLocalNotification:(RCMessage*)message
                      withSenderName:(NSString *)senderName
{
    return NO;
}

/*!
 当App处于前台时，接收到消息并播放提示音的回调方法
 
 @param message 接收到的消息
 @return        当返回值为NO时，SDK会播放默认的提示音；当返回值为YES时，SDK针对此消息不再播放提示音
 
 @discussion 到消息时播放提示音之前，会执行此方法。
 如果App没有实现此方法，SDK会播放默认的提示音。
 流程：
 SDK接收到消息 -> App处于前台状态 -> 回调此方法准备播放提示音 -> App实现并返回YES        -> SDK针对此消息不再播放提示音
 -> App未实现此方法或者返回NO -> SDK会播放默认的提示音
 
 您可以通过RCIM的disableMessageAlertSound属性，关闭所有前台消息的提示音(此时不再回调此接口)。
 */
-(BOOL)onRCIMCustomAlertSound:(RCMessage*)message
{
    return NO;
}

/*!
 消息被撤回的回调方法
 
 @param messageId 被撤回的消息ID
 
 @discussion 被撤回的消息会变更为RCRecallNotificationMessage，App需要在UI上刷新这条消息。
 */
- (void)onRCIMMessageRecalled:(long)messageId
{
    
}

#pragma mark RCIMUserInfoDataSource

- (void)getUserInfoWithUserId:(NSString *)userId
                   completion:(void (^)(RCUserInfo *userInfo))completion
{
    
    [[PPDateEngine manager]requestGetUserInfoResponse:^(PPUserBaseInfoResponse * aTaskResponse) {
        if(aTaskResponse.code.integerValue == kPPResponseSucessCode)
        {
            PPUserBase * base = aTaskResponse.result;
            PPUserBaseInfo * userInfo = [PPUserBaseInfo new];
            userInfo.user = base;
            RCUserInfo * info = [[RCUserInfo alloc]initWithUserId:userId name:base.nickname portrait:base.portraitUri];
            
            
            completion(info);
        }
        
    } userID:userId];
    
}

@end
