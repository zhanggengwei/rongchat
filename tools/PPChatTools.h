//
//  PPChatTools.h
//  rongChatDemo1
//
//  Created by vd on 2016/11/14.
//  Copyright © 2016年 vd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RongIMLib/RongIMLib.h>

@interface PPChatTools : NSObject

@property (nonatomic,assign,readonly) BOOL isLogin;

+ (instancetype)shareManager;
- (void)initRCIM;
- (void)deleteStoreItems;
- (void)logout;

- (void)autoLogin;

- (void)connectWithToken:(NSString *)token sucessBlock:(void (^)(NSString * content))block failBlock:(void(^)(RCConnectErrorCode code))failBlock tokenIncorrectBlock:(void(^)(void))tokenIncorrectBlock;

- (void)disconnect;

- (void)disconnectConnection:(BOOL)isReceivePush;




@end
