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
#import "RCIMCustomContactListViewModel.h"

@interface RCIMSelectContactsViewController ()
@property (nonatomic,strong) RCIMCustomContactListViewModel * viewModel;
@property (nonatomic,strong) NSMutableArray * selectMembers;
@property (nonatomic,assign) NSInteger count;

@end

@implementation RCIMSelectContactsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"选择联系人";
    self.viewModel = [RCIMCustomContactListViewModel new];
    self.cellClass = [RCIMSelectContactListCell class];
    self.dataSource = self.viewModel.contactList;
    [self createNav];
    // Do any additional setup after loading the view.
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSMutableArray *)selectMembers
{
    if(_selectMembers==nil)
    {
        _selectMembers = [NSMutableArray new];
    }
    return _selectMembers;
}

- (void)createNav
{
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancelAction:)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(finishAction:)];
    self.navigationItem.rightBarButtonItem.enabled = NO;
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15],NSForegroundColorAttributeName:UIColorFromRGB(0x727272)} forState:UIControlStateDisabled];
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15],NSForegroundColorAttributeName:kPPLoginButtonColor} forState:UIControlStateNormal];
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15],NSForegroundColorAttributeName:kPPLoginButtonColor} forState:UIControlStateSelected];
    RAC(self.navigationItem.rightBarButtonItem,enabled) = [RACObserve(self, count)filter:^BOOL(id value) {
        BOOL flag = [value boolValue];
        if (flag)
        {
            self.navigationItem.rightBarButtonItem.title = [NSString stringWithFormat:@"完成(%ld)",[value integerValue]];
        }
        return flag;
    }];
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    RCIMSelectContactListCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    RCIMContactListModelItem * item = cell.model;
    
    item.isSelected = !item.isSelected;
    if(item.isSelected)
    {
        [self.selectMembers addObject:item.model];
        self.count++;
    }else
    {
        [self.selectMembers removeObject:item.model];
        self.count--;
    }
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (void)cancelAction:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)finishAction:(id)sender
{
    
    [[[PPDateEngine manager]createContactGroupName:@"" members:self.selectMembers]subscribeNext:^(id  _Nullable x) {
        NSLog(@"x==%@",x);
    }];
}

@end
