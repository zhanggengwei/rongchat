//
//  RCConversationListViewController.m
//  rongchat
//
//  Created by Donald on 16/12/6.
//  Copyright © 2016年 vd. All rights reserved.
//

#import "RCConversationListViewController.h"
#import "PPViewUtil.h"
#import "RCIM.h"
@interface RCConversationListViewController ()<RCIMConnectionStatusDelegate>
@property (nonatomic,strong) UIActivityIndicatorView * activityView;
@property (nonatomic,strong) UILabel * titleLabel;

@end

@implementation RCConversationListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleFont = [UIFont systemFontOfSize:17];
    [[RCIM sharedRCIM] setConnectionStatusDelegate:self];
    
    
    
    
    
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)onRCIMConnectionStatusChanged:(RCConnectionStatus)status
{
    
    switch (status)
    {
        case ConnectionStatus_Connected:
        {
          break;
        }
        case ConnectionStatus_Connecting:
        {
            
        }
        case ConnectionStatus_SERVER_INVALID:
        {
            
        }
        case ConnectionStatus_Unconnected:
        {
            
        }
        default:
            break;
    }
}

- (void)p_createNavBarTitleView
{
    self.navigationItem.titleView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 100, 40)];
    self.titleLabel = [UILabel new];
    [self.navigationItem.titleView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(0);
        make.centerX.mas_equalTo(self.navigationItem.titleView.mas_centerX).mas_offset(22);
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
- (void)setTitle:(NSString *)title
{
    if(self.title==nil)
    {
       [self p_createNavBarTitleView];
    }
    else if (title==nil)
    {
        return;
    }
    if(self.titleFont==nil)
    {
        self.titleFont = [UIFont systemFontOfSize:17];
    }
    
    UIColor * tintColor =[self.navigationController.navigationBar barTintColor];
    if(tintColor==nil)
    {
       // tintColor = [UIColor blackColor];
    }
    self.titleLabel.textColor = kPPTFontColorWhite;
    self.titleLabel.text = title;
    
    CGSize size = [PPViewUtil sizeWithString:title font:self.titleFont constrainedToSize:CGSizeMake(SCREEN_WIDTH - 100, 44) lineBreakMode:NSLineBreakByWordWrapping];
    
    [self.titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(size.width);
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

@end
