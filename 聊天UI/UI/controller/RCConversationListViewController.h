//
//  RCConversationListViewController.h
//  rongchat
//
//  Created by Donald on 16/12/6.
//  Copyright © 2016年 vd. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RCConversationListCell;

@interface RCConversationListViewController : UIViewController

@property (nonatomic,strong) UIFont * titleFont;//default is 15

@property (nonatomic,strong) NSArray * conversationTypeArray;

@property (nonatomic,strong) UIImage * rightImage;

@property (nonatomic,assign) CGFloat avaturWidth;//default 36

@property (nonatomic,assign) CGFloat  cellHeight;//default 50

@property (nonatomic,assign) RCUserAvatarStyle avatarStyle;//default RCUserAvatarStyleSquare






@end
