//
//  LCCKConversationViewModel.h
//  rongchat
//
//  Created by VD on 2017/8/4.
//  Copyright © 2017年 vd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RCIMConversationViewController.h"
#import "RCIMBaseConversationViewController.h"
@protocol RCIMConversationViewModelDelegate <NSObject>
@optional
- (void)reloadAfterReceiveMessage;
- (void)messageSendStateChanged:(RCSentStatus)sendState  withProgress:(CGFloat)progress forIndex:(NSUInteger)index;
- (void)messageReadStateChanged:(RCReceivedStatus)readState withProgress:(CGFloat)progress forIndex:(NSUInteger)index;

@end

@interface RCIMConversationViewModel : NSObject<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, assign, readonly) NSUInteger messageCount;
@property (nonatomic,weak,readonly) RCIMBaseConversationViewController * parentController;

@property (nonatomic, weak) id<RCIMConversationViewModelDelegate> delegate;

- (instancetype)initWithParentViewController:(RCIMConversationViewController *)parentViewController;

@property (nonatomic,strong) NSString * conversationId;
@property (nonatomic,assign) RCConversationType conversationType;
@property (nonatomic, strong, readonly) NSMutableArray<RCMessage *> *dataArray;
@property (nonatomic, strong,readonly) NSMutableArray<RCMessage *> *imageArray;
@property (nonatomic, strong, readonly) NSMutableArray<RCMessage *> *voiceArray;
- (void)loadMessagesFirstTimeWithCallback:(RCIdBoolResultBlock)callback;
- (void)loadOldMessages;

- (void)deleteMessageWithCell:(RCChatBaseMessageCell *)cell withMessage:(RCMessage *)message;

- (void)sendMessage:(RCMessageContent *)content;
- (void)resendMessage:(RCMessage *)message;

- (void)sendMediaMessages:(NSArray<RCMessageContent *> *)contents;



@end
