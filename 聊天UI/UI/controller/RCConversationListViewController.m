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
#import "UIImage+RCIMExtension.h"
#import <PopoverView.h>
#import "RCIMSelectContactsViewController.h"


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
    UIImage * rightImage = [UIImage RCIM_imageNamed:@"barbuttonicon_add" bundleName:@"BarButtonIcon" bundleForClass:[self class]];
    UIButton * moreButton = [UIButton buttonWithType:UIButtonTypeCustom];
    moreButton.frame = CGRectMake(0, 0,30, 30);
    [moreButton setBackgroundImage:rightImage forState:UIControlStateNormal];
    [moreButton addTarget:self action:@selector(showSheetView:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:moreButton];
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

- (void)showSheetView:(id)sender
{
    UIImage * image = [UIImage RCIM_imageNamed:@"barbuttonicon_InfoSingle" bundleName:@"BarButtonIcon" bundleForClass:[self class]];
    PopoverAction * action1 = [PopoverAction actionWithImage:image title:@"发起群聊" handler:^(PopoverAction *action) {
        RCIMSelectContactsViewController * controller =[RCIMSelectContactsViewController new];
        [self presentViewController:[[UINavigationController alloc]initWithRootViewController:controller] animated:YES completion:nil];
    }];
    PopoverAction * action2 = [PopoverAction actionWithImage:image title:@"添加朋友" handler:^(PopoverAction *action) {
        
    }];
    
    PopoverAction * action3 = [PopoverAction actionWithImage:image title:@"扫一扫" handler:^(PopoverAction *action) {
        
    }];
    
    PopoverAction * action4 = [PopoverAction actionWithImage:image title:@"收付款" handler:^(PopoverAction *action) {
        
    }];
    PopoverView *popoverView = [PopoverView popoverView];
    popoverView.style = PopoverViewStyleDark;
    [popoverView showToView:sender withActions:@[action1,action2,action3,action4]];
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
    NSLog(@"conversation.count==%d",[[RCIMClient sharedRCIMClient]getTotalUnreadCount]);
    
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
    cell.conversation = conversation;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    RCConversation * conversation= self.dataSource[indexPath.row];
    RCIMConversationViewController * conversationController = [RCIMConversationViewController new];
    conversationController.conversation = conversation;
    [self.navigationController pushViewController:conversationController animated:YES];
    self.needRefresh = NO;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55;
}
- (void)dealloc
{
    NSLog(@"dealloc %@",[self class]);
}
@end
