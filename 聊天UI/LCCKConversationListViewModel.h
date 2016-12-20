//
//  LCCKConversationListViewModel.h
//  rongchat
//
//  Created by Donald on 16/12/20.
//  Copyright © 2016年 vd. All rights reserved.
//

#import <Foundation/Foundation.h>
@class RCConversationListViewController;
@class RCConversation;
@class RCConversationModel;

@interface LCCKConversationListViewModel : NSObject<UITabBarDelegate,UITableViewDataSource>
- (instancetype)initWithConversationListViewController:(RCConversationListViewController *)conversationListViewController;

@property (nonatomic, strong) NSMutableArray<RCConversationModel *> *dataArray;

- (void)refresh;

@end
