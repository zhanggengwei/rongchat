//
//  RCConversationListViewController.m
//  rongchat
//
//  Created by Donald on 16/12/6.
//  Copyright © 2016年 vd. All rights reserved.
//

#import "RCConversationListViewController.h"
#import "PPViewUtil.h"
#import "PPListItemViewController.h"
#import "PPListItem.h"
#import "RCIMMessageManager.h"
#import "RCIMConversationViewController.h"
#import "RCConversationListCell.h"
@interface RCConversationListViewController ()
@property (nonatomic,assign) BOOL needRefresh;//是否刷新界面
@property (nonatomic,assign) BOOL receiveNewMessages;//收到信的消息
@end

@implementation RCConversationListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.needRefresh = YES;
    self.conversationTypeArr = @[@(ConversationType_PRIVATE),@(ConversationType_GROUP)];
    [self.tableView registerClass:[RCConversationListCell class] forCellReuseIdentifier:@"RCConversationListCell"];
    [self reloadConversationList];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(receiveNewMessages:) name:RCDidReceiveMessagesDidChanged object:nil];
    
    
    
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if(self.receiveNewMessages&&self.needRefresh==NO)
    {
        self.needRefresh = YES;
        [self.tableView reloadData];
    }
    self.needRefresh = YES;
    self.receiveNewMessages = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)reloadConversationList
{
    [[RCIMMessageManager shareManager]queryLastConversationListWithConversationTypeArray:self.conversationTypeArr WithHandle:^(NSArray<RCConversation *> *conversationList, NSError *error) {
        [self.dataSource removeAllObjects];
        [self.dataSource addObjectsFromArray:conversationList];
        if(self.needRefresh)
        {
            [self.tableView reloadData];
        }
    }];
}

- (void)receiveNewMessages:(NSNotification *)noti
{
    [self reloadConversationList];
    self.receiveNewMessages = YES;
}

#pragma mark UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return  1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RCConversationListCell * cell = [tableView dequeueReusableCellWithIdentifier:@"RCConversationListCell"];
    RCConversation * conversation= self.dataSource[indexPath.row];
    [cell setConversation:conversation avatarStyle:0];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    RCConversation * conversation= self.dataSource[indexPath.row];
    RCIMConversationViewController * conversationController = [RCIMConversationViewController new];
    conversationController.conversation = conversation;
    [conversationController setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:conversationController animated:YES];
    self.needRefresh = NO;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

@end
