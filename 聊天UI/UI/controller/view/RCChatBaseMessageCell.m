//
//  RCChatBaseMessageCell.m
//  rongchat
//
//  Created by VD on 2017/7/6.
//  Copyright © 2017年 vd. All rights reserved.
//

#import "RCChatBaseMessageCell.h"
#import "RCIMMenuItem.h"
#import "RCIMSettingService.h"
#import "RCBubbleImageFactory.h"
#import "UIImageView+RCIMExtension.h"
#import "UIImage+RCIMExtension.h"
#import "NSObject+RCIMExtension.h"
#import "NSObject+RCIMDeallocBlockExecutor.h"
#import "RCIMConversationModel.h"

NSMutableDictionary const * RCChatMessageCellMediaTypeDict = nil;

static CGFloat const kAvatarImageViewWidth = 50.f;
static CGFloat const kAvatarImageViewHeight = kAvatarImageViewWidth;
static CGFloat const RCIMMessageSendStateViewWidthHeight = 30.f;
static CGFloat const RCIMMessageSendStateViewLeftOrRightToMessageContentView = 2.f;
static CGFloat const RCIMAvatarToMessageContent = 5.f;

static CGFloat const RCIMAvatarBottomToMessageContentTop = -1.f;


static CGFloat const RCIM_MSG_CELL_EDGES_OFFSET = 16;
static CGFloat const RCIM_MSG_CELL_NICKNAME_HEIGHT = 16;
static CGFloat const RCIM_MSG_CELL_NICKNAME_FONT_SIZE = 12;

@interface RCChatBaseMessageCell ()<RCSendImageViewDelegate>

@property (nonatomic, strong, readwrite) RCMessage *message;
@property (nonatomic, assign, readwrite) NSString * mediaType;
@property (nonatomic, strong) UIColor *conversationViewSenderNameTextColor;


@end

@implementation RCChatBaseMessageCell

+ (void)registerCustomMessageCell {
    [self registerSubclass];
}

+ (void)registerSubclass {
    if ([self conformsToProtocol:@protocol(RCChatMessageCellSubclassing)]) {
        Class<RCChatMessageCellSubclassing> class = self;
        NSString * mediaType = [class classMediaType];
        [self registerClass:class forMediaType:mediaType];
    }
}

+ (Class)classForMediaType:(NSString *)mediaType {
    NSString *key = mediaType;
    Class class = [RCChatMessageCellMediaTypeDict objectForKey:key];
    if (!class) {
        class = self;
    }
    return class;
}

+ (void)registerClass:(Class)class forMediaType:(NSString *)mediaType {
    if (!RCChatMessageCellMediaTypeDict) {
        RCChatMessageCellMediaTypeDict = [[NSMutableDictionary alloc] init];
    }
    
    NSString *key = mediaType;
    Class c = [RCChatMessageCellMediaTypeDict objectForKey:key];
    if (!c || [class isSubclassOfClass:c]) {
        [RCChatMessageCellMediaTypeDict setObject:class forKey:key];
    }
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    NSString * identify = [self RCIM_registerCell:reuseIdentifier];
    if (self = [super initWithStyle:style reuseIdentifier:identify]) {
        [self setup];
        [self addObserver:self forKeyPath:@"self.message.sentStatus" options:NSKeyValueObservingOptionNew context:nil];
        [self lcck_executeAtDealloc:^{
            [self removeObserver:self forKeyPath:@"self.message.sentStatus"];
            
        }];
    }
    return self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if([keyPath isEqualToString:@"self.message.sentStatus"])
    {
        NSLog(@"fff");
    }
}



// add support for RCIMMenuItem. Needs to be called once per class.
+ (void)load {
    [RCIMMenuItem installMenuHandlerForObject:self];
}

+ (void)initialize {
    [RCIMMenuItem installMenuHandlerForObject:self];
}

#pragma mark - Life Cycle

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

#pragma mark - Override Methods

- (BOOL)showName {
    BOOL isMessageOwner = self.messageOwner == MessageDirection_RECEIVE;
    BOOL isMessageChatTypeGroup = self.messageChatType == ConversationType_GROUP;
    if (isMessageOwner && isMessageChatTypeGroup) {
        self.nickNameLabel.hidden = NO;
        return YES;
    }
    self.nickNameLabel.hidden = YES;
    return NO;
}

