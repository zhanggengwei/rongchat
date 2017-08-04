//
//  RCIMBaseConversationViewController.h
//  rongchat
//
//  Created by VD on 2017/8/4.
//  Copyright © 2017年 vd. All rights reserved.
//

#import "RCIMBaseTableViewController.h"
@class RCChatBar, RCIMConversationViewModel;

@interface RCIMBaseConversationViewController : RCIMBaseTableViewController
@property (nonatomic, assign) BOOL loadingMoreMessage;
@property (nonatomic, weak) RCChatBar *chatBar;
@property (nonatomic, assign) BOOL shouldLoadMoreMessagesScrollToTop;
/*!
 * 发送消息时，会置YES
 * 输入框高度变更，比如输入文字换行、切换到 More、Face 页面、键盘弹出、键盘收缩
 */
@property (nonatomic, assign) BOOL allowScrollToBottom;
//somewhere in the header
@property (nonatomic, assign) CGFloat tableViewLastContentOffset;

/**
 *  是否滚动到底部
 *
 *  @param animated YES Or NO
 */
- (void)scrollToBottomAnimated:(BOOL)animated;

- (void)loadMoreMessagesScrollTotop;
/**
 *  判断是否用户手指滚动
 */
@property (nonatomic, assign) BOOL isUserScrolling;

@end
