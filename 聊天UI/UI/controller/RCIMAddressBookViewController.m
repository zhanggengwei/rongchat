//
//  RCIMAddressBookViewController.m
//  rongchat
//
//  Created by VD on 2017/9/1.
//  Copyright © 2017年 vd. All rights reserved.
//

#import "RCIMAddressBookViewController.h"
#import <APContact.h>
#import <APAddressBook.h>
#import "RCIMObjPinYinHelper.h"
#import "RCIMAddressBookCell.h"

@interface RCIMAddressBookViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) NSArray * dataSource;
@property (nonatomic,strong) APAddressBook * addressBook;
@property (nonatomic,strong) UITableView * tableView;
@end

@implementation RCIMAddressBookViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"通讯录朋友";
    self.dataSource = [NSMutableArray new];
    [self createUI];
    [self loadData];
    
    // Do any additional setup after loading the view.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)createUI
{
    self.tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    [self.tableView registerClass:[RCIMAddressBookCell class] forCellReuseIdentifier:@"RCIMAddressBookCell"];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = kMainBackGroundColor;
    self.tableView.tableFooterView = [UIView new];
}

- (void)loadData
{
    NSMutableDictionary * dict = [NSMutableDictionary new];
    [self.addressBook requestAccessOnQueue:dispatch_queue_create("adressQueue", DISPATCH_QUEUE_CONCURRENT) completion:^(BOOL granted, NSError * _Nullable error) {
        if(granted)
        {
            [self.addressBook loadContacts:^(NSArray<APContact *> * _Nullable contacts, NSError * _Nullable error) {
                dispatch_group_t group =  dispatch_group_create();
                [contacts enumerateObjectsUsingBlock:^(APContact * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    dispatch_group_enter(group);
                    NSString * name = [NSString stringWithFormat:@"%@%@%@",obj.name.firstName,obj.name.middleName,obj.name.lastName];
                    RCIMAddressModel * model = [RCIMAddressModel new];
                    model.name = name;
                    model.phone = obj.phones.firstObject.number;
                    
                    [RCIMObjPinYinHelper converNameToPinyin:name block:^(NSString * indexChar) {
                        model.indexChar = indexChar;
                        NSArray * contactList = [dict objectForKey:indexChar];
                        if (contactList==nil) {
                            contactList = [NSArray new];
                            contactList = @[model];
                        }else
                        {
                            contactList = [contactList arrayByAddingObject:model];
                        }
                        [dict setObject:contactList forKey:indexChar];
                        dispatch_group_leave(group);
                    }];
                }];
                dispatch_group_notify(group, dispatch_get_main_queue(), ^{
                    NSMutableArray * lastArray = [NSMutableArray new];
                    for (NSString * key in [dict.allKeys sortedArrayUsingSelector:@selector(compare:)]) {
                        NSDictionary * contactDict = @{key:[dict objectForKey:key]};
                        [lastArray addObject:contactDict];
                    } ;
                    self.dataSource = lastArray;
                    [self.tableView reloadData];
                });
            }];
        }
    }];
}
- (APAddressBook *)addressBook
{
    if(_addressBook==nil)
    {
        _addressBook = [APAddressBook new];
    }
    return _addressBook;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RCIMAddressBookCell * cell = [tableView dequeueReusableCellWithIdentifier:@"RCIMAddressBookCell"];
    NSDictionary * dict = self.dataSource[indexPath.section];
    NSArray * arr = dict.allValues;
    RCIMAddressModel * model = arr.firstObject[indexPath.row];
    cell.model = model;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSDictionary * dict = self.dataSource[section];
    return [dict.allValues.firstObject count];
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSDictionary * dict = self.dataSource[section];
    return dict.allKeys.firstObject;
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
