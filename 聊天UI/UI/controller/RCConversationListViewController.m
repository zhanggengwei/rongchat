//
//  RCConversationListViewController.m
//  rongchat
//
//  Created by Donald on 16/12/6.
//  Copyright © 2016年 vd. All rights reserved.
//

#import "RCConversationListViewController.h"
#import "PPViewUtil.h"
#import "RCIM.h"
#import "PPListItemViewController.h"
#import "PPListItem.h"
#import "RCConversationViewController.h"
#import "RCConversationListCell.h"
@interface RCConversationListViewController ()<RCIMConnectionStatusDelegate,UITableViewDelegate,UITableViewDataSource,RCIMReceiveMessageDelegate>
@property (nonatomic,strong) UIActivityIndicatorView * activityView;
@property (nonatomic,strong) UILabel * titleLabel;
@property (nonatomic,strong) NSMutableArray * conversationList;
@property (nonatomic,strong) UITableView * tableView;
@property (nonatomic,strong) UIViewController * showListController;
@property (nonatomic,strong) UIBarButtonItem * rightItem;

@end

@implementation RCConversationListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.rightItem = [[UIBarButtonItem alloc]initWithTitle:@"show" style:UIBarButtonItemStylePlain target:self action:@selector(show)];
    self.navigationItem.rightBarButtonItem = self.rightItem;
    
    self.titleFont = [UIFont systemFontOfSize:17];
    [[RCIM sharedRCIM] setConnectionStatusDelegate:self];
    [[RCIM sharedRCIM] setReceiveMessageDelegate:self];
    if(self.conversationTypeArray==nil || self.conversationTypeArray.count ==0)
    {
        self.conversationTypeArray = @[@(ConversationType_PRIVATE)];
        
    }
    self.conversationList = [NSMutableArray arrayWithArray:[[RCIMClient sharedRCIMClient] getConversationList:self.conversationTypeArray]];
    self.tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    [self.view addSubview:self.tableView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [UIView new];
    
    [self.tableView registerClass:[RCConversationListCell class] forCellReuseIdentifier:@"RCConversationListCell"];
    
    //QbHpsQOXn
    
    // Do any additional setup after loading the view.
}
- (void)show
{
    PPListItem * item1 = [[PPListItem alloc]init];
    item1.content  = @"#";
    PPListItem * item2 = [[PPListItem alloc]init];
    item2.content  = @"#@";
    
    PPListItemViewController * controller = [[PPListItemViewController alloc]initWithItems:@[item1,item2]];
    controller.itemWidth = 100;
    controller.itemHeight = 40;
    controller.alphaComponent = 0;
    controller.p_showViewController = self;
    
    
    [controller show];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)onRCIMConnectionStatusChanged:(RCConnectionStatus)status
{
    
    switch (status)
    {
        case ConnectionStatus_Connected:
        {
            [self hideIndictorView:@"微信"];
            break;
        }
        case ConnectionStatus_Connecting:
        {
            [self setTitle:@"连接中"];
            break;
        }
        case ConnectionStatus_SERVER_INVALID:
        {
            [self hideIndictorView:@"服务器异常"];
            break;
        }
        case ConnectionStatus_Unconnected:
        {
            [self hideIndictorView:@"未连接"];
            break;
        }
        default:
            break;
    }
}

- (void)hideIndictorView:(NSString *)message
{
    self.activityView.hidden = YES;
    [self.activityView stopAnimating];
    //[self setTitle:message];
    [self.titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.navigationItem.titleView.mas_centerX);
    }];
    
    
}


- (void)p_createNavBarTitleView
{
    self.navigationItem.titleView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 100, 40)];
    self.titleLabel = [UILabel new];
    [self.navigationItem.titleView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(0);
        make.centerX.mas_equalTo(self.navigationItem.titleView.mas_centerX).mas_offset(22);
        make.top.mas_equalTo(self.navigationItem.titleView.mas_top);
        make.bottom.mas_equalTo(self.navigationItem.titleView.mas_bottom);
    }];
    self.titleLabel.text = @"未连接";
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.activityView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    [self.navigationItem.titleView addSubview:self.activityView];
    [self.activityView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.navigationItem.titleView.mas_top);
        make.right.mas_equalTo(self.titleLabel.mas_left);
        make.width.mas_equalTo(44);
        make.height.mas_equalTo(44);
    }];
    [self.activityView startAnimating];
    self.titleLabel.textColor = [UINavigationBar appearance].barTintColor;
    
}
- (void)setTitle:(NSString *)title
{
    if(self.title==nil)
    {
        [self p_createNavBarTitleView];
    }
    else if (title==nil)
    {
        return;
    }
    if(self.titleFont==nil)
    {
        self.titleFont = [UIFont systemFontOfSize:17];
    }
    
    UIColor * tintColor =[self.navigationController.navigationBar barTintColor];
    if(tintColor==nil)
    {
        // tintColor = [UIColor blackColor];
    }
    self.titleLabel.textColor = kPPTFontColorWhite;
    self.titleLabel.text = title;
    
    CGSize size = [PPViewUtil sizeWithString:title font:self.titleFont constrainedToSize:CGSizeMake(SCREEN_WIDTH - 100, 44) lineBreakMode:NSLineBreakByWordWrapping];
    
    [self.titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(size.width);
    }];
}


#pragma mark UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return  1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.conversationList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RCConversationListCell * cell = [tableView dequeueReusableCellWithIdentifier:@"RCConversationListCell"];
    RCConversation * conversation= self.conversationList[indexPath.row];
    [cell setConversation:conversation avatarStyle:0];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    RCConversation * conversation= self.conversationList[indexPath.row];
    RCConversationViewController * conversationController = [[RCConversationViewController alloc]initWithTargetId:conversation.targetId conversationType:conversation.conversationType];
    [conversationController setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:conversationController animated:YES];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
- (void)onRCIMReceiveMessage:(RCMessage *)message left:(int)left
{
    if (left<=0) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.conversationList = [NSMutableArray arrayWithArray:[[RCIMClient sharedRCIMClient] getConversationList:self.conversationTypeArray]];
            [self.tableView reloadData];
        });
    }
}
@end
