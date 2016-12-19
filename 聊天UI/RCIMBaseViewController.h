//
//  RCIMBaseViewController.h
//  rongchat
//
//  Created by Donald on 16/12/19.
//  Copyright © 2016年 vd. All rights reserved.
//



@import UIKit;
@class RCIMBaseViewController;
@protocol RCIMViewControllerEventProtocol <NSObject>

/**
 *  页面需要透出的通用事件，例如viewDidLoad，viewWillAppear，viewDidAppear等
 */
typedef void(^RCIMViewDidLoadBlock)(__kindof RCIMBaseViewController *viewController);
typedef void(^RCIMViewWillAppearBlock)(__kindof RCIMBaseViewController *viewController, BOOL aAnimated);
typedef void(^RCIMViewDidAppearBlock)(__kindof RCIMBaseViewController *viewController, BOOL aAnimated);
typedef void(^RCIMViewWillDisappearBlock)(__kindof RCIMBaseViewController *viewController, BOOL aAnimated);
typedef void(^RCIMViewDidDisappearBlock)(__kindof RCIMBaseViewController *viewController, BOOL aAnimated);
typedef void(^RCIMViewDidDismissBlock)(__kindof RCIMBaseViewController *viewController);
typedef void(^RCIMViewControllerWillDeallocBlock) (__kindof RCIMBaseViewController *viewController);
typedef void(^RCIMViewDidReceiveMemoryWarningBlock)(__kindof RCIMBaseViewController *viewController);

@property (nonatomic, copy) RCIMViewDidLoadBlock viewDidLoadBlock;
@property (nonatomic, copy) RCIMViewWillAppearBlock viewWillAppearBlock;
@property (nonatomic, copy) RCIMViewDidAppearBlock viewDidAppearBlock;
@property (nonatomic, copy) RCIMViewWillDisappearBlock viewWillDisappearBlock;
@property (nonatomic, copy) RCIMViewDidDisappearBlock viewDidDisappearBlock;
@property (nonatomic, copy) RCIMViewDidDismissBlock viewDidDismissBlock;
@property (nonatomic, copy) RCIMViewControllerWillDeallocBlock viewControllerWillDeallocBlock;
@property (nonatomic, copy) RCIMViewDidReceiveMemoryWarningBlock didReceiveMemoryWarningBlock;

/**
 *  View的相关事件调出
 */
- (void)setViewDidLoadBlock:(RCIMViewDidLoadBlock)viewDidLoadBlock;
- (void)setViewWillAppearBlock:(RCIMViewWillAppearBlock)viewWillAppearBlock;
- (void)setViewDidAppearBlock:(RCIMViewDidAppearBlock)viewDidAppearBlock;
- (void)setViewWillDisappearBlock:(RCIMViewWillDisappearBlock)viewWillDisappearBlock;
- (void)setViewDidDisappearBlock:(RCIMViewDidDisappearBlock)viewDidDisappearBlock;
- (void)setViewDidDismissBlock:(RCIMViewDidDismissBlock)viewDidDismissBlock;
- (void)setViewControllerWillDeallocBlock:(RCIMViewControllerWillDeallocBlock)viewControllerWillDeallocBlock;
- (void)setViewDidReceiveMemoryWarningBlock:(RCIMViewDidReceiveMemoryWarningBlock)didReceiveMemoryWarningBlock;

@end

typedef void(^RCIMBarButtonItemActionBlock)(UIBarButtonItem *sender, UIEvent *event);

typedef NS_ENUM(NSInteger, RCIMBarButtonItemStyle) {
    RCIMBarButtonItemStyleSetting = 0,
    RCIMBarButtonItemStyleMore,
    RCIMBarButtonItemStyleAdd,
    RCIMBarButtonItemStyleAddFriends,
    RCIMBarButtonItemStyleShare,
    RCIMBarButtonItemStyleSingleProfile,
    RCIMBarButtonItemStyleGroupProfile,
};

@interface RCIMBaseViewController : UIViewController <RCIMViewControllerEventProtocol>

- (void)configureBarButtonItemStyle:(RCIMBarButtonItemStyle)style action:(RCIMBarButtonItemActionBlock)action;

- (void)alert:(NSString *)message;

- (BOOL)alertAVIMError:(NSError *)error;

- (BOOL)filterAVIMError:(NSError *)error;

@end

