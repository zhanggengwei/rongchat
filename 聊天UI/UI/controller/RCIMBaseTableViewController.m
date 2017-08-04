//
//  RCIMBaseTableViewController.m
//  rongchat
//
//  Created by VD on 2017/8/3.
//  Copyright © 2017年 vd. All rights reserved.
//

#import "RCIMBaseTableViewController.h"
#import "NSObject+RCIMDeallocBlockExecutor.h"
@interface RCIMBaseTableViewController ()<RCIMStatusViewDelegate>

@end

@implementation RCIMBaseTableViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    //view在导航栏下方
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateStatusView) name:RCNotificationConnectivityUpdated object:nil];
    if (self.viewControllerStyle == RCIMViewControllerStylePresenting) {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(dismissViewController:)];
    }
    self.checkSessionStatus = YES;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillResignActive:) name:UIApplicationWillResignActiveNotification object:nil];
    [self lcck_executeAtDealloc:^{
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark public methods

- (void)loadDataSource
{
    
}
- (void)updateStatusView
{
    
}

- (UITableView *)tableView
{
    if(_tableView ==nil)
    {
        UITableView * tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:self.tableViewStyle];
        tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        tableView.backgroundColor = [UIColor clearColor];
        tableView.contentInset = UIEdgeInsetsZero;
        if(self.tableViewStyle==UITableViewStyleGrouped)
        {
            UIView *backgroundView = [[UIView alloc] initWithFrame:tableView.bounds];
            backgroundView.backgroundColor = tableView.backgroundColor;
            tableView.backgroundView = backgroundView;
        }
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.tableFooterView = [[UIView alloc] init];
        tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        [self.view addSubview:_tableView = tableView];
    }
    return _tableView;
}
- (RCIMStatusView *)clientStatusView
{
    if(_clientStatusView==nil)
    {
        _clientStatusView = [[RCIMStatusView alloc]initWithFrame:CGRectMake(0, 64, self.tableView.frame.size.width, RCIMStatusViewHight)];
        _clientStatusView.delegate = self;
        
    }
    return _clientStatusView;
}
- (NSMutableArray *)dataSource
{
    if(_dataSource==nil)
    {
        _dataSource = [NSMutableArray new];
    }
    return _dataSource;
}

- (void)dismissViewController:(id)sender {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)prefersStatusBarHidden {
    return NO;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}
- (void)applicationDidBecomeActive:(NSNotification*)note {
    self.checkSessionStatus = YES;
}

- (void)applicationWillResignActive:(NSNotification*)note {
    self.checkSessionStatus = NO;
}

#pragma mark LCCKStatusViewDelegate
- (void)statusViewClicked:(id)sender
{
    
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
