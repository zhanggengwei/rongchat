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
#import "RCIMAddNewContactViewController.h"


@interface PPContactListViewController ()
@property (nonatomic,strong) PPContactListViewModel * contactListViewModel;
@end

@implementation PPContactListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.showIndexTitles = YES;
    self.style = UITableViewStylePlain;
    self.cellClass = [PPContactListCell class];
    self.contactListViewModel = [PPContactListViewModel new];
    UIBarButtonItem * rightItem = [[UIBarButtonItem alloc]initWithImage:IMAGE(@"contacts_add_friend") style:UIBarButtonItemStylePlain target:self action:@selector(addFriend)];
    
    self.navigationItem.rightBarButtonItem = rightItem;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = kMainBackGroundColor;
    @weakify(self);
    [self.contactListViewModel.changeSignal subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        self.dataSource = x;
    } error:^(NSError * _Nullable error) {
        NSLog(@"error == %@",error);
    }];
    [RACObserve(self, selectCellSignal)subscribeNext:^(RACSignal * signal) {
        @strongify(self);
        [signal subscribeNext:^(RCUserInfoData * data) {
            UIViewController * controller = [NSClassFromString(data.controllerName) new];
            [self.navigationController pushViewController:controller animated:YES];
        }];
    }];
    self.tableView.backgroundColor = [UIColor whiteColor];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    NSLog(@"dd");
}

- (void)createUI
{
    
}

-(void)addFriend
{
    RCIMAddNewContactViewController * controller = [RCIMAddNewContactViewController new];
    [self.navigationController pushViewController:controller animated:YES];
}

- (PPContactListCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PPContactListCell * cell = (PPContactListCell *)[super tableView:tableView cellForRowAtIndexPath:indexPath];
    if(indexPath.section==0&&indexPath.row==0)
    {
        [RACObserve([PPTUserInfoEngine shareEngine], promptCount)subscribeNext:^(NSString * x) {
            cell.unreadCount = [x integerValue];
        }];
    }
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section==self.dataSource.count-1) {
        NSInteger count = [PPTUserInfoEngine shareEngine].contactList.count;
        UILabel * bottomLabel = [UILabel new];
        bottomLabel.font = [UIFont systemFontOfSize:15];
        bottomLabel.text = [NSString stringWithFormat:@"%ld位联系人",count];
        bottomLabel.textColor = UIColorFromRGB(0x727272);
        bottomLabel.textAlignment = NSTextAlignmentCenter;
        bottomLabel.backgroundColor = [UIColor whiteColor];
        return bottomLabel;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section==self.dataSource.count-1) {
        return 50;
    }
    return 0;
}
//#pragma mark UITableViewDataSource
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    PPContactListCell *  cell = [tableView dequeueReusableCellWithIdentifier:@"PPContactListCell"];
//    
//    NSDictionary * dict = [self.contactDict objectAtIndex:indexPath.section];
//    NSArray * array = dict.allValues.firstObject;
//    RCUserInfoData * info = array[indexPath.row];
//    cell.model = info;
//    return cell;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//    NSDictionary * dict = [self.contactDict objectAtIndex:section];
//    NSArray * array = [dict.allValues objectAtIndex:0];
//    return array.count;
//}
//
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//    return self.contactDict.count;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return 50;
//}
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    RCIMNewContactListViewController * controller = [RCIMNewContactListViewController new];
//    [self.navigationController pushViewController:controller animated:YES];
//    
//}
//
//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
//    NSDictionary * dict = [self.contactDict objectAtIndex:section];
//    return [dict allKeys].firstObject;
//    
//}
//- (nullable NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView
//{
//    return @[@"d"];
//    
//}
//- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
//{
//    if(0 == index)
//    {
//        
//        return -1;
//    }
//    else
//    {
//        //因为返回的值是section的值。所以减1就是与section对应的值了
//        return index-1;
//    }
//}
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    if(section==0)
//    {
//        return 45;
//    }
//    return 30;
//    
//}
//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
//{
//    return 0.01;
//}
@end
