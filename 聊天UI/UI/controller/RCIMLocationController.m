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
#import "RCIMLocationTableViewCell.h"
#import <MJRefresh.h>
@interface RCIMLocationController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) MAMapView * mapView;
@property (nonatomic,strong) RCIMLocationObj * currentObj;
@property (nonatomic,strong) UITableView * tableView;
@property (nonatomic,strong) AMapGeoPoint * mapPoint;
@property (nonatomic,strong) NSMutableArray<AMapPOI *> * pois;
@property (nonatomic,assign) NSInteger meters;
@end

@implementation RCIMLocationController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.meters = 1;
    self.title = @"位置";
    [self createNavUI];
    self.mapView = [[MAMapView alloc]initWithFrame:self.view.bounds];
    self.mapView.mj_h = 300;
    [self.view addSubview:self.mapView];
    [AMapServices sharedServices].enableHTTPS = YES;
    _mapView.showsUserLocation = YES;
    _mapView.userTrackingMode = MAUserTrackingModeNone;
    _mapView.distanceFilter = kCLLocationAccuracyBest;
    CGRect tableViewFrame = CGRectMake(0, CGRectGetMaxY(self.mapView.frame), self.view.bounds.size.width, CGRectGetMaxY(self.view.frame) - CGRectGetMaxY(self.mapView.frame));
    self.tableView = [[UITableView alloc]initWithFrame:tableViewFrame style:UITableViewStylePlain];
    self.tableView.tableFooterView = [UIView new];
    self.tableView.tableHeaderView = [UIView new];
    [self.view addSubview:self.tableView];
    [self.tableView registerClass:[RCIMLocationTableViewCell class] forCellReuseIdentifier:@"RCIMLocationTableViewCell"];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.currentObj.name = [RCIMLocationManager shareManager].locationReGeocode.AOIName;
    CLLocationCoordinate2D  location = [RCIMLocationManager shareManager].location.coordinate;
    [self.mapView setCenterCoordinate:location animated:YES];
    _mapView.region = MACoordinateRegionMake(_mapView.centerCoordinate, MACoordinateSpanMake(0.01, 0.01));
    self.currentObj.location = CLLocationCoordinate2DMake(location.latitude,location.longitude);
    AMapGeoPoint * mapPoint = [AMapGeoPoint locationWithLatitude:location.latitude longitude:location.longitude];
    self.mapPoint = mapPoint;
    [self loadNearAddressByMeters:self.meters];
  
    
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
    void (^createFooterView)(void) = ^(void)
    {
        self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            [self loadNearAddressByMeters:self.meters++];
        }];
    };
    meters = meters * 100;
    [[RCIMLocationManager shareManager]loadAreasWithAreaName:self.mapPoint withRadious:meters searchAroundAddressBlock:^(AMapPOISearchResponse *response, NSError *error) {
        [self.pois removeAllObjects];
        [self.pois addObjectsFromArray:response.pois];
        [self.tableView reloadData];
        if(!self.tableView.mj_footer)
        {
            createFooterView();
        }
        [self.tableView.mj_footer endRefreshing];
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
    self.currentObj.thumbnailImage = [PPImageUtil imageFromView:self.mapView];
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
    RCIMLocationTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"RCIMLocationTableViewCell"];
    AMapPOI * model = nil;
    if(indexPath.row==0)
    {
        model = [AMapPOI new];
        model.name = [RCIMLocationManager shareManager].locationReGeocode.POIName;
    }else
    {
        model = self.pois[indexPath.row-1];
    }
    cell.area = model;
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.pois.count + ([RCIMLocationManager shareManager].locationReGeocode?1:0);
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if(indexPath.row==0)
    {
        
        self.currentObj.name = [RCIMLocationManager shareManager].locationReGeocode.AOIName;
        CLLocation * location = [RCIMLocationManager shareManager].location;
        self.currentObj.location = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude);
        [self.mapView setCenterCoordinate:location.coordinate animated:YES];
        
    }else
    {
        AMapPOI * model = self.pois[indexPath.row-1];
        [self.mapView setCenterCoordinate:  CLLocationCoordinate2DMake(model.location.latitude, model.location.longitude) animated:YES];
        self.currentObj.name = model.name;
        self.currentObj.location = CLLocationCoordinate2DMake(model.location.latitude, model.location.longitude);
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

@end
