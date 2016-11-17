//
//  PPAccountSecurityViewController.m
//  rongChatDemo1
//
//  Created by vd on 2016/11/2.
//  Copyright © 2016年 vd. All rights reserved.
//

NSArray * array()
{
    return @[@[@"微信号"],@[@"QQ号",@"手机号",@"邮箱地址"],@[@"声音锁",@"微信密码",@"微信安全中心"]];
    
}

#import "PPAccountSecurityViewController.h"
#import "PPSettingCell.h"
@interface PPAccountSecurityViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) UITableView * tableView;


@end

@implementation PPAccountSecurityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"帐号与安全";
    
    self.tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    [self.view addSubview:self.tableView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.tableView registerClass:[PPSettingCell class] forCellReuseIdentifier:@"PPSettingCell"];
    
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0)
    {
        return  1;
    }
    return 3;
}
#pragma mark UITableViewDataSource


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PPSettingCell * cell = [tableView dequeueReusableCellWithIdentifier:@"PPSettingCell"];
    
    [cell layoutContent:array()[indexPath.section][indexPath.row] textAligent:NSTextAlignmentLeft andDetailText:@""];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section==0)
    {
        return  8;
    }
    return 15;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if(section == 2)
    {
        return 50;
    }
    return 0.1;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    if(section == 2)
    {
        return @"如果遇到帐号信息泄漏,忘记密码,诈骗等帐号安全问题,可前往微信安全中心";
    }
    return @"";
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 48;
    
}

@end
