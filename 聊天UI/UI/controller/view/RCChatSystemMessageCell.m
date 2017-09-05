//
//  RCChatSystemMessageCell.m
//  rongchat
//
//  Created by VD on 2017/7/8.
//  Copyright © 2017年 vd. All rights reserved.
//

#import "RCChatSystemMessageCell.h"
#import "NSDate+RCIMDateTools.h"
@interface RCChatSystemMessageCell ()

@property (nonatomic, weak) UILabel *systemMessageLabel;
@property (nonatomic, strong) UIView *systemmessageContentView;
@property (nonatomic, strong, readonly) NSDictionary *systemMessageStyle;
@property (nonatomic, strong) UIColor *conversationViewTimeLineTextColor;
@property (nonatomic, strong) UIColor *conversationViewTimeLineBackgroundColor;

@end

@implementation RCChatSystemMessageCell
@synthesize systemMessageStyle = _systemMessageStyle;

#pragma mark - Override Methods

- (void)updateConstraints {
    [super updateConstraints];
    [self.systemmessageContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        CGFloat offset = 8;
        make.top.equalTo(self.contentView.mas_top).with.offset(offset);
        make.bottom.equalTo(self.contentView.mas_bottom).with.offset(-offset);
        CGFloat width = [UIApplication sharedApplication].keyWindow.frame.size.width;
        CGFloat height = [UIApplication sharedApplication].keyWindow.frame.size.height;
        CGFloat widthLimit = MIN(width, height)/5 * 4;
        make.width.lessThanOrEqualTo(@(widthLimit));
        make.centerX.equalTo(self.contentView.mas_centerX);
    }];
}

#pragma mark - Public Methods

- (void)setup {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.contentView addSubview:self.systemmessageContentView];
    [self updateConstraintsIfNeeded];
    [super setup];
}

- (void)configureCellWithData:(RCMessage *)message {
    [super configureCellWithData:message];
    
    if([message.objectName isEqualToString:RCTimeMessageTypeIdentifier])
    {
        self.systemMessageLabel.text = [NSDate systemMessageWithTimestamp:message.sentTime];
    }else if ([message.objectName isEqualToString:RCRecallNotificationMessageIdentifier])
    {
        RCRecallNotificationMessage * messageContent = (RCRecallNotificationMessage *)message.content;
        self.systemMessageLabel.text = [NSString stringWithFormat:@"%@撤回了一条消息",messageContent.operatorId];
    }else if ([message.objectName isEqualToString:RCGroupNotificationMessageIdentifier
               ])
    {
        RCGroupNotificationMessage * messageContent = (RCGroupNotificationMessage *)message.content;
        NSLog(@"message==%@ operation%@",messageContent.data,messageContent.operation);
        self.systemMessageLabel.text = [RCIMMessageTools transFromMessageToSystemTip:messageContent];
    }
   
}

#pragma mark - Getters

- (UIView *)systemmessageContentView {
    if (!_systemmessageContentView) {
        _systemmessageContentView = [[UIView alloc] init];
        _systemmessageContentView.backgroundColor = self.conversationViewTimeLineBackgroundColor ?: [UIColor lightGrayColor];
        _systemmessageContentView.alpha = .8f;
        _systemmessageContentView.layer.cornerRadius = 6.0f;
        _systemmessageContentView.translatesAutoresizingMaskIntoConstraints = NO;
        
        UILabel *systemMessageLabel = [[UILabel alloc] init];
        systemMessageLabel.numberOfLines = 0;
        systemMessageLabel.textColor = self.conversationViewTimeLineTextColor;
        [_systemmessageContentView addSubview:self.systemMessageLabel = systemMessageLabel];
        [systemMessageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            CGFloat offsetTopBottom = 0.5;//8
            CGFloat offsetLeftRight = 8;//8
            make.edges.equalTo(_systemmessageContentView).with.insets(UIEdgeInsetsMake(offsetTopBottom, offsetLeftRight, offsetTopBottom, offsetLeftRight));
        }];
        systemMessageLabel.attributedText = [[NSAttributedString alloc] initWithString:@"2016-8-14" attributes:self.systemMessageStyle];
    }
    return _systemmessageContentView;
}

- (NSDictionary *)systemMessageStyle {
    if (!_systemMessageStyle) {
        UIFont *font = [UIFont systemFontOfSize:14];
        NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
        style.paragraphSpacing = 0.15 * font.lineHeight;
        style.hyphenationFactor = 1.0;
        style.lineBreakMode = NSLineBreakByWordWrapping;
        style.alignment = NSTextAlignmentCenter;
        _systemMessageStyle = @{
                                NSFontAttributeName: font,
                                NSParagraphStyleAttributeName: style,
                                NSForegroundColorAttributeName: [UIColor whiteColor]
                                };
    }
    return _systemMessageStyle;
}

#pragma mark -
#pragma mark - LCCKChatMessageCellSubclassing Method

+ (void)load {
    [self registerSubclass];
}

+ (NSString *)classMediaType {
    return RCInformationNotificationMessageIdentifier;
}

- (UIColor *)conversationViewTimeLineTextColor {
    if (_conversationViewTimeLineTextColor) {
        return _conversationViewTimeLineTextColor;
    }
    _conversationViewTimeLineTextColor = [[RCIMSettingService shareManager] defaultThemeColorForKey:@"ConversationView-TimeLine-TextColor"];
    return _conversationViewTimeLineTextColor;
}

- (UIColor *)conversationViewTimeLineBackgroundColor {
    if (_conversationViewTimeLineBackgroundColor) {
        return _conversationViewTimeLineBackgroundColor;
    }
    _conversationViewTimeLineBackgroundColor = [[RCIMSettingService shareManager] defaultThemeColorForKey:@"ConversationView-TimeLine-BackgroundColor"];
    return _conversationViewTimeLineBackgroundColor;
}

@end

