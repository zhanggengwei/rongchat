//
//  PPMyViewController.m
//  rongchat
//
//  Created by vd on 2016/11/17.
//  Copyright © 2016年 vd. All rights reserved.
//

#import "PPMyViewController.h"
#import "PPSetingViewController.h"
#import "PPInfoMessageViewController.h"
#import "PPPersonTableViewCell.h"
@interface PPMyViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView * tableView;
@property (nonatomic,strong) NSMutableArray * dataArray;
@end

@implementation PPMyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIHGHT) style:UITableViewStyleGrouped];
  
    [self.view addSubview:self.tableView];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.sectionFooterHeight = 0.1;
    [self.tableView registerClass:[PPPersonTableViewCell class] forCellReuseIdentifier:@"PPPersonTableViewCell"];

    self.tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];

    [self createData];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)createData
{
    self.dataArray = [NSMutableArray new];
    
    PPPersonal * model1 = [PPPersonal new];
    model1.leftIconName = @"";
    model1.rightIconName = @"setting_myQR";
    model1.content = @"123";
    [self.dataArray addObject:model1];
    
    
    PPPersonal * model2 = [PPPersonal new];
    model2.leftIconName = @"me_photo";
    model2.content = @"相册";
    [self.dataArray addObject:model2];
    
    
    
    PPPersonal * model3 = [PPPersonal new];
    model3.leftIconName = @"me_collect";
    model3.content = @"收藏";
    
    [self.dataArray addObject:model3];
    
    
    PPPersonal * model4 = [PPPersonal new];
    model4.leftIconName = @"me_collect";
    model4.content = @"钱包";
    
    [self.dataArray addObject:model4];
    
    
    PPPersonal * model5 = [PPPersonal new];
    model5.leftIconName = @"MoreExpressionShops";
    model5.content = @"表情";
    [self.dataArray addObject:model5];
    
    
    
    PPPersonal * model6 = [PPPersonal new];
    model6.leftIconName = @"me_setting";
    model6.content = @"设置";
    [self.dataArray addObject:model6];
    
    [self.tableView reloadData];
    
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PPPersonTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"PPPersonTableViewCell"];
    NSInteger index = 0;
    PPPersonTableViewCellStyle style = 0;
    switch (indexPath.section) {
        case 0:
        {
            index = 0;
            style = PPPersonTableViewCellBigImage;
            break;
        }
        case 1:
        {
            index = 1 + indexPath.row;
            break;
        }
        case 2:
        {
            index = 4 + indexPath.row;
            break;
        }
        case 3:
        {
            index = 5 + indexPath.row;
            break;
        }
        case 4:
        {
            index = 6 + indexPath.row;
            break;
        }
        default:
            break;
    }
    
    PPPersonal * model = [self.dataArray objectAtIndex:index];
    
    
    [cell layoutData:style cellModel:model];
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
    
}




- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

        if(indexPath.section==0)
        {
            return 100;
        }
    
        return 48;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 3 && indexPath.row == 0)
    {
        PPSetingViewController * controller = [PPSetingViewController new];
        controller.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:controller animated:YES];
        
    }else if(indexPath.section == 0&&indexPath.row == 0)
    {
        PPInfoMessageViewController * controller = [PPInfoMessageViewController new];
        
        controller.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:controller animated:YES];
        
        
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
 
    switch (section)
    {
    case 0:
        return 1;
    case 1:
        return 3;
    case 2:
        return 1;
    case 3:
        return 1;
    default: break;
        
    }
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return  8;
            break;
        default:
            return 15;
            break;
    }
}
@end
