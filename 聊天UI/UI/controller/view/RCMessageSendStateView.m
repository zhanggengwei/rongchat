//
//  RCMessageSendStateView.m
//  rongchat
//
//  Created by VD on 2017/7/6.
//  Copyright © 2017年 vd. All rights reserved.
//

#import "RCMessageSendStateView.h"
#import "UIImage+RCIMExtension.h"
#import "RCIMDeallocBlockExecutor.h"

static void * const LCCKSendImageViewShouldShowIndicatorViewContext = (void*)&LCCKSendImageViewShouldShowIndicatorViewContext;

@interface RCMessageSendStateView ()

@property (nonatomic, weak) UIActivityIndicatorView *indicatorView;
@property (nonatomic, assign, getter=shouldShowIndicatorView) BOOL showIndicatorView;

@end

@implementation RCMessageSendStateView

- (instancetype)init {
    if (self = [super init]) {
        UIActivityIndicatorView *indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        indicatorView.hidden = YES;
        [self addSubview:self.indicatorView = indicatorView];
        // KVO注册监听
        [self addObserver:self forKeyPath:@"showIndicatorView" options:NSKeyValueObservingOptionNew context:LCCKSendImageViewShouldShowIndicatorViewContext];
        __unsafe_unretained __typeof(self) weakSelf = self;
        [self lcck_executeAtDealloc:^{
            [weakSelf removeObserver:weakSelf forKeyPath:@"showIndicatorView"];
        }];
        [self addTarget:self action:@selector(failImageViewTap:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return self;
}

- (void)showErrorIcon:(BOOL)showErrorIcon {
    if (showErrorIcon) {
        NSString *imageName = @"MessageSendFail";
        UIImage *image = [UIImage lcck_imageNamed:imageName bundleName:@"MessageBubble" bundleForClass:[self class]];
        [self setImage:image forState:UIControlStateNormal];
    } else {
        [self setImage:nil forState:UIControlStateNormal];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.indicatorView.frame = self.bounds;
}

#pragma mark - Setters
- (void)setMessageSendState:(RCSentStatus)messageSendState {
    _messageSendState = messageSendState;
    if (_messageSendState == SentStatus_SENDING) {
        
        dispatch_async(dispatch_get_main_queue(),^{
            [self.indicatorView startAnimating];
        });
        self.showIndicatorView = YES;
    } else {
        dispatch_async(dispatch_get_main_queue(),^{
            [self.indicatorView stopAnimating];
        });
        self.showIndicatorView = NO;
    }
    
    switch (_messageSendState) {
        case SentStatus_SENDING:
            self.showIndicatorView = YES;
            break;
            
        case SentStatus_FAILED:
            self.showIndicatorView = NO;
            break;
        default:
            self.hidden = YES;
            break;
    }
}



// KVO监听执行
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if(context != LCCKSendImageViewShouldShowIndicatorViewContext) {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        return;
    }
    if(context == LCCKSendImageViewShouldShowIndicatorViewContext) {
        if ([keyPath isEqualToString:@"showIndicatorView"]) {
            id newKey = change[NSKeyValueChangeNewKey];
            BOOL showIndicatorView = [newKey boolValue];
            if (showIndicatorView) {
                self.hidden = NO;
                self.indicatorView.hidden = NO;
                [self showErrorIcon:NO];
            } else {
                self.hidden = NO;
                self.indicatorView.hidden = YES;
                [self showErrorIcon:YES];
            }
        }
    }
}

- (void)failImageViewTap:(id)sender {
    if (self.shouldShowIndicatorView) {
        return;
    }
    if ([self.delegate respondsToSelector:@selector(resendMessage:)]) {
        [self.delegate resendMessage:self];
    }
}
@end
