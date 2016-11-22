//
//  PPInfoMessageViewController.m
//  rongChatDemo1
//
//  Created by Donald on 16/11/7.
//  Copyright © 2016年 vd. All rights reserved.
//
NSArray * titleArr ()
{
    return @[@[@"头像",@"名字",@"微信号",@"我的二维码",@"我的地址"],@[@"性别",@"地区",@"个性签名"]];
    
}


#import "PPInfoMessageViewController.h"
#import "PPInfoMessageCell.h"
#import "PPSettingCell.h"
#import "PPShowSelectIconViewController.h"
#import "PPSelectAreaViewController.h"

@interface PPInfoMessageViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView * tableView;

@end

@implementation PPInfoMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    [self.view addSubview:self.tableView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.tableView registerClass:[PPSettingCell class] forCellReuseIdentifier:@"PPSettingCell"];
    
    [self.tableView registerClass:[PPInfoMessageCell class] forCellReuseIdentifier:@"PPInfoMessageCell"];
    self.title = @"个人信息";
    
    self.tableView.sectionFooterHeight = 0.1;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if(indexPath.section == 0 && indexPath.row == 0)
    {
        PPShowSelectIconViewController * controller = [PPShowSelectIconViewController new];
        [self.navigationController pushViewController:controller animated:YES];
        
    }else if (indexPath.section == 1&& indexPath.row == 1)
    {
        PPSelectAreaViewController * controller = [PPSelectAreaViewController createPPSelectAreaViewController];
        [self.navigationController pushViewController:controller animated:YES];
        
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray * arr = titleArr()[section];
    
    return arr.count;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0 && indexPath.row == 0)
        return 90;
    
    return 45;
}
#pragma mark UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSArray * arr = titleArr()[indexPath.section];
    
    if(indexPath.section == 0&&(indexPath.row == 0 || indexPath.row == 3))
    {
 
        PPInfoMessageCell * cell = [tableView dequeueReusableCellWithIdentifier:@"PPInfoMessageCell"];
        [cell layoutLeftContent:arr[indexPath.row] rightImage:indexPath.row ==0? @"http://pic6.huitu.com/res/20130116/84481_20130116142820494200_1.jpg":[UIImage imageNamed:@"setting_myQR"] imageWidth:indexPath.row == 0 ? 90:20];
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            return cell;
        
    }
    else
    {
        PPSettingCell * cell = [tableView dequeueReusableCellWithIdentifier:@"PPSettingCell"];
        [cell layoutContent:arr[indexPath.row] textAligent:NSTextAlignmentLeft];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return cell;
        
        
    }
    return nil;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section == 0)
    {
        return 10;
    }
    return 15;
}
@end
