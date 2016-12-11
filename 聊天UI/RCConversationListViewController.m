//
//  RCConversationListViewController.m
//  rongchat
//
//  Created by Donald on 16/12/6.
//  Copyright © 2016年 vd. All rights reserved.
//

#import "RCConversationListViewController.h"

@interface RCConversationListViewController ()<RCConnectionStatusChangeDelegate>
@property (nonatomic,strong) UIActivityIndicatorView * activityView;
@property (nonatomic,strong) UILabel * titleLabel;

@end

@implementation RCConversationListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[RCIMClient sharedRCIMClient] setRCConnectionStatusChangeDelegate:self];

    self.title = @"fd";
    
    
    [self p_createNavBarTitleView];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)onConnectionStatusChanged:(RCConnectionStatus)status
{
    
    
    
    
    
    
}

- (void)p_createNavBarTitleView
{
    
    self.navigationItem.titleView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 100, 40)];
    self.titleLabel = [UILabel new];
    [self.navigationItem.titleView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(self.navigationItem.titleView.mas_width);
        make.centerX.mas_equalTo(self.navigationItem.titleView.mas_centerX);
        make.top.mas_equalTo(self.navigationItem.titleView.mas_top);
        make.bottom.mas_equalTo(self.navigationItem.titleView.mas_bottom);
    }];
    self.titleLabel.text = @"未连接";
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    
    self.activityView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    [self.navigationItem.titleView addSubview:self.activityView];
    
    [self.activityView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.navigationItem.titleView.mas_top);
        make.right.mas_equalTo(self.titleLabel.mas_left);
        make.width.mas_equalTo(44);
        make.height.mas_equalTo(44);
    }];
    [self.activityView startAnimating];
    
    self.titleLabel.textColor = [UINavigationBar appearance].barTintColor;
    
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
