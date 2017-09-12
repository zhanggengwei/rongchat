
//
//  PPSetingViewController.m
//  rongChatDemo1
//
//  Created by vd on 2016/11/2.
//  Copyright © 2016年 vd. All rights reserved.
//

#import "PPSetingViewController.h"
#import "PPSettingCell.h"
#import "PPAccountSecurityViewController.h"
#import <WActionSheet/NLActionSheet.h>

@interface PPSetingViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView * tableView;
@property (nonatomic,strong) NSMutableArray * dataArr;
@end

@implementation PPSetingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"设置";
    self.dataArr = [NSMutableArray new];
    [self.dataArr addObject:@"帐号与安全"];
    [self.dataArr addObject:@"新消息通知"];
    [self.dataArr addObject:@"隐私"];
    [self.dataArr addObject:@"通用"];
    [self.dataArr addObject:@"帮助与反馈"];
    [self.dataArr addObject:@"关于微信"];
    [self.dataArr addObject:@"退出登陆"];
    self.tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    [self.view addSubview:self.tableView];
    [self.tableView registerClass:[PPSettingCell class] forCellReuseIdentifier:@"PPSettingCell"];
    self.tableView.sectionFooterHeight = 0.1;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSInteger index = 0;
    switch (indexPath.section) {
        case 0:
            index = 0;
            break;
        case 1:
            index = 1  + indexPath.row;
            break;
            
        case 2:
            index = 4 + indexPath.row;
            break;
        case 3:
            index = 6;
            break;
        default:
            break;
    }
    PPSettingCell * cell = [tableView dequeueReusableCellWithIdentifier:@"PPSettingCell"];
    [cell layoutContent:self.dataArr[index] textAligent:index==6 ?NSTextAlignmentCenter:NSTextAlignmentLeft];
    if (indexPath.section != ([tableView numberOfSections]-1))
    {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    return cell;
    
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0)
    {
        return 1;
    }
    else if (section == 1)
    {
        return 3;
    }else if (section == 2)
    {
        return 2;
    }
    return 1;
}

#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
 
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    if (indexPath.section ==0 && indexPath.row ==0) {
        PPAccountSecurityViewController * controller = [PPAccountSecurityViewController new];
        [self.navigationController pushViewController:controller animated:YES];
    }else if (indexPath.section == 3&&indexPath.row == 0)
    {
        NLActionSheet * sheet = [[NLActionSheet alloc]initWithTitle:@"退出后不会删除任何历史数据,下次登陆依然可以使用本账号" cancelTitle:@"取消" otherTitles:@[@"退出登陆"]];
        sheet.otherTitlesColor = [UIColor redColor];
        sheet.titleFont = [UIFont systemFontOfSize:12];
        [sheet showView];
        [sheet dismissForCompletionHandle:^(NSInteger clickedIndex, BOOL isCancel) {
            if(!isCancel&&clickedIndex == 0)
            {
                [[NSNotificationCenter defaultCenter]postNotificationName:RCIMLogoutSucessedNotifaction object:nil];
                [[PPTUserInfoEngine shareEngine]logoutSucessed];
            }
        }];
        
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section==0)
    {
        return  10;
    }
    return 15;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 48;
}

- (void)dealloc
{
    NSLog(@"dealloc %@",[self class]);
}

@end
