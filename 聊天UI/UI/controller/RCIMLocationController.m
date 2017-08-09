//
//  RCIMLocationController.m
//  rongchat
//
//  Created by VD on 2017/7/24.
//  Copyright © 2017年 vd. All rights reserved.
//

#import "RCIMLocationController.h"
#import <MAMapKit/MAMapKit.h>
#import <UIView+MJExtension.h>
@interface RCIMLocationController ()<MAMapViewDelegate>
@property (nonatomic,strong) MAMapView * mapView;

@end

@implementation RCIMLocationController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"位置";
    [self createNavUI];
    self.mapView = [[MAMapView alloc]initWithFrame:self.view.bounds];
    self.mapView.mj_h = 300;
    [self.view addSubview:self.mapView];
    [AMapServices sharedServices].enableHTTPS = YES;
    _mapView.delegate = self;
    _mapView.showsUserLocation = YES;
    _mapView.userTrackingMode = MAUserTrackingModeNone;
    _mapView.distanceFilter = kCLLocationAccuracyBest;
    
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
- (void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation
{
    [mapView setCenterCoordinate:userLocation.coordinate animated:YES];
    _mapView.region = MACoordinateRegionMake(_mapView.centerCoordinate, MACoordinateSpanMake(0.01, 0.01));
    
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