- (void)updateConstraints {
    [super updateConstraints];
    if (self.messageOwner == RCMessageSystemMesage) {
        return;
    }
    if (self.messageOwner == MessageDirection_SEND) {
        if (self.avatarImageView.superview) {
            [self.avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.contentView.mas_right).with.offset(-RCIM_MSG_CELL_EDGES_OFFSET);
                make.top.equalTo(self.contentView.mas_top).with.offset(RCIM_MSG_CELL_EDGES_OFFSET);
                make.width.equalTo(@(kAvatarImageViewWidth));
                make.height.equalTo(@(kAvatarImageViewHeight));
            }];
        }
        if (self.nickNameLabel.superview) {
            [self.nickNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.avatarImageView.mas_top);
                make.right.equalTo(self.avatarImageView.mas_left).with.offset(-RCIM_MSG_CELL_EDGES_OFFSET);
                make.width.mas_lessThanOrEqualTo(@120);
                make.height.equalTo(@0);
            }];
        }
        if (self.messageContentView.superview) {
            [self.messageContentView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.avatarImageView.mas_left).with.offset(-RCIMAvatarToMessageContent);
                make.top.equalTo(self.nickNameLabel.mas_bottom).with.offset(self.showName ? 0 : RCIMAvatarBottomToMessageContentTop);
                CGFloat width = [UIApplication sharedApplication].keyWindow.frame.size.width;
                CGFloat height = [UIApplication sharedApplication].keyWindow.frame.size.height;
                CGFloat widthLimit = MIN(width, height)/5 * 3;
                
                make.width.lessThanOrEqualTo(@(widthLimit)).priorityHigh();
                make.bottom.equalTo(self.contentView.mas_bottom).with.offset(-RCIM_MSG_CELL_EDGES_OFFSET).priorityLow();
            }];
        }
        if (self.messageSendStateView.superview) {
            [self.messageSendStateView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.messageContentView.mas_left).with.offset(-RCIMMessageSendStateViewLeftOrRightToMessageContentView);
                make.centerY.equalTo(self.messageContentView.mas_centerY);
                make.width.equalTo(@(RCIMMessageSendStateViewWidthHeight));
                make.height.equalTo(@(RCIMMessageSendStateViewWidthHeight));
            }];
        }
        if (self.messageReadStateImageView.superview) {
            [self.messageReadStateImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.messageContentView.mas_left).with.offset(-8);
                make.centerY.equalTo(self.messageContentView.mas_centerY);
                make.width.equalTo(@10);
                make.height.equalTo(@10);
            }];
        }
    } else if (self.messageOwner == MessageDirection_RECEIVE){
        
        if (self.avatarImageView.superview) {
            [self.avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.contentView.mas_left).with.offset(RCIM_MSG_CELL_EDGES_OFFSET);
                make.top.equalTo(self.contentView.mas_top).with.offset(RCIM_MSG_CELL_EDGES_OFFSET);
                make.width.equalTo(@(kAvatarImageViewWidth));
                make.height.equalTo(@(kAvatarImageViewHeight));
            }];
        }
        if (self.nickNameLabel.superview) {
            [self.nickNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.avatarImageView.mas_top);
                make.left.equalTo(self.avatarImageView.mas_right).with.offset(RCIM_MSG_CELL_EDGES_OFFSET);
                make.width.mas_lessThanOrEqualTo(@120);
                make.height.equalTo(self.messageChatType == ConversationType_GROUP ? @(RCIM_MSG_CELL_NICKNAME_HEIGHT) : @0);
            }];
        }
        if (self.messageContentView.superview) {
            [self.messageContentView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.avatarImageView.mas_right).with.offset(RCIMAvatarToMessageContent);
                make.top.equalTo(self.nickNameLabel.mas_bottom).with.offset(self.showName ? 0 : RCIMAvatarBottomToMessageContentTop);
                CGFloat width = [UIApplication sharedApplication].keyWindow.frame.size.width;
                CGFloat height = [UIApplication sharedApplication].keyWindow.frame.size.height;
                CGFloat widthLimit = MIN(width, height)/5 * 3;
                make.width.lessThanOrEqualTo(@(widthLimit)).priorityHigh();
                make.bottom.equalTo(self.contentView.mas_bottom).with.offset(-RCIM_MSG_CELL_EDGES_OFFSET).priorityLow();
            }];
        }
        if (self.messageSendStateView.superview) {
            [self.messageSendStateView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.messageContentView.mas_right).with.offset(RCIMMessageSendStateViewLeftOrRightToMessageContentView);
                make.centerY.equalTo(self.messageContentView.mas_centerY);
                make.width.equalTo(@(RCIMMessageSendStateViewWidthHeight));
                make.height.equalTo(@(RCIMMessageSendStateViewWidthHeight));
            }];
        }
        if (self.messageReadStateImageView.superview) {
            [self.messageReadStateImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.messageContentView.mas_right).with.offset(8);
                make.centerY.equalTo(self.messageContentView.mas_centerY);
                make.width.equalTo(@10);
                make.height.equalTo(@10);
            }];
        }
        
    }
    
    if (self.messageContentBackgroundImageView.superview) {
        [self.messageContentBackgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.messageContentView);
        }];
    }
    
    if (!self.showName) {
        if (self.nickNameLabel.superview) {
            [self.nickNameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(@0);
            }];
        }
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    CGPoint touchPoint = [[touches anyObject] locationInView:self.contentView];
    if (CGRectContainsPoint(self.messageContentView.frame, touchPoint)) {
        self.messageContentBackgroundImageView.highlighted = YES;
    }
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesCancelled:touches withEvent:event];
    self.messageContentBackgroundImageView.highlighted = NO;
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    self.messageContentBackgroundImageView.highlighted = NO;
}

