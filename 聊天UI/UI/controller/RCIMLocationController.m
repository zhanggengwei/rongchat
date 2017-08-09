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
#import "PPImageUtil.h"
#import "RCIMLocationManager.h"

@interface RCIMLocationController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) MAMapView * mapView;
@property (nonatomic,strong) RCIMLocationObj * currentObj;
@property (nonatomic,strong) UITableView * tableView;
@property (nonatomic,strong) AMapGeoPoint * mapPoint;
@property (nonatomic,strong) NSMutableArray<AMapPOI *> * pois;
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
    _mapView.showsUserLocation = YES;
    _mapView.userTrackingMode = MAUserTrackingModeNone;
    _mapView.distanceFilter = kCLLocationAccuracyBest;
    self.tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.view.mas_bottom);
        make.height.mas_equalTo(SCREEN_HEIHGHT - 300);
    }];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.currentObj.name = [RCIMLocationManager shareManager].locationReGeocode.formattedAddress;
    CLLocationCoordinate2D  location = [RCIMLocationManager shareManager].location.coordinate;
    [self.mapView setCenterCoordinate:location animated:YES];
    _mapView.region = MACoordinateRegionMake(_mapView.centerCoordinate, MACoordinateSpanMake(0.01, 0.01));
    self.currentObj.location = CLLocationCoordinate2DMake(location.latitude,location.longitude);
    
    self.currentObj.thumbnailImage = [PPImageUtil imageFromView:self.mapView];
    AMapGeoPoint * mapPoint = [AMapGeoPoint locationWithLatitude:location.latitude longitude:location.longitude];
    self.mapPoint = mapPoint;
    [self loadNearAddressByMeters:100];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSMutableArray<AMapPOI *> *)pois
{
    if(_pois==nil)
    {
        _pois = [NSMutableArray new];
    }
    return _pois;
}

- (void)loadNearAddressByMeters:(NSInteger)meters
{
    [[RCIMLocationManager shareManager]loadAreasWithAreaName:self.mapPoint withRadious:meters searchAroundAddressBlock:^(AMapPOISearchResponse *response, NSError *error) {
        NSLog(@"response == %d",response.count);
        [self.pois addObjectsFromArray:response.pois];
        [self.tableView reloadData];
    }];
}


- (RCIMLocationObj *)currentObj
{
    if(_currentObj==nil)
    {
        _currentObj = [RCIMLocationObj new];
    }
    return _currentObj;
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
    if([self.delegate respondsToSelector:@selector(sendLocation:)])
    {
        [self.delegate sendLocation:self.currentObj];
    }
}
//- (void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation
//{
//    [mapView setCenterCoordinate:userLocation.coordinate animated:YES];
//    _mapView.region = MACoordinateRegionMake(_mapView.centerCoordinate, MACoordinateSpanMake(0.01, 0.01));
//    self.currentObj.location = CLLocationCoordinate2DMake(userLocation.location.coordinate.latitude, userLocation.location.coordinate.longitude);
//    self.currentObj.thumbnailImage = [PPImageUtil imageFromView:self.mapView];
//    AMapGeoPoint * mapPoint = [AMapGeoPoint locationWithLatitude:userLocation.location.coordinate.latitude longitude:userLocation.location.coordinate.longitude];
//    self.mapPoint = mapPoint;
//    [self loadNearAddressByMeters:1];
//    
//    
//}

#pragma mark UITableViewDelegate


#pragma makr UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    AMapPOI * model = self.pois[indexPath.row];
    cell.detailTextLabel.text = model.name;
    cell.textLabel.text = model.name;
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.pois.count;
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
