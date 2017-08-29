//
//  RCIMCustomTableViewController.m
//  rongchat
//
//  Created by VD on 2017/8/29.
//  Copyright © 2017年 vd. All rights reserved.
//

#import "RCIMCustomTableViewController.h"
#import <ReactiveObjC.h>

@interface RCIMCustomTableViewController ()
@property (nonatomic,strong) RACSignal * selectCellSignal;
@property (nonatomic,strong) RACCommand * didSelectCommand;
@property (nonatomic,strong) UITableView * tableView;
@end

@implementation RCIMCustomTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
    @weakify(self);
    [RACObserve(self,dataSource) subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [self.tableView reloadData];
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UITableView *)tableView
{
    if(_tableView==nil)
    {
        _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:self.style];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    }
    return _tableView;
}

- (void)setCellClass:(Class)cellClass
{
    _cellClass = cellClass;
    if(cellClass)
    {
        [self.tableView registerClass:_cellClass forCellReuseIdentifier:NSStringFromClass(_cellClass)];
    }
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSDictionary * dict = [self.dataSource objectAtIndex:section];
    NSArray * array = [dict.allValues objectAtIndex:0];
    return array.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    NSDictionary * dict = [self.dataSource objectAtIndex:indexPath.section];
    NSArray * array = [dict.allValues objectAtIndex:0];
    id model = array[indexPath.row];
    self.selectCellSignal = [self.didSelectCommand execute:model];
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSDictionary * dict = [self.dataSource objectAtIndex:section];
    return [dict allKeys].firstObject;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RCContactListCell * cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(self.cellClass)];
    NSDictionary * dict = [self.dataSource objectAtIndex:indexPath.section];
    NSArray * array = [dict.allValues objectAtIndex:0];
    id model = array[indexPath.row];
    cell.model = model;
    return cell;
}

- (RACCommand *)didSelectCommand
{
    if(_didSelectCommand==nil)
    {
        _didSelectCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            RACSignal * signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                [subscriber sendNext:input];
                [subscriber sendCompleted];
                return nil;
            }];
            return signal;
        }];
    }
    return _didSelectCommand;
}

@end