#pragma mark - Private Methods

- (BOOL)isAbleToTap {
    BOOL isAbleToTap = NO;
    //For Link handle
    if (self.mediaType < 0 && ![self isKindOfClass:[RCChatTextMessageCell class]]) {
        isAbleToTap = YES;
    }
    return isAbleToTap;
}

- (void)addGeneralView {
    
    [self.contentView addSubview:self.avatarImageView];
    [self.contentView addSubview:self.nickNameLabel];
    [self.contentView addSubview:self.messageContentView];
    [self.contentView addSubview:self.messageReadStateImageView];
    [self.contentView addSubview:self.messageSendStateView];
    
    [self.messageContentBackgroundImageView setImage:[RCBubbleImageFactory bubbleImageViewForType:self.messageOwner messageType:self.mediaType isHighlighted:NO]];
    [self.messageContentBackgroundImageView setHighlightedImage:[RCBubbleImageFactory bubbleImageViewForType:self.messageOwner messageType:self.mediaType isHighlighted:YES]];
    
    self.messageContentView.layer.mask.contents = (__bridge id _Nullable)(self.messageContentBackgroundImageView.image.CGImage);
    [self.contentView insertSubview:self.messageContentBackgroundImageView belowSubview:self.messageContentView];
    [self updateConstraintsIfNeeded];
    
    self.messageSendStateView.hidden = YES;
    self.messageReadStateImageView.hidden = YES;
    
    
    if (self.isAbleToTap) {
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
        [self.contentView addGestureRecognizer:tap];
    }
    UITapGestureRecognizer *avatarImageViewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(avatarImageViewHandleTap:)];
    self.avatarImageView.userInteractionEnabled = YES;
    [self.avatarImageView addGestureRecognizer:avatarImageViewTap];
    
    UILongPressGestureRecognizer *recognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
    [recognizer setMinimumPressDuration:0.4f];
    [self addGestureRecognizer:recognizer];
}

- (void)setup {
    if (![self conformsToProtocol:@protocol(RCChatMessageCellSubclassing)]) {
        [NSException raise:@"RCIMChatMessageCellNotSubclassException" format:@"Class does not conform RCIMChatMessageCellSubclassing protocol."];
    }
    self.mediaType = [[self class] classMediaType];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = [UIColor clearColor];;
}

#pragma mark - Public Methods

- (void)configureCellWithData:(RCMessage *)message {
    //只考虑几种常用的信息
    _message = message;
    if (message.senderUserId) {
        self.messageSendState = message.sentStatus;
        [[[PPTUserInfoEngine shareEngine]getUserInfoByUserId:message.senderUserId]subscribeNext:^(RCUserInfoData * data)
         {
             self.nickNameLabel.text = data.user.name;
             UIImage * image = RCIM_PLACE_ARATARIMAGE;
             SD_LOADIMAGE(self.avatarImageView,data.user.portraitUri,image);
         }];
    }
}

