//
//  RCChatFileMessageCell.m
//  rongchat
//
//  Created by VD on 2017/7/7.
//  Copyright © 2017年 vd. All rights reserved.
//

#import "RCChatFileMessageCell.h"

@interface RCChatFileMessageCell ()
@property (nonatomic,strong) UILabel * fileLabel;
@property (nonatomic,strong) UIButton * downButton;
@property (nonatomic,strong) UIImageView * fileIconImageView;
@property (nonatomic,strong) UIImageView * fileContentView;

@end

@implementation RCChatFileMessageCell
#pragma mark -
#pragma mark - LCCKChatMessageCellSubclassing Method

- (void)configureCellWithData:(RCMessage *)message
{
    [super configureCellWithData:message];
    RCFileMessage * fileContent = (RCFileMessage *)message.content;
    self.fileLabel.text = fileContent.name;
}
- (void)setup
{
    CGFloat fileContentViewHeight = 60;
    [self.messageContentView addSubview:self.fileContentView];
    [self.fileContentView addSubview:self.fileIconImageView];
    [self.fileContentView addSubview:self.fileLabel];
    [self.fileContentView addSubview:self.downButton];
    UIEdgeInsets edgeMessageBubbleCustomize;
    if (self.messageOwner == MessageDirection_SEND) {
        UIEdgeInsets rightEdgeMessageBubbleCustomize = [RCIMSettingService shareManager].rightHollowEdgeMessageBubbleCustomize;
        edgeMessageBubbleCustomize = rightEdgeMessageBubbleCustomize;
    } else {
        UIEdgeInsets leftEdgeMessageBubbleCustomize = [RCIMSettingService shareManager].leftHollowEdgeMessageBubbleCustomize;
        edgeMessageBubbleCustomize = leftEdgeMessageBubbleCustomize;
    }
    CGFloat offset = 8.0;
    [self.fileIconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.fileContentView.mas_left).mas_offset(offset);
        make.centerY.mas_equalTo(self.fileContentView.mas_centerY);
    }];
    [self.downButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.fileContentView.mas_centerY);
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(50);
        make.right.mas_equalTo(self.fileContentView.mas_right).mas_offset(-offset);
    }];
    [self.fileContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.messageContentView).with.insets(edgeMessageBubbleCustomize);
        make.width.lessThanOrEqualTo(@200);
        make.height.lessThanOrEqualTo(@(fileContentViewHeight));
    }];
    [self addGeneralView];
    [super setup];
    [self.fileLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.fileContentView.mas_centerY);
        make.right.mas_equalTo(self.downButton.mas_left).mas_offset(-offset);
        make.left.mas_equalTo(self.fileIconImageView.mas_right).mas_offset(offset);
    }];
}

- (UILabel *)fileLabel
{
    if(_fileLabel==nil)
    {
        _fileLabel = [UILabel new];
        _fileLabel.numberOfLines = 0;
    }
    return _fileLabel;
}

- (UIImageView *)fileIconImageView
{
    if(_fileIconImageView==nil)
    {
        _fileIconImageView = [UIImageView new];
        _fileIconImageView.image = [UIImage imageNamed:@"fav_fileicon_zip90"];
    }
    return _fileIconImageView;
}

- (UIButton *)downButton
{
    if(_downButton==nil)
    {
        _downButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_downButton setBackgroundImage:[UIImage imageNamed:@"fav_fileicon_zip90"] forState:UIControlStateNormal];
        [_downButton addTarget:self action:@selector(downloadFile:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _downButton;
}

- (UIImageView *)fileContentView
{
    if(_fileContentView==nil)
    {
        _fileContentView = [UIImageView new];
    }
    return _fileContentView;
}

- (void)downloadFile:(id)sender
{
    if([self.delegate respondsToSelector:@selector(fileMessageDidDownload:)])
    {
        [self.delegate fileMessageDidDownload:self];
    }
}



#pragma mark
+ (void)load {
    [self registerSubclass];
}

+ (NSString *)classMediaType {
    return RCFileMessageTypeIdentifier;
}

@end
