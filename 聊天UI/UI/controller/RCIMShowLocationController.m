//
//  RCIMShowLocationController.m
//  rongchat
//
//  Created by VD on 2017/8/10.
//  Copyright © 2017年 vd. All rights reserved.
//

#import "RCIMShowLocationController.h"
#import <MAMapKit/MAMapKit.h>
@interface RCIMShowLocationController ()
@property (nonatomic,strong) MAMapView * mapView;
@end

@implementation RCIMShowLocationController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.mapView = [[MAMapView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:self.mapView];
    [self.mapView setCenterCoordinate:self.coordinate animated:YES];
    _mapView.region = MACoordinateRegionMake(_mapView.centerCoordinate, MACoordinateSpanMake(0.01, 0.01));
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
