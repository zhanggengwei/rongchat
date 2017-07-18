//
//  RCMessageSendStateView.h
//  rongchat
//
//  Created by VD on 2017/7/6.
//  Copyright © 2017年 vd. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol RCSendImageViewDelegate <NSObject>
@required
- (void)resendMessage:(id)sender;
@end

@interface RCMessageSendStateView : UIButton

@property (nonatomic, assign) RCSentStatus messageSendState;
@property (nonatomic, weak) id<RCSendImageViewDelegate> delegate;
@end
