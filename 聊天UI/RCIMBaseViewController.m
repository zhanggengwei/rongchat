//
//  RCIMBaseViewController.m
//  rongchat
//
//  Created by Donald on 16/12/19.
//  Copyright © 2016年 vd. All rights reserved.
//

#import "RCIMBaseViewController.h"

@interface RCIMBaseViewController ()

@property (nonatomic, copy) RCIMBarButtonItemActionBlock barButtonItemAction;

@end

@implementation RCIMBaseViewController
@synthesize viewDidLoadBlock = _viewDidLoadBlock;
@synthesize viewWillAppearBlock = _viewWillAppearBlock;
@synthesize viewDidAppearBlock = _viewDidAppearBlock;
@synthesize viewWillDisappearBlock = _viewWillDisappearBlock;
@synthesize viewDidDisappearBlock = _viewDidDisappearBlock;
@synthesize viewDidDismissBlock = _viewDidDismissBlock;
@synthesize viewControllerWillDeallocBlock = _viewControllerWillDeallocBlock;
@synthesize didReceiveMemoryWarningBlock = _didReceiveMemoryWarningBlock;

#pragma mark -
#pragma mark - UIViewController Life Event Block

- (void)setViewDidLoadBlock:(RCIMViewDidLoadBlock)viewDidLoadBlock {
    _viewDidLoadBlock = viewDidLoadBlock;
}

- (void)setViewWillAppearBlock:(RCIMViewWillAppearBlock)viewWillAppearBlock {
    _viewWillAppearBlock = viewWillAppearBlock;
}

- (void)setViewDidAppearBlock:(RCIMViewDidAppearBlock)viewDidAppearBlock {
    _viewDidAppearBlock = viewDidAppearBlock;
}

- (void)setViewWillDisappearBlock:(RCIMViewWillDisappearBlock)viewWillDisappearBlock {
    _viewWillDisappearBlock = viewWillDisappearBlock;
}

- (void)setViewDidDisappearBlock:(RCIMViewDidDisappearBlock)viewDidDisappearBlock {
    _viewDidDisappearBlock = viewDidDisappearBlock;
}

- (void)setViewDidDismissBlock:(RCIMViewDidDismissBlock)viewDidDismissBlock {
    _viewDidDismissBlock = viewDidDismissBlock;
}


- (void)setViewControllerWillDeallocBlock:(RCIMViewControllerWillDeallocBlock)viewControllerWillDeallocBlock {
    _viewControllerWillDeallocBlock = viewControllerWillDeallocBlock;
}

- (void)setViewDidReceiveMemoryWarningBlock:(RCIMViewDidReceiveMemoryWarningBlock)didReceiveMemoryWarningBlock {
    _didReceiveMemoryWarningBlock = didReceiveMemoryWarningBlock;
}

- (void)clickedBarButtonItemAction:(UIBarButtonItem *)sender event:(UIEvent *)event {
    if (self.barButtonItemAction) {
        self.barButtonItemAction(sender, event);
    }
}

#pragma mark - Public Method

- (void)configureBarButtonItemStyle:(RCIMBarButtonItemStyle)style action:(RCIMBarButtonItemActionBlock)action {
    NSString *icon;
    switch (style) {
        case RCIMBarButtonItemStyleSetting: {
            icon = @"barbuttonicon_set";
            break;
        }
        case RCIMBarButtonItemStyleMore: {
            icon = @"barbuttonicon_more";
            break;
        }
        case RCIMBarButtonItemStyleAdd: {
            icon = @"barbuttonicon_add";
            break;
        }
        case RCIMBarButtonItemStyleAddFriends:
            icon = @"barbuttonicon_addfriends";
            break;
        case RCIMBarButtonItemStyleSingleProfile:
            icon = @"barbuttonicon_InfoSingle";
            break;
        case RCIMBarButtonItemStyleGroupProfile:
            icon = @"barbuttonicon_InfoMulti";
            break;
        case RCIMBarButtonItemStyleShare:
            icon = @"barbuttonicon_Operate";
            break;
    }
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage lcck_imageNamed:icon bundleName:@"BarButtonIcon" bundleForClass:[self class]] style:UIBarButtonItemStylePlain target:self action:@selector(clickedBarButtonItemAction:event:)];
    self.barButtonItemAction = action;
}

#pragma mark - alert and async utils

- (void)alert:(NSString *)message {
//    RCIMShowNotificationBlock showNotificationBlock = [RCIMUIService sharedInstance].showNotificationBlock;
//    !showNotificationBlock ?: showNotificationBlock(self, message, nil, RCIMMessageNotificationTypeError);
}

- (BOOL)alertAVIMError:(NSError *)error {
//    if (error) {
//        if (error.code == kAVIMErrorConnectionLost) {
//            [self alert:@"未能连接聊天服务"];
//        } else if ([error.domain isEqualToString:NSURLErrorDomain]) {
//            [self alert:@"网络连接发生错误"];
//        } else {
//            [self alert:[NSString stringWithFormat:@"%@", error]];
//        }
//        return YES;
//    }
    return NO;
}

- (BOOL)filterAVIMError:(NSError *)error {
    return [self alertAVIMError:error] == NO;
}

@end
