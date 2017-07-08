//
//  RCChatImageMessageCell.m
//  rongchat
//
//  Created by VD on 2017/7/7.
//  Copyright © 2017年 vd. All rights reserved.
//

#import "RCChatImageMessageCell.h"


@interface RCChatImageMessageCell ()

@property (nonatomic,strong) UIImageView * messageImageView;
@property (nonatomic,strong) UIView * messageProgressView;
@property (nonatomic,strong) UILabel * messageProgressLabel;


@end

@implementation RCChatImageMessageCell

- (void)setup
{
    [self.contentView addSubview:self.messageImageView];
    [self.contentView addSubview:self.messageProgressView];
    [self.contentView addSubview:self.messageProgressLabel];
    UIEdgeInsets edgeMessageBubbleCustomize;
    if(self.messageOwner==RCMessageOwnerTypeSelf)
    {
        
    }
    else
    {
        
    }
}


- (void)configureCellWithData:(id)message
{
    [super configureCellWithData:message];
    RCImageMessage * model = message;
    
   
    
}


- (void)setUploadProgress:(CGFloat)uploadProgress
{
    [self setMessageSendState:RCMessageSendStateSending];
    self.messageProgressView.frame = CGRectMake(0, 0, self.messageProgressView.frame.size.width,self.messageProgressView.frame.size.height*(1-uploadProgress));
    [self.messageProgressLabel setText:[NSString stringWithFormat:@"%.0f%%",uploadProgress * 100]];
    
}
- (void)setMessageSendState:(RCMessageSendState)messageSendState {
    [super setMessageSendState:messageSendState];
    if (messageSendState == RCMessageSendStateSending) {
        if (!self.messageProgressView.superview) {
            [self.messageContentView addSubview:self.messageProgressView];
        }
        [self.messageProgressLabel setFrame:CGRectMake(0, self.messageImageView.image.size.height/2 - 8, self.messageImageView.image.size.width, 16)];
    } else {
        [self removeProgressView];
    }
}
- (void)removeProgressView {
    [self.messageProgressView removeFromSuperview];
    [[self.messageProgressView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    self.messageProgressView = nil;
    self.messageProgressLabel = nil;
}

- (UIImageView *)messageImageView
{
    if(_messageImageView==nil)
    {
        _messageImageView = [UIImageView new];
        _messageImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _messageImageView;
}

- (UIView *)messageProgressView
{
    if(_messageProgressView==nil)
    {
        _messageProgressView = [[UIView alloc] init];
        _messageProgressView.backgroundColor = [UIColor colorWithRed:.0f green:.0f blue:.0f alpha:.3f];
        _messageProgressView.translatesAutoresizingMaskIntoConstraints = NO;
        _messageProgressView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        UILabel *progressLabel = [[UILabel alloc] init];
        progressLabel.font = [UIFont systemFontOfSize:14.0f];
        progressLabel.textColor = [UIColor whiteColor];
        progressLabel.textAlignment = NSTextAlignmentCenter;
        [_messageProgressView addSubview:self.messageProgressLabel = progressLabel];
    }
    return _messageProgressView;
}


@end
