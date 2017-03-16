//
//  RCConversationViewController.h
//  rongchat
//
//  Created by Donald on 16/12/6.
//  Copyright © 2016年 vd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RCConversationViewController : UIViewController

@property (nonatomic,strong) NSArray * messageArrayType;//default 文字信息


- (instancetype)initWithTargetId:(NSString *)targetId conversationType:(RCConversationType)conversationType;

@end
