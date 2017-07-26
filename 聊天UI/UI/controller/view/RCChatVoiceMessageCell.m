//
//  RCChatVoiceMessageCell.m
//  rongchat
//
//  Created by VD on 2017/7/7.
//  Copyright © 2017年 vd. All rights reserved.
//

#import "RCChatVoiceMessageCell.h"
#import "LCCKAVAudioPlayer.h"
#import "LCCKMessageVoiceFactory.h"

#import "NSObject+RCIMDeallocBlockExecutor.h"
static void * const LCCKChatVoiceMessageCellVoiceMessageStateContext = (void*)&LCCKChatVoiceMessageCellVoiceMessageStateContext;

@interface RCChatVoiceMessageCell ()

@property (nonatomic, strong) UIImageView *messageVoiceStatusImageView;
@property (nonatomic, strong) UILabel *messageVoiceSecondsLabel;
@property (nonatomic, strong) UIActivityIndicatorView *messageIndicatorView;

@end

@implementation RCChatVoiceMessageCell
- (void)prepareForReuse {
    [super prepareForReuse];
    [self setVoiceMessageState:RCVoiceMessageStateNormal];
}

- (void)updateConstraints {
    [super updateConstraints];
    if (self.messageOwner == MessageDirection_SEND) {
        [self.messageVoiceStatusImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.messageContentView.mas_right).with.offset(-12);
            make.centerY.equalTo(self.messageContentView.mas_centerY);
        }];
        [self.messageVoiceSecondsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.messageVoiceStatusImageView.mas_left).with.offset(-8);
            make.centerY.equalTo(self.messageContentView.mas_centerY);
        }];
        [self.messageIndicatorView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.messageContentView);
            make.width.equalTo(@10);
            make.height.equalTo(@10);
        }];
    } else if (self.messageOwner == MessageDirection_RECEIVE) {
        [self.messageVoiceStatusImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.messageContentView.mas_left).with.offset(12);
            make.centerY.equalTo(self.messageContentView.mas_centerY);
        }];
        
        [self.messageVoiceSecondsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.messageVoiceStatusImageView.mas_right).with.offset(8);
            make.centerY.equalTo(self.messageContentView.mas_centerY);
        }];
        [self.messageIndicatorView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.messageContentView);
            make.width.equalTo(@10);
            make.height.equalTo(@10);
        }];
    }
    
    [self.messageContentView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_greaterThanOrEqualTo(@(80)).priorityHigh();
    }];
    
}

#pragma mark - Public Methods

- (void)setup {
    [self.messageContentView addSubview:self.messageVoiceSecondsLabel];
    [self.messageContentView addSubview:self.messageVoiceStatusImageView];
    [self.messageContentView addSubview:self.messageIndicatorView];
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapMessageImageViewGestureRecognizerHandler:)];
    [self.messageContentView addGestureRecognizer:recognizer];
    [super setup];
    [self addGeneralView];
    self.voiceMessageState = RCVoiceMessageStateNormal;
    [[LCCKAVAudioPlayer sharePlayer]  addObserver:self forKeyPath:@"audioPlayerState" options:NSKeyValueObservingOptionNew context:LCCKChatVoiceMessageCellVoiceMessageStateContext];
    __unsafe_unretained __typeof(self) weakSelf = self;
    [self lcck_executeAtDealloc:^{
        [[LCCKAVAudioPlayer sharePlayer] removeObserver:weakSelf forKeyPath:@"audioPlayerState"];
    }];
}

// KVO监听执行
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if(context != LCCKChatVoiceMessageCellVoiceMessageStateContext) {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        return;
    }
    if(context == LCCKChatVoiceMessageCellVoiceMessageStateContext) {
        //if ([keyPath isEqualToString:@"audioPlayerState"]) {
        NSNumber *audioPlayerStateNumber = change[NSKeyValueChangeNewKey];
        RCVoiceMessageState audioPlayerState = [audioPlayerStateNumber intValue];
        switch (audioPlayerState) {
            case RCVoiceMessageStateCancel:
            case RCVoiceMessageStateNormal:
                self.voiceMessageState = RCVoiceMessageStateCancel;
                break;
                
            default: {
                NSString *playerIdentifier = [[LCCKAVAudioPlayer sharePlayer] identifier];
                if (playerIdentifier) {
                    NSString *messageId = @(self.message.messageId).stringValue;
                    if (playerIdentifier && [messageId isEqualToString:playerIdentifier]) {
                        self.voiceMessageState = audioPlayerState;
                    }
                }
            }
                break;
        }
    }
}

