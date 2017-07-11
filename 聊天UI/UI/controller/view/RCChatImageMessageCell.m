//
//  RCChatImageMessageCell.m
//  rongchat
//
//  Created by VD on 2017/7/7.
//  Copyright © 2017年 vd. All rights reserved.
//

#import "RCChatImageMessageCell.h"
#import "UIImage+RCIMExtension.h"

@interface RCChatImageMessageCell ()

@property (nonatomic,strong) UIImageView * messageImageView;
@property (nonatomic,strong) UIView * messageProgressView;
@property (nonatomic,strong) UILabel * messageProgressLabel;


@end

@implementation RCChatImageMessageCell

- (void)setup
{
    [self.messageContentView addSubview:self.messageImageView];
    [self.messageContentView addSubview:self.messageProgressView];
    UIEdgeInsets edgeMessageBubbleCustomize;
    if (self.messageOwner == MessageDirection_SEND) {
        UIEdgeInsets rightEdgeMessageBubbleCustomize = [RCIMSettingService shareManager].rightHollowEdgeMessageBubbleCustomize;
        edgeMessageBubbleCustomize = rightEdgeMessageBubbleCustomize;
    } else {
        UIEdgeInsets leftEdgeMessageBubbleCustomize = [RCIMSettingService shareManager].leftHollowEdgeMessageBubbleCustomize;
        edgeMessageBubbleCustomize = leftEdgeMessageBubbleCustomize;
        
    }
    [self.messageImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.messageContentView).with.insets(edgeMessageBubbleCustomize);
        make.height.lessThanOrEqualTo(@200).priorityHigh();
    }];
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapMessageImageViewGestureRecognizerHandler:)];
    [self.messageContentView addGestureRecognizer:recognizer];
    [super setup];
    [self addGeneralView];
}
- (void)singleTapMessageImageViewGestureRecognizerHandler:(UITapGestureRecognizer *)tapGestureRecognizer {
    if (tapGestureRecognizer.state == UIGestureRecognizerStateEnded) {
        if ([self.delegate respondsToSelector:@selector(messageCellTappedMessage:)]) {
            [self.delegate messageCellTappedMessage:self];
        }
    }
}

- (void)configureCellWithData:(RCMessage *)message
{
    [super configureCellWithData:message];
    RCImageMessage * model = (RCImageMessage *)message.content;
    UIImage *thumbnailPhoto = model.thumbnailImage;
    NSLog(@"model.exra ==%@",NSStringFromCGSize(model.thumbnailImage.size));
    
    do {
        if (self.messageImageView.image && (self.messageImageView.image == model.thumbnailImage)) {
            break;
        }
        if (thumbnailPhoto) {
            self.messageImageView.image = thumbnailPhoto;
            break;
        }
        NSString *imageLocalPath = model.imageUrl;
        BOOL isLocalPath = ![imageLocalPath hasPrefix:@"http"];
        //note: this will ignore contentMode.
        if (imageLocalPath && isLocalPath) {
            NSData *imageData = [NSData dataWithContentsOfFile:imageLocalPath];
            UIImage *image = [UIImage imageWithData:imageData];
            UIImage *resizedImage = [image lcck_imageByScalingAspectFill];
            self.messageImageView.image = resizedImage;
            model.originalImage = image;
            model.thumbnailImage = resizedImage;
            break;
        }
        
        // requied!
        if (model.imageUrl) {
            [self.messageImageView  sd_setImageWithURL:[NSURL URLWithString:model.imageUrl] placeholderImage:[self imageInBundleForImageName:@"Placeholder_Image"]
                                             completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                                 dispatch_async(dispatch_get_main_queue(),^{
                                                     if (image){
                                                         model.originalImage = image;
                                                         model.thumbnailImage = [image lcck_imageByScalingAspectFill];
                                                         if ([self.delegate respondsToSelector:@selector(fileMessageDidDownload:)]) {
                                                             [self.delegate fileMessageDidDownload:self];
                                                         }
                                                     }
                                                 });
                                                 
                                             }
             ];
            break;
        }
        
    } while (NO);
}
- (UIImage *)imageInBundleForImageName:(NSString *)imageName {
    return ({
        UIImage *image = [UIImage lcck_imageNamed:imageName bundleName:@"Placeholder" bundleForClass:[self class]];
        image;});
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

#pragma mark -
#pragma mark - LCCKChatMessageCellSubclassing Method

+ (void)load {
    [self registerSubclass];
}

+ (NSString *)classMediaType {
    return RCImageMessageTypeIdentifier;
}

@end
