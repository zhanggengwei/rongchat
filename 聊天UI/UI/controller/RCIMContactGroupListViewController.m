//
//  RCIMContactGroupListViewController.m
//  rongchat
//
//  Created by VD on 2017/8/30.
//  Copyright © 2017年 vd. All rights reserved.
//

#import "RCIMContactGroupListViewController.h"
#import "PPContactListCell.h"
#import "RCIMContactGroupListViewModel.h"
@interface RCIMContactGroupListViewController ()
@property (nonatomic,assign) NSInteger count;
@property (nonatomic,strong)RCIMContactGroupListViewModel * viewModel;
@end

@implementation RCIMContactGroupListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"群聊列表";
    self.viewModel = [RCIMContactGroupListViewModel new];
    self.cellClass = [PPContactListCell class];
    self.dataSource = @[@{@"":self.viewModel.dataSource}];
    @weakify(self);
    [self.viewModel.subject subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        self.dataSource= @[@{@"":x}];
    }];
    RACSignal * signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
       [RACObserve(self,count) subscribeNext:^(id  _Nullable x) {
           [subscriber sendNext:@(self.count)];
           [subscriber sendCompleted];
       }];
        return nil;
    }];
    [signal subscribeNext:^(id  _Nullable x) {
        NSLog(@"x==%@",x);
    }];
    [[[RACSignal interval:2 onScheduler:[RACScheduler mainThreadScheduler]] takeUntil:self.rac_willDeallocSignal ] subscribeNext:^(id x) {
        self.count++;
        NSLog(@"每两秒执行一次");
        
    } completed:^{
        NSLog(@"每两秒执行一次:completed");
    }];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    NSLog(@"控制器销毁 %@",[self class]);
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55;
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
