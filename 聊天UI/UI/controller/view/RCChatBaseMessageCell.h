//
//  RCChatBaseMessageCell.h
//  rongchat
//
//  Created by VD on 2017/7/6.
//  Copyright © 2017年 vd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RCContentView.h"
#import "RCMessageSendStateView.h"
#import <MLLabel/MLLinkLabel.h>

@class RCChatBaseMessageCell;

@interface UITableView (cell)

- (RCChatBaseMessageCell *)dequeueReusableCellWithIdentifier:(NSString *)Identifier;

@end



@protocol RCChatMessageCellSubclassing <NSObject>
@required
/*!
 子类实现此方法用于返回该类对应的消息类型
 @return 消息类型
 */
+ (RCIMMessageMediaType)classMediaType;
@end

@protocol RCIMChatMessageCellDelegate <NSObject>

- (void)messageCellTappedBlank:(RCChatBaseMessageCell *)messageCell;
- (void)messageCellTappedHead:(RCChatBaseMessageCell *)messageCell;
- (void)messageCellTappedMessage:(RCChatBaseMessageCell *)messageCell;
- (void)textMessageCellDoubleTapped:(RCChatBaseMessageCell *)messageCell;
- (void)resendMessage:(RCChatBaseMessageCell *)messageCell;
- (void)avatarImageViewLongPressed:(RCChatBaseMessageCell *)messageCell;
- (void)messageCell:(RCChatBaseMessageCell *)messageCell didTapLinkText:(NSString *)linkText linkType:(MLLinkType)linkType;
- (void)fileMessageDidDownload:(RCChatBaseMessageCell *)messageCell;

@end


//聊天页面显示的基础cell
@interface RCChatBaseMessageCell : UITableViewCell

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, weak) id<RCIMChatMessageCellDelegate>delegate;


@property (nonatomic,strong) UIImageView * avatarImageView;
//头像
@property (nonatomic,strong) UIActivityIndicatorView *indicatorView;
/**
 *  显示消息发送状态的UIImageView -> 用于消息发送不成功时显示
 */
@property (nonatomic, strong) RCMessageSendStateView *messageSendStateView;

/**
 *  显示消息阅读状态的UIImageView -> 主要用于VoiceMessage
 */
@property (nonatomic, strong) UIImageView *messageReadStateImageView;

/**
 *  messageContentView的背景层
 */
@property (nonatomic, strong) UIImageView *messageContentBackgroundImageView;

@property (nonatomic,strong,readonly) RCMessage * message;//conversation

@property (nonatomic,strong) UILabel * nickNameLabel;
//用户的名称

/**
 *  显示用户消息主体的View,所有的消息用到的textView,imageView都会被添加到这个view中 -> LCCKContentView 自带一个CAShapeLayer的蒙版
 */
@property (nonatomic, strong) RCContentView *messageContentView;

/**
 *  消息的类型,只读类型,会根据自己的具体实例类型进行判断
 */
@property (nonatomic, assign, readonly) RCIMMessageMediaType mediaType;
/**
 *  消息发送状态,当状态为LCCKMessageSendFail或LCCKMessageSendStateSending时,LCCKmessageSendStateImageView显示
 */
@property (nonatomic, assign) RCMessageSendState messageSendState;
/**
 *  消息阅读状态,当状态为LCCKMessageUnRead时,LCCKmessageReadStateImageView显示
 */
@property (nonatomic, assign) RCMessageReadState messageReadState;
@property (nonatomic, strong) NSString * custom_reuseIdentifier;

/**
 *  消息群组类型,只读类型,根据reuseIdentifier判断
 */
@property (nonatomic, assign) RCConversationType messageChatType;
@property (nonatomic, assign, readonly) RCMessageOwnerType messageOwner;

+ (void)registerCustomMessageCell;
+ (void)registerSubclass;
- (void)addGeneralView;


#pragma mark - Public Methods

- (void)setup;
- (void)configureCellWithData:(RCMessage *)message;

@end
