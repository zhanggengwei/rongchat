
//
//  RCIMStatusView.m
//  rongchat
//
//  Created by vd on 2016/12/19.
//  Copyright © 2016年 vd. All rights reserved.
//
static CGFloat RCIMStatusImageViewHeight = 20;
static CGFloat RCIMHorizontalSpacing = 15;
static CGFloat RCIMHorizontalLittleSpacing = 5;
#import "RCIMStatusView.h"
#import "UIImage+RCIMExtension.h"


@interface RCIMStatusView ()
@property (nonatomic,strong) UILabel * statusLabel;
@property (nonatomic,strong) UIImageView * statusImageView;


@end

@implementation RCIMStatusView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        [self setup];
    }
    return self;
}

- (void)setup
{
    self.backgroundColor = [UIColor colorWithRed:255 / 255.0 green:199 / 255.0 blue:199 / 255.0 alpha:1];
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [self addSubview:self.statusLabel];
    [self addSubview:self.statusImageView];
}


- (UIImageView *)statusImageView
{
    if (_statusImageView == nil) {
        _statusImageView = [[UIImageView alloc] initWithFrame:CGRectMake(RCIMHorizontalSpacing, (RCIMStatusViewHight - RCIMStatusImageViewHeight) / 2, RCIMStatusImageViewHeight, RCIMStatusImageViewHeight)];
        _statusImageView.image =  ({
            NSString *imageName = @"MessageSendFail";
            UIImage *image = [UIImage RCIM_imageNamed:imageName bundleName:@"MessageBubble" bundleForClass:[self class]];
            image;});
    }
    return _statusImageView;
}
- (UILabel *)statusLabel {
    if (_statusLabel == nil) {
        _statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_statusImageView.frame) + RCIMHorizontalLittleSpacing, 0, self.frame.size.width - CGRectGetMaxX(_statusImageView.frame) - RCIMHorizontalSpacing - RCIMHorizontalLittleSpacing, RCIMStatusViewHight)];
        _statusLabel.font = [UIFont systemFontOfSize:15.0];
        _statusLabel.textColor = [UIColor grayColor];
//        _statusLabel.text = RCLocalizedStrings(@"netDisconnected");
    }
    return _statusLabel;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if([self.delegate respondsToSelector:@selector(statusViewClicked:)])
    {
        [self.delegate statusViewClicked:self];
        
    }
}

@end