#pragma mark - Private Methods

- (void)handleTap:(UITapGestureRecognizer *)tap {
    if (tap.state == UIGestureRecognizerStateEnded) {
        CGPoint tapPoint = [tap locationInView:self.contentView];
        if (CGRectContainsPoint(self.messageContentView.frame, tapPoint)) {
            [self.delegate messageCellTappedMessage:self];
        }  else if (!CGRectContainsPoint(self.avatarImageView.frame, tapPoint)) {
            //FIXME:Never invoked
            [self.delegate messageCellTappedBlank:self];
        }
    }
}

- (void)avatarImageViewHandleTap:(UITapGestureRecognizer *)tap {
    if (tap.state == UIGestureRecognizerStateEnded) {
        [self.delegate messageCellTappedHead:self];
    }
}

#pragma mark - Setters

- (void)setMessageSendState:(RCSentStatus)messageSendState {
    _messageSendState = messageSendState;
    if (self.messageOwner == MessageDirection_RECEIVE) {
        self.messageSendStateView.hidden = YES;
    }else
    {
        self.messageSendStateView.hidden = NO;
        
    }
    self.messageSendStateView.messageSendState = messageSendState;
}

- (void)setMessageReadState:(RCMessageReadState)messageReadState {
    _messageReadState = messageReadState;
    if (self.messageOwner == MessageDirection_SEND) {
        self.messageSendStateView.hidden = YES;
    }
    switch (_messageReadState) {
        case RCMessageUnRead:
            self.messageReadStateImageView.hidden = NO;
            break;
        default:
            self.messageReadStateImageView.hidden = YES;
            break;
    }
}

#pragma mark - Getters

- (UIImageView *)avatarImageView {
    if (!_avatarImageView) {
        _avatarImageView = [[UIImageView alloc] init];
        _avatarImageView.contentMode = UIViewContentModeScaleAspectFill;
        _avatarImageView.lcck_cornerRadius = 6;
        _avatarImageView.layer.masksToBounds = YES;
        
        [self bringSubviewToFront:_avatarImageView];
    }
    return _avatarImageView;
}

- (UILabel *)nickNameLabel {
    if (!_nickNameLabel) {
        _nickNameLabel = [[UILabel alloc] init];
        _nickNameLabel.font = [UIFont systemFontOfSize:RCIM_MSG_CELL_NICKNAME_FONT_SIZE];
        _nickNameLabel.textColor = self.conversationViewSenderNameTextColor;
        _nickNameLabel.text = @"nickname";
        [_nickNameLabel sizeToFit];
    }
    return _nickNameLabel;
}

- (RCContentView *)messageContentView {
    if (!_messageContentView) {
        _messageContentView = [[RCContentView alloc] init];
    }
    return _messageContentView;
}

- (UIImageView *)messageReadStateImageView {
    if (!_messageReadStateImageView) {
        _messageReadStateImageView = [[UIImageView alloc] init];
    }
    return _messageReadStateImageView;
}

- (RCMessageSendStateView *)messageSendStateView {
    if (!_messageSendStateView) {
        _messageSendStateView = [[RCMessageSendStateView alloc] init];
        _messageSendStateView.delegate = self;
    }
    return _messageSendStateView;
}

- (UIImageView *)messageContentBackgroundImageView {
    if (!_messageContentBackgroundImageView) {
        _messageContentBackgroundImageView = [[UIImageView alloc] init];
    }
    return _messageContentBackgroundImageView;
}

- (RCConversationType)messageChatType {
    
    return self.message.conversationType;
    
}

- (RCMessageDirection)messageOwner {
    
    
    return [self getMessageOwerTypeWithReuseIdentifier:self.reuseIdentifier];
}

