//
//  RCIMConversationListViewModel.h
//  rongchat
//
//  Created by Donald on 16/12/20.
//  Copyright © 2016年 vd. All rights reserved.
//

#import <Foundation/Foundation.h>
@class RCConversationListViewController;
@class RCConversation;
@class RCConversationModel;

@interface RCIMConversationListViewModel : NSObject<UITabBarDelegate,UITableViewDataSource>
- (instancetype)initWithConversationListViewController:(RCConversationListViewController *)conversationListViewController;

@property (nonatomic, strong) NSMutableArray<RCConversation *> *dataArray;

- (void)refresh;

@end
