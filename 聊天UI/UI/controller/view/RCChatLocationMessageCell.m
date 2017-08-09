//
//  RCChatLocationMessageCell.m
//  rongchat
//
//  Created by VD on 2017/7/8.
//  Copyright © 2017年 vd. All rights reserved.
//

#import "RCChatLocationMessageCell.h"
#import "RCIMSettingService.h"
#import "UIImage+RCIMExtension.h"

@interface RCChatLocationMessageCell ()


@property (nonatomic, strong) UIImageView *locationImageView;
@property (nonatomic, strong) UILabel *locationAddressLabel;
@property (nonatomic, strong) UIView *locationAddressOverlay;

@end
@implementation RCChatLocationMessageCell

#pragma mark - Override Methods

- (void)configureCellWithData:(RCMessage *)message {
    [super configureCellWithData:message];
    RCLocationMessage * locationMessage = (RCLocationMessage *)message.content;
    self.locationAddressLabel.text = locationMessage.locationName;
    self.locationImageView.image = locationMessage.thumbnailImage;
}

#pragma mark - Public Methods

- (void)setup {
    [self.messageContentView addSubview:self.locationImageView];
    [self.messageContentView addSubview:self.locationAddressOverlay];
    
    UIEdgeInsets edgeMessageBubbleCustomize;
    if (self.messageOwner == MessageDirection_SEND) {
        UIEdgeInsets rightEdgeMessageBubbleCustomize = [RCIMSettingService shareManager].rightHollowEdgeMessageBubbleCustomize;
        edgeMessageBubbleCustomize = rightEdgeMessageBubbleCustomize;
    } else {
        UIEdgeInsets leftEdgeMessageBubbleCustomize = [RCIMSettingService shareManager].leftHollowEdgeMessageBubbleCustomize;
        edgeMessageBubbleCustomize = leftEdgeMessageBubbleCustomize;
    }
    [self.locationImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.messageContentView).with.insets(edgeMessageBubbleCustomize);
        make.height.equalTo(@(141));
        //make.width.equalTo(@(250));
    }];
    CGFloat offset = 8.f;
    [self.locationAddressOverlay mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.messageContentView.mas_bottom);
        make.left.equalTo(self.messageContentView.mas_left);
        make.right.equalTo(self.messageContentView.mas_right);
        make.height.equalTo(self.locationAddressLabel.mas_height).offset(2*offset);
    }];
    
    [self.locationAddressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.locationAddressOverlay).with.insets(UIEdgeInsetsMake(offset, offset, offset, offset));
    }];
    
    [super setup];
    [self addGeneralView];
    
}

- (void)singleTaplocationImageViewGestureRecognizerHandler:(UITapGestureRecognizer *)tapGestureRecognizer {
    if (tapGestureRecognizer.state == UIGestureRecognizerStateEnded) {
        if ([self.delegate respondsToSelector:@selector(messageCellTappedMessage:)]) {
            [self.delegate messageCellTappedMessage:self];
            [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
        }
    }
}

#pragma mark - Getters

- (UIImageView *)locationImageView {
    if (!_locationImageView) {
        _locationImageView = [[UIImageView alloc] init];
        _locationImageView.contentMode = UIViewContentModeScaleAspectFill;
        _locationImageView.image = ({
            UIImage *image = [UIImage RCIM_imageNamed:@"MessageBubble_Location" bundleName:@"MessageBubble" bundleForClass:[self class]];
            image;
        });
    }
    return _locationImageView;
}

- (UIView *)locationAddressOverlay {
    if (!_locationAddressOverlay) {
        _locationAddressOverlay = [[UIView alloc] init];
        _locationAddressOverlay.backgroundColor = [UIColor colorWithRed:.0f green:.0f blue:.0f alpha:.6f];
        UILabel *progressLabel = [[UILabel alloc] init];
        progressLabel.numberOfLines = 0;
        progressLabel.lineBreakMode = NSLineBreakByWordWrapping;
        progressLabel.font = [UIFont systemFontOfSize:14.0f];
        progressLabel.textColor = [UIColor whiteColor];
        progressLabel.textAlignment = NSTextAlignmentCenter;
        [progressLabel sizeToFit];
        [_locationAddressOverlay addSubview:self.locationAddressLabel = progressLabel];
    }
    return _locationAddressOverlay;
}

#pragma mark -
#pragma mark - LCCKChatMessageCellSubclassing Method

+ (void)load {
    [self registerSubclass];
}

+ (NSString *)classMediaType {
    return RCLocationMessageTypeIdentifier;
}

@end