- (void)handleLongPress:(UILongPressGestureRecognizer *)longPressGes {
    
    if (longPressGes.state == UIGestureRecognizerStateBegan) {
        CGPoint longPressPoint = [longPressGes locationInView:self.contentView];
        if (!CGRectContainsPoint(self.messageContentView.frame, longPressPoint)) {
            if (CGRectContainsPoint(self.avatarImageView.frame, longPressPoint)) {
                if ([self.delegate respondsToSelector:@selector(avatarImageViewLongPressed:)]) {
                    [self.delegate avatarImageViewLongPressed:self];
                }
            }
            return;
        }
        [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
        NSUInteger delaySeconds = RCAnimateDuration;
        
        dispatch_time_t when = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delaySeconds * NSEC_PER_SEC));
        dispatch_after(when, dispatch_get_main_queue(), ^{
            [self becomeFirstResponder];
            //            RCIMLongPressMessageBlock longPressMessageBlock = [LCChatKit sharedInstance].longPressMessageBlock;
            NSArray *menuItems = [NSArray array];
            //            NSDictionary *userInfo = @{
            //                                       LCCKLongPressMessageUserInfoKeyFromController : self.delegate,
            //                                       LCCKLongPressMessageUserInfoKeyFromView : self.tableView,
            //                                       };
            //            if (longPressMessageBlock) {
            ////                menuItems = longPressMessageBlock(self.message, userInfo);
            //            } else {
            
            
            RCIMMenuItem *copyItem = [[RCIMMenuItem alloc] initWithTitle:@"copy"
                                                                   block:^{
                                                                       RCTextMessage * textMessage = (RCTextMessage *)self.message.content;
                                                                       
                                                                       UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
                                                                       [pasteboard setString:textMessage.content];
                                                                   }];
            //TODO:添加“转发”
            if ([self.message.objectName isEqualToString:RCTextMessageTypeIdentifier]) {
                menuItems = @[[self deleteItem],copyItem,[self recallMessageItem]];
            }else
            {
                menuItems = @[[self deleteItem],copyItem,[self recallMessageItem]];
            }
            //}
            UIMenuController *menuController = [UIMenuController sharedMenuController];
            [menuController setMenuItems:menuItems];
            [menuController setArrowDirection:UIMenuControllerArrowDown];
            UITableView *tableView = self.tableView;
            CGRect targetRect = [self convertRect:self.messageContentView.frame toView:tableView];
            [menuController setTargetRect:targetRect inView:tableView];
            
            [[NSNotificationCenter defaultCenter] addObserver:self
                                                     selector:@selector(handleMenuWillShowNotification:)
                                                         name:UIMenuControllerWillShowMenuNotification
                                                       object:nil];
            [menuController setMenuVisible:YES animated:YES];
            
        });
    }
    
}

#pragma mark - Notifications

- (void)handleMenuWillHideNotification:(NSNotification *)notification {
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIMenuControllerWillHideMenuNotification
                                                  object:nil];
}

- (void)handleMenuWillShowNotification:(NSNotification *)notification {
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIMenuControllerWillShowMenuNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleMenuWillHideNotification:)
                                                 name:UIMenuControllerWillHideMenuNotification
                                               object:nil];
}

#pragma mark -
#pragma mark - RCIMSendImageViewDelegate Method

- (void)resendMessage:(id)sender {
    if ([self.delegate respondsToSelector:@selector(resendMessage:)]) {
        [self.delegate resendMessage:self];
    }
}

- (UIColor *)conversationViewSenderNameTextColor {
    if (_conversationViewSenderNameTextColor) {
        return _conversationViewSenderNameTextColor;
    }
    _conversationViewSenderNameTextColor = [[RCIMSettingService shareManager] defaultThemeColorForKey:@"ConversationView-SenderName-TextColor"];
    return _conversationViewSenderNameTextColor;
}

- (RCIMMenuItem *)deleteItem
{
    RCIMMenuItem * deleteItem = [[RCIMMenuItem alloc]initWithTitle:@"删除" block:^{
        if([self.delegate respondsToSelector:@selector(messageCellDidDeleteMessageCell:message:)])
        {
            [self.delegate messageCellDidDeleteMessageCell:self message:self.message];
        }
    }];
    return deleteItem;
}

- (RCIMMenuItem *)recallMessageItem
{
    RCIMMenuItem * recallMessageItem = [[RCIMMenuItem alloc]initWithTitle:@"撤回" block:^{
        if([self.delegate respondsToSelector:@selector(messageCellDidRecallMessageCell:message:)])
        {
            [self.delegate messageCellDidRecallMessageCell:self message:self.message];
        }
    }];
    return recallMessageItem;
}


@end


