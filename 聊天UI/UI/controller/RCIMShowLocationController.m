//
//  RCIMShowLocationController.m
//  rongchat
//
//  Created by VD on 2017/8/10.
//  Copyright © 2017年 vd. All rights reserved.
//

#import "RCIMShowLocationController.h"
#import <MAMapKit/MAMapKit.h>
#import "RCIMCustomMapView.h"
@interface RCIMShowLocationController ()
@property (nonatomic,strong) RCIMCustomMapView * customMapView;
@end

@implementation RCIMShowLocationController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.customMapView];
    MAPointAnnotation * animation = [MAPointAnnotation new];
    animation.coordinate = self.coordinate;
    [self.customMapView addAnimation:animation];
    
   
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark lazy Method

- (RCIMCustomMapView *)customMapView
{
    if(_customMapView==nil)
    {
        _customMapView = [[RCIMCustomMapView alloc]initWithFrame:self.view.bounds];
    }
    return _customMapView;
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
