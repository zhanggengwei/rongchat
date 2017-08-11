//
//  RCIMLocationController.m
//  rongchat
//
//  Created by VD on 2017/7/24.
//  Copyright © 2017年 vd. All rights reserved.
//

#import "RCIMLocationController.h"
#import "RCIMCustomMapView.h"
#import <UIView+MJExtension.h>
#import "PPImageUtil.h"
#import "RCIMLocationManager.h"
#import "RCIMLocationTableViewCell.h"
#import <MJRefresh.h>
#import <UITableView+FDTemplateLayoutCell.h>

@interface RCIMLocationController ()<UITableViewDelegate,UITableViewDataSource,RCIMCustomMapViewDelegate>
@property (nonatomic,strong) RCIMCustomMapView * customMapView;
@property (nonatomic,strong) RCIMLocationObj * currentObj;
@property (nonatomic,strong) UITableView * tableView;
@property (nonatomic,strong) AMapGeoPoint * mapPoint;
@property (nonatomic,strong) NSMutableArray<AMapPOI *> * pois;
@property (nonatomic,assign) NSInteger meters;
@end

@implementation RCIMLocationController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    [self loadAreaData];
    self.meters = 1;
    self.title = @"位置";
    [self loadAreaData];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadAreaData
{
    [AMapServices sharedServices].enableHTTPS = YES;
    
    self.currentObj.name = [RCIMLocationManager shareManager].locationReGeocode.AOIName;
    CLLocationCoordinate2D  location = [RCIMLocationManager shareManager].location.coordinate;
    self.currentObj.location = CLLocationCoordinate2DMake(location.latitude,location.longitude);
    AMapGeoPoint * mapPoint = [AMapGeoPoint locationWithLatitude:location.latitude longitude:location.longitude];
    self.mapPoint = mapPoint;
    [self loadNearAddressByMeters:self.meters];
    MAPointAnnotation * animation = [MAPointAnnotation new];
    animation.coordinate = self.currentObj.location;
    [self addSelectCurrentAnimation:animation];
}

- (void)createUI
{
    [self createNavUI];
    [self.view addSubview:self.customMapView];
    CGRect tableViewFrame = CGRectMake(0, CGRectGetMaxY(self.customMapView.frame), self.view.bounds.size.width, CGRectGetMaxY(self.view.frame) - CGRectGetMaxY(self.customMapView.frame));
    self.tableView = [[UITableView alloc]initWithFrame:tableViewFrame style:UITableViewStylePlain];
    self.tableView.tableFooterView = [UIView new];
    self.tableView.tableHeaderView = [UIView new];
    [self.view addSubview:self.tableView];
    [self.tableView registerClass:[RCIMLocationTableViewCell class] forCellReuseIdentifier:@"RCIMLocationTableViewCell"];
    [self.tableView registerClass:[RCIMLocationCustomTableViewCell class] forCellReuseIdentifier:@"RCIMLocationCustomTableViewCell"];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}

- (RCIMCustomMapView *)customMapView
{
    if(_customMapView == nil)
    {
        _customMapView = [[RCIMCustomMapView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 300)];
        _customMapView.delegate = self;
        
    }
    return _customMapView;
}

- (void)addSelectCurrentAnimation:(id<MAAnnotation>)animation
{
    [self.customMapView addAnimation:animation];
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
    self.currentObj.thumbnailImage = [self.customMapView snapLocationImage];
    if([self.delegate respondsToSelector:@selector(sendLocation:)])
    {
        [self.delegate sendLocation:self.currentObj];
    }
}

- (RCIMShowLocationCell * )loadDataCell:(NSIndexPath *)indexPath withCell:(RCIMShowLocationCell *)cell
{
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


#pragma mark UITableViewDelegate


#pragma makr UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RCIMShowLocationCell * cell = nil;
    if(indexPath.row==0)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:@"RCIMLocationTableViewCell"];
    }else
    {
        cell = [tableView dequeueReusableCellWithIdentifier:@"RCIMLocationCustomTableViewCell"];
    }
    return [self loadDataCell:indexPath withCell:cell];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.pois.count + ([RCIMLocationManager shareManager].locationReGeocode?1:0);
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

   NSString * identifier = indexPath.row==0?@"RCIMLocationTableViewCell":@"RCIMLocationCustomTableViewCell";
   return [tableView fd_heightForCellWithIdentifier:identifier cacheByIndexPath:indexPath configuration:^(RCIMLocationTableViewCell * cell) {
       [self loadDataCell:indexPath withCell:cell];
   }];
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    MAPointAnnotation * animation = [MAPointAnnotation new];
    if(indexPath.row==0)
    {
        self.currentObj.name = [RCIMLocationManager shareManager].locationReGeocode.AOIName;
        CLLocation * location = [RCIMLocationManager shareManager].location;
        self.currentObj.location = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude);
    }else
    {
        AMapPOI * model = self.pois[indexPath.row-1];
        self.currentObj.name = model.name;
        self.currentObj.location = CLLocationCoordinate2DMake(model.location.latitude, model.location.longitude);
    }
    animation.coordinate = self.currentObj.location;
    [self addSelectCurrentAnimation:animation];
}

- (void)mapViewAnimationDidChange:(id<MAAnnotation>)animation
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
