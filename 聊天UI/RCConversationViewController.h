//
//  RCConversationViewController.h
//  rongchat
//
//  Created by Donald on 16/12/6.
//  Copyright © 2016年 vd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RCConversationViewController : UIViewController
- (instancetype)initWithTargetId:(NSString *)targetId conversationType:(RCConversationType)conversationType;

@end
