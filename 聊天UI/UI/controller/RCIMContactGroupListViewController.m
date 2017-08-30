//
//  RCIMContactGroupListViewController.m
//  rongchat
//
//  Created by VD on 2017/8/30.
//  Copyright © 2017年 vd. All rights reserved.
//

#import "RCIMContactGroupListViewController.h"
#import "PPContactListCell.h"
@interface RCIMContactGroupListViewController ()

@end

@implementation RCIMContactGroupListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.cellClass = [PPContactListCell class];
    self.dataSource= @[@{@"":[PPTUserInfoEngine shareEngine].contactGroupList}];
    
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
