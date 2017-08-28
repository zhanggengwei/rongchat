//
//  PPContactListViewController.m
//  rongchat
//
//  Created by vd on 2016/11/17.
//  Copyright © 2016年 vd. All rights reserved.
//

#import "PPContactListViewController.h"
#import "PPContactListCell.h"
#import "NSString+isValid.h"
#import "PPContactListViewModel.h"

@interface PPContactListViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView * tableView;
@property (nonatomic,strong) NSArray * array;
@property (nonatomic,strong) NSArray * imageArray;
@property (nonatomic,strong) NSArray * contactDict;
@property (nonatomic,strong) PPContactListViewModel * contactListViewModel;

@end

@implementation PPContactListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.contactListViewModel = [PPContactListViewModel new];
    self.tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    [self.tableView registerClass:[PPContactListCell class] forCellReuseIdentifier:@"PPContactListCell"];
    
    [self.view addSubview:self.tableView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.sectionIndexBackgroundColor = [UIColor clearColor];
    self.tableView.sectionIndexColor = [UIColor grayColor];
    UIBarButtonItem * rightItem = [[UIBarButtonItem alloc]initWithImage:IMAGE(@"contacts_add_friend") style:UIBarButtonItemStylePlain target:self action:@selector(addFriend)];
    
    self.navigationItem.rightBarButtonItem = rightItem;
    self.contactDict = [NSArray new];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = kMainBackGroundColor;
    @weakify(self);
    [self.contactListViewModel.changeSignal subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        self.contactDict = x;
        [self.tableView reloadData];
    } error:^(NSError * _Nullable error) {
        NSLog(@"error == %@",error);
    }];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    
}

- (void)createUI
{
    
}

-(void)addFriend
{
}
#pragma mark UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PPContactListCell *  cell = [tableView dequeueReusableCellWithIdentifier:@"PPContactListCell"];
    
    NSDictionary * dict = [self.contactDict objectAtIndex:indexPath.section];
    NSArray * array = dict.allValues.firstObject;
    RCUserInfoData * info = array[indexPath.row];
    cell.model = info;
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSDictionary * dict = [self.contactDict objectAtIndex:section];
    NSArray * array = [dict.allValues objectAtIndex:0];
    return array.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.contactDict.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSDictionary * dict = [self.contactDict objectAtIndex:section];
    return [dict allKeys].firstObject;
    
}
- (nullable NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return @[@"d"];
    
}
- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    if(0 == index)
    {
        
        return -1;
    }
    else
    {
        //因为返回的值是section的值。所以减1就是与section对应的值了
        return index-1;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section==0)
    {
        return 45;
    }
    return 30;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}
@end
