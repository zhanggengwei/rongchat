//
//  PPInfoMessageViewController.m
//  rongChatDemo1
//
//  Created by Donald on 16/11/7.
//  Copyright © 2016年 vd. All rights reserved.
//

#import "PPInfoMessageViewController.h"
#import "PPInfoMessageCell.h"
#import "PPSettingCell.h"
#import "PPShowSelectIconViewController.h"
#import "PPSelectAreaViewController.h"
#import "PPPhotoSeleceOrTakePhotoManager.h"
#import "PPUpdateNickNameController.h"
#import "RCIMQRCodeViewCustomController.h"


@implementation PPInfoMessageViewController
{
    NSMutableArray * _dataArray;
}

- (instancetype)init
{
    if(self = [super initWithStyle:UITableViewStyleGrouped])
    {
        _dataArray = [NSMutableArray new];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"个人信息";
    self.tableView.sectionFooterHeight = 0.1;
    [self.tableView registerClass:[PPCustomTableViewCell class] forCellReuseIdentifier:@"PPCustomTableViewCell"];
    [self loadData];
    // Do any additional setup after loading the view.
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadData
{
    PPCustomCellData * data1 = [PPCustomCellData new];
    data1.text = @"头像";
    data1.imageUrl = [PPTUserInfoEngine shareEngine].user_Info.user.portraitUri;
    
    PPCustomCellData * data2 = [PPCustomCellData new];
    data2.text = @"名字";
    data2.detail = [PPTUserInfoEngine shareEngine].user_Info.user.name;
    
    PPCustomCellData * data3 = [PPCustomCellData new];
    data3.text = @"微信号";
    data3.detail = @"VD2012";
 
    PPCustomCellData * data4 = [PPCustomCellData new];
    data4.text = @"我的二维码";
    
    PPCustomCellData * data5 = [PPCustomCellData new];
    data5.text = @"更多";
    
    [_dataArray addObject:@[data1,data2,data3,data4,data5]];

    PPCustomCellData * data6 = [PPCustomCellData new];
    data6.text = @"我的地址";
    [_dataArray addObject:@[data6]];
    
}


#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if(indexPath.section == 0 && indexPath.row == 0)
    {
        PPShowSelectIconViewController * controller = [PPShowSelectIconViewController new];
        [self.navigationController pushViewController:controller animated:YES];
    }else if (indexPath.section==0&&indexPath.row==3)
    {
        [self.navigationController pushViewController:[RCIMQRCodeViewCustomController new] animated:YES];
    }
    //else if (indexPath.section == 1&& indexPath.row == 1)
//    {
//        PPSelectAreaViewController * controller = [PPSelectAreaViewController createPPSelectAreaViewController];
//        [self.navigationController pushViewController:controller animated:YES];
//        
//    }
//    NSArray * arr = titleArr()[indexPath.section];
//    if([arr[indexPath.row] isEqualToString:@"我的二维码"])
//    {
////        PPPhotoSeleceOrTakePhotoManager * manager = [PPPhotoSeleceOrTakePhotoManager sharedPPPhotoSeleceOrTakePhotoManager];
////        [manager pushQRCodeController:self];
//        [self.navigationController pushViewController:[RCIMQRCodeViewCustomController new] animated:YES];
//        
//    }else if ([arr[indexPath.row] isEqualToString:@"名字"])
//    {
//        PPUpdateNickNameController * controller = [PPUpdateNickNameController new];
//        [self.navigationController pushViewController:controller animated:YES];
//        
//    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _dataArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray * arr = _dataArray[section];
    return arr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section==0&&indexPath.row==0)
    {
        return 80;
    }
    return 44;
}
#pragma mark UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PPCustomCellData * data =  _dataArray[indexPath.section][indexPath.row];
    PPCustomTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"PPCustomTableViewCell"];
    cell.text = data.text;
    cell.icon_leftMargin = 12;
    cell.detail = data.detail;
    cell.right_icon = data.rightIcon;
    cell.imageUrl = data.imageUrl;
    if(indexPath.section==0&&indexPath.row==0)
    {
        cell.right_iconSize = CGSizeMake(60, 60);
    }
    return cell;
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