- (void)singleTapMessageImageViewGestureRecognizerHandler:(UITapGestureRecognizer *)tapGestureRecognizer {
    if (tapGestureRecognizer.state == UIGestureRecognizerStateEnded) {
        if ([self.delegate respondsToSelector:@selector(messageCellTappedMessage:)]) {
            [self.delegate messageCellTappedMessage:self];
        }
    }
}

- (void)configureCellWithData:(RCMessage *)message {
    [super configureCellWithData:message];
    RCVoiceMessage * voiceMessage = (RCVoiceMessage *)message.content;
    NSUInteger voiceDuration = voiceMessage.duration;
    NSString *voiceDurationString = [NSString stringWithFormat:@"%@", @(voiceDuration)];
    self.messageVoiceSecondsLabel.text = [NSString stringWithFormat:@"%@''", voiceDurationString];
    //设置正确的voiceMessageCell播放状态
    NSString *identifier = [[LCCKAVAudioPlayer sharePlayer] identifier];
    if (identifier) {
        NSString *messageId = @(message.messageId).stringValue;
        if (messageId == identifier) {
            if ([message.objectName isEqualToString:RCVoiceMessageTypeIdentifier]) {
                [self setVoiceMessageState:[[LCCKAVAudioPlayer sharePlayer] audioPlayerState]];
            }
        }
    }
    
    if (voiceDuration > 2) {
        __block CGFloat length;
        CGFloat lengthUnit = 10.f;
        // 1-2 长度固定, 2-10s每秒增加一个单位, 10-60s每10s增加一个单位
        do {
            if (voiceDuration <= 10) {
                length = lengthUnit*(voiceDuration-2);
                break;
            }
            if (voiceDuration > 10) {
                length = lengthUnit*(10-2) + lengthUnit*((voiceDuration-2)/10);
                break;
            }
        } while (NO);
        [self.messageContentView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@(80+length));
        }];
    } else {
        [self.messageContentView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@(80));
        }];
    }
}

#pragma mark - Getters

- (UIImageView *)messageVoiceStatusImageView {
    if (!_messageVoiceStatusImageView) {
        _messageVoiceStatusImageView = [LCCKMessageVoiceFactory messageVoiceAnimationImageViewWithBubbleMessageType:self.messageOwner];
    }
    return _messageVoiceStatusImageView;
}

- (UILabel *)messageVoiceSecondsLabel {
    if (!_messageVoiceSecondsLabel) {
        _messageVoiceSecondsLabel = [[UILabel alloc] init];
        _messageVoiceSecondsLabel.font = [UIFont systemFontOfSize:14.0f];
        _messageVoiceSecondsLabel.text = @"0''";
    }
    return _messageVoiceSecondsLabel;
}

- (UIActivityIndicatorView *)messageIndicatorView {
    if (!_messageIndicatorView) {
        _messageIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    }
    return _messageIndicatorView;
}

#pragma mark - Setters

- (void)setVoiceMessageState:(RCVoiceMessageState)voiceMessageState {
    if (_voiceMessageState != voiceMessageState) {
        _voiceMessageState = voiceMessageState;
    }
    self.messageVoiceSecondsLabel.hidden = NO;
    self.messageVoiceStatusImageView.hidden = NO;
    self.messageIndicatorView.hidden = YES;
    [self.messageIndicatorView stopAnimating];
    
    if (_voiceMessageState == RCVoiceMessageStatePlaying) {
        self.messageVoiceStatusImageView.highlighted = YES;
        [self.messageVoiceStatusImageView startAnimating];
    } else if (_voiceMessageState == RCVoiceMessageStateDownloading) {
        self.messageVoiceSecondsLabel.hidden = YES;
        self.messageVoiceStatusImageView.hidden = YES;
        self.messageIndicatorView.hidden = NO;
        [self.messageIndicatorView startAnimating];
    } else {
        self.messageVoiceStatusImageView.highlighted = NO;
        [self.messageVoiceStatusImageView stopAnimating];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
+ (void)load {
    [self registerSubclass];
}

+ (NSString *)classMediaType {
    return RCVoiceMessageTypeIdentifier;
}
@end
