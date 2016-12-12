//
//  RCIM.m
//  rongchat
//
//  Created by Donald on 16/12/6.
//  Copyright © 2016年 vd. All rights reserved.
//

#import "RCIM.h"

@interface RCIM ()<RCIMClientReceiveMessageDelegate,RCConnectionStatusChangeDelegate>


@property (nonatomic,strong) RCIMClient * client;

@end

@implementation RCIM
/*
获取融云界面组件IMKit的核心类单例

@return    融云界面组件IMKit的核心类单例

@discussion 您可以通过此方法，获取IMKit的单例，访问对象中的属性和方法。
*/
+ (instancetype)sharedRCIM
{
    static dispatch_once_t  token;
    static RCIM * sharedRCIM;
    dispatch_once(&token, ^{
        sharedRCIM = [self new];
       
    });
    return sharedRCIM;
    
}
- (void)initWithAppKey:(NSString *)appKey
{
    self.client = [RCIMClient sharedRCIMClient];
    [self.client initWithAppKey:appKey];
   
    [self.client setReceiveMessageDelegate:self object:nil];
    [self.client setRCConnectionStatusChangeDelegate:self];
    
    
}

- (void)connectWithToken:(NSString *)token
                 success:(void (^)(NSString *userId))successBlock
                   error:(void (^)(RCConnectErrorCode status))errorBlock
          tokenIncorrect:(void (^)())tokenIncorrectBlock
{
    [self.client connectWithToken:token success:successBlock error:errorBlock tokenIncorrect:tokenIncorrectBlock];
    
}

- (void)disconnect:(BOOL)isReceivePush
{
    [self.client disconnect:isReceivePush];
    
}
- (void)disconnect
{
    [self.client disconnect];
}
- (void)logout
{
    [self.client logout];
}
- (void)onReceived:(RCMessage *)message left:(int)nLeft object:(id)object
{
    NSLog(@"%@",message.content);
}
- (void)onConnectionStatusChanged:(RCConnectionStatus)status
{
    if(self.connectionStatusDelegate&&[self.connectionStatusDelegate respondsToSelector:@selector(onRCIMConnectionStatusChanged:)])
    {
        [self.connectionStatusDelegate onRCIMConnectionStatusChanged:status];
        
    }
}




@end
