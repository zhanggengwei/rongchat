//
//  RCIMCustomTableViewController.m
//  rongchat
//
//  Created by VD on 2017/8/29.
//  Copyright © 2017年 vd. All rights reserved.
//

#import "RCIMCustomTableViewController.h"

@interface RCIMCustomTableViewController ()
@property (nonatomic,strong) RACCommand * didSelectCommand;
@end

@implementation RCIMCustomTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    NSDictionary * dict = [self.dataSource objectAtIndex:indexPath.section];
    NSArray * array = [dict.allValues objectAtIndex:0];
    id model = array[indexPath.row];
    self.selectCellSignal = [self.didSelectCommand execute:model];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RCContactListCell * cell = [self.tableView dequeueReusableCellWithIdentifier:NSStringFromClass(self.cellClass)];
    NSDictionary * dict = [self.dataSource objectAtIndex:indexPath.section];
    NSArray * array = [dict.allValues objectAtIndex:0];
    id model = array[indexPath.row];
    cell.model = model;
    return nil;
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
