//
//  RCIMSelectContactsViewController.m
//  rongchat
//
//  Created by VD on 2017/8/30.
//  Copyright © 2017年 vd. All rights reserved.
//

#import "RCIMSelectContactsViewController.h"
#import "PPContactListViewModel.h"
#import "RCIMSelectContactListCell.h"


@interface RCIMSelectContactsViewController ()
@property (nonatomic,strong) PPContactListViewModel * viewModel;
@end

@implementation RCIMSelectContactsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"选择联系人";
    self.viewModel = [PPContactListViewModel new];
    self.cellClass = [RCIMSelectContactListCell class];
    @weakify(self);
    [self.viewModel.changeSignal subscribeNext:^(NSArray *  x) {
        @strongify(self)
        self.dataSource = [x subarrayWithRange:NSMakeRange(1,x.count-2)];
        
    } error:^(NSError * _Nullable error) {
        NSLog(@"error == %@",error);
    }];
    
    
    [RACObserve(self, selectCellSignal)subscribeNext:^(RACSignal * signal) {
        [signal subscribeNext:^(RCUserInfoData * data) {
            data.isSelected = !data.isSelected;
        }];
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
