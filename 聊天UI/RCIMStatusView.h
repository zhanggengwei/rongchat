//
//  RCIMStatusView.h
//  rongchat
//
//  Created by vd on 2016/12/19.
//  Copyright © 2016年 vd. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RCIMStatusViewDelegate <NSObject>

@optional
- (void)statusViewClicked:(id)sender;

@end

static const CGFloat LCCKStatusViewHight = 44.0;

@interface RCIMStatusView : UIView
@property (nonatomic, weak) id<RCIMStatusViewDelegate> delegate;
@end
