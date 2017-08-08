//
//  RCIMLocationController.m
//  rongchat
//
//  Created by VD on 2017/7/24.
//  Copyright © 2017年 vd. All rights reserved.
//

#import "RCIMLocationController.h"
#import <MAMapKit/MAMapKit.h>

@interface RCIMLocationController ()
@property (nonatomic,strong) MAMapView * mapView;

@end

@implementation RCIMLocationController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"位置";
    [self createNavUI];
    self.mapView = [[MAMapView alloc]initWithFrame:CGRectZero];
    [self.view addSubview:self.mapView];
    [self.mapView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(self.view);
        make.height.mas_equalTo(300);
    }];
    _mapView.showsUserLocation = YES;
    _mapView.userTrackingMode = MAUserTrackingModeFollow;
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)createNavUI
{
    UIBarButtonItem * leftItem = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancelsendLocationMessage)];

    UIBarButtonItem * rightItem = [[UIBarButtonItem alloc]initWithTitle:@"发送" style:UIBarButtonItemStylePlain target:self action:@selector(sendLocationMessage)];
    self.navigationItem.leftBarButtonItem = leftItem;
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (void)cancelsendLocationMessage
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)sendLocationMessage
{
    [self dismissViewControllerAnimated:YES completion:nil];
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
