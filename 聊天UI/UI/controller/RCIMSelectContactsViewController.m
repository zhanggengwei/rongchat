//
//  RCIMSelectContactsViewController.m
//  rongchat
//
//  Created by VD on 2017/8/30.
//  Copyright © 2017年 vd. All rights reserved.
//

#import "RCIMSelectContactsViewController.h"
#import "PPContactListViewModel.h"

@interface RCIMSelectContactsViewController ()
@property (nonatomic,strong) PPContactListViewModel * viewModel;
@end

@implementation RCIMSelectContactsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.viewModel = [PPContactListViewModel new];
    [self.viewModel.changeSignal subscribeNext:^(NSArray * results) {
        
    }];
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
