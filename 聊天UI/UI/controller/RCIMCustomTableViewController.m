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
@property (nonatomic,assign) NSInteger topSection;
@end

@implementation RCIMCustomTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
    [self.didSelectCommand execute:nil];
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
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor whiteColor];
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
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * view = [UIView new];
    UILabel * titleLabel = [UILabel new];
    [view addSubview:titleLabel];
    titleLabel.font = [UIFont systemFontOfSize:14];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(view.mas_left).mas_offset(8);
        make.centerY.mas_equalTo(view);
    }];
    view.backgroundColor = [UIColor colorWithRed:239/255.0 green:239/255.0 blue:246/255.0 alpha:1];
    titleLabel.textColor = UIColorFromRGB(0x727272);
    NSDictionary * dict = [self.dataSource objectAtIndex:section];
    NSString * title = [dict allKeys].firstObject;
    titleLabel.text = [title uppercaseString];
    if(section==self.topSection)
    {
        titleLabel.textColor = [UIColor redColor];
    }
    return view;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 25;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RCContactListCell * cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(self.cellClass)];
    NSDictionary * dict = [self.dataSource objectAtIndex:indexPath.section];
    NSArray * array = [dict.allValues objectAtIndex:0];
    id model = array[indexPath.row];
    cell.model = model;
    if(indexPath.row==0)
    {
        self.topSection = indexPath.section;
    }
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
