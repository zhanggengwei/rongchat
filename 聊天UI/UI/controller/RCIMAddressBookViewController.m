//
//  RCIMAddressBookViewController.m
//  rongchat
//
//  Created by VD on 2017/9/1.
//  Copyright © 2017年 vd. All rights reserved.
//


#import "RCIMAddressBookViewController.h"
#import "RCIMAddressViewModel.h"
#import "RCIMAddressBookCell.h"

@interface RCIMAddressBookViewController ()
@property (nonatomic,strong) RCIMAddressViewModel * viewModel;
@end

@implementation RCIMAddressBookViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"通讯录朋友";
    [self createUI];
    self.cellClass = [RCIMAddressBookCell class];
    [self.viewModel.subject subscribeNext:^(id  _Nullable x) {
        self.dataSource = x;
        NSLog(@"x===%@",self.dataSource);
    }];
    self.dataSource = self.viewModel.data;
    
    // Do any additional setup after loading the view.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)createUI
{
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"关闭" style:UIBarButtonItemStylePlain target:self action:@selector(closeAction:)];
}

- (void)closeAction:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (RCIMAddressViewModel *)viewModel
{
    if(_viewModel==nil)
    {
        _viewModel = [RCIMAddressViewModel new];
    }
    return _viewModel;
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
