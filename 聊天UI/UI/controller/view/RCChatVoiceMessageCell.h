//
//  RCChatVoiceMessageCell.h
//  rongchat
//
//  Created by VD on 2017/7/7.
//  Copyright © 2017年 vd. All rights reserved.
//

#import "RCChatBaseMessageCell.h"

@interface RCChatVoiceMessageCell : RCChatBaseMessageCell<RCChatMessageCellSubclassing>
@property (nonatomic, assign) RCVoiceMessageState voiceMessageState;
@end
