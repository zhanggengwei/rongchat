//
//  RCChatImageMessageCell.h
//  rongchat
//
//  Created by VD on 2017/7/7.
//  Copyright © 2017年 vd. All rights reserved.
//

#import "RCChatBaseMessageCell.h"

@interface RCChatImageMessageCell : RCChatBaseMessageCell<RCChatMessageCellSubclassing>
@property (nonatomic, strong, readonly) UIImageView *messageImageView;

- (void)setUploadProgress:(CGFloat)uploadProgress;

@end
