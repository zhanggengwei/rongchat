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
@property (nonatomic,strong) NSMutableArray * selectMembers;
@property (nonatomic,assign) NSInteger count;

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
//            data.isSelected = !data.isSelected;
//            if(data.isSelected)
//            {
//                [self.selectMembers addObject:data];
//                self.count++;
//            }else
//            {
//                [self.selectMembers removeObject:data];
//                self.count--;
//            }
        }];
    }];
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
    
}

@end
