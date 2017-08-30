//
//  RCIMContactDetailsViewController.h
//  rongchat
//
//  Created by VD on 2017/8/30.
//  Copyright © 2017年 vd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RCIMContactDetailsViewController : UIViewController

+ (instancetype)createViewController;

@property (nonatomic,weak) RCUserInfoData * userInfo;

@end
