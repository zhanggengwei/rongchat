//
//  RCIMNewContactListViewController.m
//  rongchat
//
//  Created by VD on 2017/8/29.
//  Copyright © 2017年 vd. All rights reserved.
//

#import "RCIMNewContactListViewController.h"
#import "RCIMAddContactCell.h"
@interface RCIMNewContactListViewController ()
@end

@implementation RCIMNewContactListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"新的朋友";
    self.cellClass = [RCIMAddContactCell class];
    @weakify(self);
    [RACObserve([PPTUserInfoEngine shareEngine], contactRequestList)subscribeNext:^(NSArray<RCUserInfoData *> * data) {
        @strongify(self);
        NSArray * arr = @[@{@"":data}];
        self.dataSource = arr;
    }];
    //清理好友请求
    [[PPTUserInfoEngine shareEngine]clearPromptCount];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return nil;
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
