//
//  RCCKChatMoreView.h
//  rongchat
//
//  Created by VD on 2017/7/24.
//  Copyright © 2017年 vd. All rights reserved.
//

#import <UIKit/UIKit.h>
static CGFloat const kFunctionViewHeight = 210.0f;
@class RCChatBar;
@interface RCCKChatMoreView : UIView
@property (assign, nonatomic) NSUInteger numberPerLine;
@property (assign, nonatomic) UIEdgeInsets edgeInsets;
@property (weak, nonatomic) RCChatBar *inputViewRef;

@end
