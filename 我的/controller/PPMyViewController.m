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
#import "UIImage+RCIMExtension.h"


@interface PPCustomMineHeaderCell : UITableViewCell
@property (nonatomic,strong) RCUserInfoData * model;

@end

@implementation PPCustomMineHeaderCell
{
    UIImageView * _iconImageView;
    UILabel * _nameLabel;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        [self createUI];
    }
    return self;
}

- (void)createUI
{
    _iconImageView = [UIImageView new];
    _nameLabel = [UILabel new];
    
    [self.contentView addSubview:_iconImageView];
    [self.contentView addSubview:_nameLabel];
    _iconImageView.layer.cornerRadius = 4;
    _iconImageView.layer.masksToBounds = YES;
    [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(self.contentView.mas_left).mas_offset(12);
        make.top.mas_equalTo(self.contentView.mas_top).mas_offset(12);
        make.bottom.mas_equalTo(self.contentView.mas_bottom).mas_offset(-12);
        make.width.mas_equalTo(self.contentView.mas_height).mas_offset(-24);
    }];
    
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(_iconImageView.mas_centerY);
        make.left.mas_equalTo(_iconImageView.mas_right).mas_offset(12);
        make.right.mas_lessThanOrEqualTo(self.contentView.mas_right).mas_offset(-50);
    }];
    
    [RACObserve(self, model.user.name) subscribeNext:^(id  _Nullable x) {
        _nameLabel.text = x;
    }];
    
    [RACObserve(self, model.user.portraitUri) subscribeNext:^(id  _Nullable x) {
        SD_LOADIMAGE(_iconImageView, x, [UIImage RCIM_imageNamed:@"Placeholder_Avatar" bundleName:@"Placeholder" bundleForClass:[self class]]);
    }];
}

@end

@interface PPMyViewController ()
@property (nonatomic,strong) NSMutableArray * dataArray;

@end

@implementation PPMyViewController

- (instancetype)init
{
    if(self = [super initWithStyle:UITableViewStyleGrouped])
    {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.sectionFooterHeight = 0.1;
    [self.tableView registerClass:[PPCustomTableViewCell class] forCellReuseIdentifier:@"PPCustomTableViewCell"];
    [self.tableView registerClass:[PPCustomMineHeaderCell class] forCellReuseIdentifier:@"PPCustomMineHeaderCell"];
    self.tableView.tableFooterView = [UIView new];
    [self createData];
    [self.tableView reloadData];
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
    model1.leftIconName = @"MoreMyBankCard";
    model1.content = @"钱包";
    [self.dataArray addObject:@[model1]];
    
    
    PPPersonal * model2 = [PPPersonal new];
    model2.leftIconName = @"MoreMyFavorites";
    model2.content = @"收藏";
    
    PPPersonal * model3 = [PPPersonal new];
    model3.leftIconName = @"MoreMyAlbum";
    model3.content = @"相册";
  
    PPPersonal * model4 = [PPPersonal new];
    model4.leftIconName = @"MyCardPackageIcon";
    model4.content = @"卡包";

    PPPersonal * model5 = [PPPersonal new];
    model5.leftIconName = @"MoreExpressionShops";
    model5.content = @"表情";
    [self.dataArray addObject:@[model2,model3,model4,model5]];
    
    PPPersonal * model6 = [PPPersonal new];
    model6.leftIconName = @"MoreSetting";
    model6.content = @"设置";
    [self.dataArray addObject:@[model6]];

}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section==0)
    {
        PPCustomMineHeaderCell * cell = [tableView dequeueReusableCellWithIdentifier:@"PPCustomMineHeaderCell"];
        cell.model = [PPTUserInfoEngine shareEngine].user_Info;
        return cell;
    }else
    {
        PPCustomTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"PPCustomTableViewCell"];
        PPPersonal * model = [self.dataArray objectAtIndex:indexPath.section-1][indexPath.row];
        cell.icon_leftMargin = 12;
        cell.text_leftMargin = 12;
        cell.icon = [UIImage imageNamed:model.leftIconName];
        cell.text = model.content;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return cell;   
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section==0)
    {
        return 80;
    }
    return 48;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if(indexPath.section == 3 && indexPath.row == 0)
    {
        PPSetingViewController * controller = [PPSetingViewController new];
        controller.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:controller animated:YES];
    }else if(indexPath.section == 0&&indexPath.row == 0)
    {
        PPInfoMessageViewController * controller = [PPInfoMessageViewController new];
        [self.navigationController pushViewController:controller animated:YES];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1 + self.dataArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return section==0?1:[self.dataArray[section-1] count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 15;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section==0)
    {
        return 8;
    }
    return 0.01;
}

- (void)dealloc
{
    NSLog(@"dealloc");
}

@end
