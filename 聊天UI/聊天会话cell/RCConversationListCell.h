//
//  RCConversationListCell.h
//  rongchat
//
//  Created by vd on 2016/12/18.
//  Copyright © 2016年 vd. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface RCConversationListCell : UITableViewCell

@property (nonatomic,assign) CGFloat avatarSizeWidth;

- (void)setConversation:(RCConversation *)conversation avatarStyle:(RCUserAvatarStyle)style;


@end
