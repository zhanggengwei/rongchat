
//
//  RCIMContactGroupDetilsViewController.m
//  rongchat
//
//  Created by VD on 2017/9/2.
//  Copyright © 2017年 vd. All rights reserved.
//

#import "RCIMContactGroupDetilsViewController.h"
#import "RCIMCustomTableViewCell.h"
#import "RCIMMemberView.h"
#import "PPImageUtil.h"

@interface RCIMContactGroupDetilsViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView * tableView;
@property (nonatomic,strong) NSArray * data;
@property (nonatomic,strong) RCIMMemberView * memberListView;
@property (nonatomic,strong) NSArray * members;
@end

@implementation RCIMContactGroupDetilsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"聊天信息";
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    [self loadData];
    [self loadMemberList];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (RCIMMemberView *)memberListView
{
    if(_memberListView==nil)
    {
        _memberListView = [RCIMMemberView new];
    }
    return _memberListView;
}

- (void)loadMemberList
{
    RCIMContactGroupMemberModel * model1 = [RCIMContactGroupMemberModel new];
    model1.userInfo = [PPTUserInfoEngine shareEngine].user_Info;
    RCIMContactGroupMemberModel * model2 = [RCIMContactGroupMemberModel new];
    model2.userInfo = [PPTUserInfoEngine shareEngine].user_Info;
    RCIMContactGroupMemberModel * model3 = [RCIMContactGroupMemberModel new];
    model3.userInfo = [PPTUserInfoEngine shareEngine].user_Info;
    RCIMContactGroupMemberModel * model4 = [RCIMContactGroupMemberModel new];
    model4.userInfo = [PPTUserInfoEngine shareEngine].user_Info;
    RCIMContactGroupMemberModel * model5 = [RCIMContactGroupMemberModel new];
    model5.userInfo = [PPTUserInfoEngine shareEngine].user_Info;
    self.members = @[model1,model2,model3,model4,model5];
    self.memberListView.dataSource = self.members;
    
    
}

- (void)loadData
{
    RCIMCellCustomItem * item11 = [RCIMCellCustomItem new];
    item11.title = @"群聊名称";
    item11.detail = @"未命名";
    
    
    RCIMCellIconItem * item12 = [RCIMCellIconItem new];
    item12.title = @"群聊二维码";
    item12.imageName = @"未命名";
    
    RCIMCellCustomItem * item13 = [RCIMCellCustomItem new];
    item13.title = @"群公告";
    item13.detail = @"未设置";
    
    RCIMCellCustomItem * item14 = [RCIMCellCustomItem new];
    item14.title = @"群管理";
    item14.detail = @"";
    
    
    
    RCIMCellSwitchItem * item21= [RCIMCellSwitchItem new];
    item21.title = @"消息免打扰";
    
    RCIMCellSwitchItem * item22= [RCIMCellSwitchItem new];
    item22.title = @"置顶聊天";
    RCIMCellSwitchItem * item23= [RCIMCellSwitchItem new];
    item23.title = @"保存到通讯录";
    
    
    RCIMCellCustomItem * item31 = [RCIMCellCustomItem new];
    item31.title = @"设置聊天背景";
    item31.detail = @"";
    
    
    RCIMCellCustomItem * item32 = [RCIMCellCustomItem new];
    item32.title = @"投诉";
    item32.detail = @"";
    
    RCIMCellCustomItem * item41 = [RCIMCellCustomItem new];
    item41.title = @"清空聊天记录";
    
    self.data = @[@[item11,item12,item13],@[item21,item22,item23],@[item31,item32],@[item41]];
    [self.tableView reloadData];
}

- (UITableView *)tableView
{
    if(_tableView==nil)
    {
        _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        [_tableView registerClass:[RCIMCustomTableViewCell class] forCellReuseIdentifier:NSStringFromClass([RCIMCustomTableViewCell class])];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[RCIMSwithcTableViewCell class] forCellReuseIdentifier:NSStringFromClass([RCIMSwithcTableViewCell class])];
        [_tableView registerClass:[RCIMIconTableViewCell class] forCellReuseIdentifier:NSStringFromClass([RCIMIconTableViewCell class])];
        _tableView.backgroundColor = kMainBackGroundColor;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
    }
    return _tableView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.data.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.data[section] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}

-  (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RCIMCellItem * item = self.data[indexPath.section][indexPath.row];
    NSString * cellClass = nil;
    if([item isKindOfClass:[RCIMCellIconItem class]])
    {
        cellClass = NSStringFromClass([RCIMIconTableViewCell class]);
    }else if ([item isKindOfClass:[RCIMCellSwitchItem class]])
    {
        cellClass =NSStringFromClass([RCIMSwithcTableViewCell class]);
    }else
    {
        cellClass = NSStringFromClass([RCIMCustomTableViewCell class]);
    }
    RCIMTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellClass];
    cell.tableView = tableView;
    cell.indexPath = indexPath;
    cell.model = item;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section==0)
    {
        return [self.memberListView.class contentViewHeight:self.members.count];
    }
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if(section==self.data.count-1)
    {
        return 85;
    }
    return 20;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if(section==0)
    {
        return self.memberListView;
    }
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if(section==self.data.count-1)
    {
        UIView * footerView = [UIView new];
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.layer.cornerRadius = 5;
        button.layer.masksToBounds = YES;
        [footerView addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(footerView).insets(UIEdgeInsetsMake(20, 20, 20, 20));
        }];
        [button setBackgroundImage:[PPImageUtil imageFromColor:[UIColor redColor]]forState:UIControlStateNormal];
        [[button rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(__kindof UIControl * _Nullable x) {
            
        }];
        [button setTitle:@"删除并退出" forState:UIControlStateNormal];
        return footerView;
    }
    return nil;
}


@end
