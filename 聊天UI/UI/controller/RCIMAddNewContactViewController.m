//
//  RCIMAddNewContactViewController.m
//  rongchat
//
//  Created by VD on 2017/9/1.
//  Copyright © 2017年 vd. All rights reserved.
//

#import "RCIMAddNewContactViewController.h"
#import "RCIMAddContactTableViewCell.h"
#import "RCIMAddContactModel.h"
#import "RCIMAddressBookViewController.h"
#import "RCIMNavigationController.h"
#import "JKRSearchController.h"
#import "JKRSearchResultViewController.h"

@interface RCIMAddNewContactViewController ()<JKRSearchControllerhResultsUpdating, JKRSearchControllerDelegate, JKRSearchBarDelegate>
@property (nonatomic, strong) JKRSearchController *searchController;
@end

@implementation RCIMAddNewContactViewController

- (void)viewDidLoad {
    self.style = UITableViewStyleGrouped;
    [super viewDidLoad];
    self.title = @"添加朋友";
    self.cellClass = [RCIMAddContactTableViewCell class];
    RCIMAddContactModel * model1 = [RCIMAddContactModel new];
    model1.title = @"雷达加朋友";
    model1.detail = @"添加身边的朋友";
    
    RCIMAddContactModel * model2 = [RCIMAddContactModel new];
    model2.title = @"面对面建群";
    model2.detail = @"与身边的朋友进入同一个群聊";
    
    RCIMAddContactModel * model3 = [RCIMAddContactModel new];
    model3.title = @"扫一扫";
    model3.detail = @"扫描二维码图片";
    
    
    RCIMAddContactModel * model4 = [RCIMAddContactModel new];
    model4.title = @"手机联系人";
    model4.detail = @"添加通讯录中的朋友";
    
    RCIMAddContactModel * model5 = [RCIMAddContactModel new];
    model5.title = @"公众号";
    model5.detail = @"获取更多的资讯和服务";
    self.dataSource = @[@{@"":@[model1,model2,model3,model4,model5]}];
    self.tableView.backgroundColor = kMainBackGroundColor;
    @weakify(self);
    
    void (^didSelectCellIndex)(NSInteger index) = ^(NSInteger index)
    {
        switch (index) {
            case 0:
                [self enterRadarAddContactController];
                break;
            case 1:
                [self enterCreateContactGroupController];
                break;
            case 2:
                [self enterQRCodeScanController];
                break;
            case 3:
                [self enterAddresBookController];
                break;
            case 4:
                [self enterPublicServiceController];
                break;
            default:
                break;
        }
    };
    [RACObserve(self, selectCellSignal) subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [self.selectCellSignal subscribeNext:^(id  _Nullable obj) {
            NSArray * arr = [self.dataSource.firstObject allValues];
            NSInteger index = [arr.firstObject indexOfObject:obj];
            didSelectCellIndex(index);
        }];
    }];
    self.tableView.tableHeaderView = self.searchController.searchBar;
        // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (JKRSearchController *)searchController {
    if (!_searchController) {
        JKRSearchResultViewController *resultSearchController = [[JKRSearchResultViewController alloc] init];
        _searchController = [[JKRSearchController alloc] initWithSearchResultsController:resultSearchController];
        _searchController.searchBar.placeholder = @"搜索";
        _searchController.hidesNavigationBarDuringPresentation = YES;
        _searchController.searchResultsUpdater = self;
        _searchController.searchBar.delegate = self;
        _searchController.delegate = self;
    }
    return _searchController;
}
- (void)enterPublicServiceController
{
    
}

- (void)enterQRCodeScanController
{
    
}
- (void)enterCreateContactGroupController
{
    
}
- (void)enterAddresBookController
{
    RCIMAddressBookViewController * controller = [RCIMAddressBookViewController new];
    RCIMNavigationController * navController = [[RCIMNavigationController alloc]initWithRootViewController:controller];
    [self presentViewController:navController animated:YES completion:nil];
}

- (void)enterRadarAddContactController
{
    
}
- (UIView *)createHeaderView
{
    UIView * headerView = [UIView new];
    UIView * topView = [UIView new];
    [headerView addSubview:topView];
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(headerView);
        make.height.mas_equalTo(50);
    }];
 
    UIView * bottomView = [UIView new];
    [headerView addSubview:bottomView];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(headerView);
        make.height.mas_equalTo(50);
    }];
    UIView * contentView = [UIView new];
    UILabel * label = [UILabel new];
    UIImageView * codeImageView = [UIImageView new];
    [contentView addSubview:label];
    [contentView addSubview:codeImageView];
    
    
    [codeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(15);
        make.right.top.mas_equalTo(contentView);
    }];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_equalTo(contentView);
        make.right.mas_equalTo(codeImageView.mas_left).mas_offset(-8);
    }];
    label.text = @"我的微信号:2012VD";
    label.font = [UIFont systemFontOfSize:14];
    [bottomView addSubview:contentView];
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(bottomView.mas_centerX);
        make.top.mas_equalTo(topView.mas_bottom).mas_offset(10);
        make.width.lessThanOrEqualTo(@200);
        //make.height.mas_equalTo(30);
    }];
    return headerView;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [self createHeaderView];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 100;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
