//
//  RCIMCustomTableViewController.m
//  rongchat
//
//  Created by VD on 2017/8/29.
//  Copyright © 2017年 vd. All rights reserved.
//

#import "RCIMCustomTableViewController.h"
#import <ReactiveObjC.h>
#import "RCIMTableSectionHeaderView.h"
#import "RCIMIndexView.h"
#import <UIView+FrameEx.h>
#import "NSString+isValid.h"


@interface RCIMCustomTableViewController ()
@property (nonatomic,strong) RACSignal * selectCellSignal;
@property (nonatomic,strong) RACCommand * didSelectCommand;
@property (nonatomic,strong) UITableView * tableView;
@property (nonatomic,strong) NSMutableArray<RCIMTableSectionHeaderView*> *headerArray;
@property (nonatomic,assign) NSInteger topSection;
@property (nonatomic,strong) RCIMIndexView * indexView;

@end

@implementation RCIMCustomTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.headerArray = [NSMutableArray new];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.indexView];
    [self.didSelectCommand execute:nil];
    @weakify(self);
    [RACObserve(self,dataSource) subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        NSMutableArray * indexArrays = [NSMutableArray new];
        [self.dataSource enumerateObjectsUsingBlock:^(NSDictionary * dict, NSUInteger idx, BOOL * _Nonnull stop) {
            NSString * title = [dict allKeys].firstObject;
            if([title isValid]){
            [indexArrays addObject:title];
            }
        }];
        self.indexView.indexArray = indexArrays;
        self.indexView.y = (SCREEN_HEIHGHT-64-49 - self.indexView.height)*0.5;
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
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    }
    return _tableView;
}

- (RCIMIndexView *)indexView
{
    if(_indexView==nil)
    {
        _indexView= [[RCIMIndexView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 20, 100,15,SCREEN_HEIHGHT)];
        [_indexView selectIndexBlock:^(NSInteger section)
         {
             [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:section] atScrollPosition:UITableViewScrollPositionTop animated:NO];
          }];
    }
    return _indexView;
}

- (void)setCellClass:(Class)cellClass
{
    _cellClass = cellClass;
    if(cellClass)
    {
        [self.tableView registerClass:_cellClass forCellReuseIdentifier:NSStringFromClass(_cellClass)];
    }
}
- (RCIMTableSectionHeaderView *)createHeaderView
{
    RCIMTableSectionHeaderView * headerView =[RCIMTableSectionHeaderView new];
    [self.headerArray addObject:headerView];
    return headerView;
}

- (RCIMTableSectionHeaderView *)getHeaderViewBySection:(NSInteger)section
{
    RCIMTableSectionHeaderView * headerView = nil;
    if(self.headerArray.count<=section)
    {
        headerView = [self createHeaderView];
    }else{
        headerView= [self.headerArray objectAtIndex:section];
        if(headerView==nil)
        {
            headerView = [self createHeaderView];
        }
    }
    return headerView;
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
    if(self.showIndexTitles){
    NSDictionary * dict = [self.dataSource objectAtIndex:section];
    NSString * title = [dict allKeys].firstObject;
    RCIMTableSectionHeaderStyle style;
    RCIMTableSectionHeaderView * headerView;
    if(self.topSection==section)
    {
        style = RCIMTableSectionHeaderStyleSelected;
    }else
    {
        style = RCIMTableSectionHeaderStyleCustom;
    }
    headerView = [self getHeaderViewBySection:section];
    [headerView setTitle:title style:style];
    return headerView;
    }else
    {
        return nil;
    }
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
    UIView * view = [tableView headerViewForSection:indexPath.section];
    NSLog(@"frame==%f",view.frame.origin.y);
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

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if(self.showIndexTitles)
    {
        NSArray<RCContactListCell *> * cells = [self.tableView visibleCells];
        NSInteger section = INT_MAX;
        for (RCContactListCell * cell in cells) {
            NSIndexPath * indexPath  = [self.tableView indexPathForCell:cell];
            section = MIN(section,indexPath.section);
            RCIMTableSectionHeaderView * headerView = headerView = [self getHeaderViewBySection:section];
            headerView.style = RCIMTableSectionHeaderStyleCustom;
        }
        self.topSection = section;
        RCIMTableSectionHeaderView * view = [self.headerArray objectAtIndex:section];
        [view setStyle:RCIMTableSectionHeaderStyleSelected];
    }
}

@end
