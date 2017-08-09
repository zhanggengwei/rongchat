//
//  RCIMLocationManager.m
//  rongchat
//
//  Created by VD on 2017/8/8.
//  Copyright © 2017年 vd. All rights reserved.
//

#import "RCIMLocationManager.h"

@interface RCIMLocationManager ()<AMapSearchDelegate>
//查询
@property (nonatomic,strong) AMapSearchAPI * searchAPI;
//定位
@property (nonatomic,strong) AMapLocationManager * locationManager;
@property (nonatomic,copy) locationRquestBlock locationBlock;

@property (nonatomic,copy) searchAroundAddressBlock block;

@end

@implementation RCIMLocationManager
+ (instancetype)shareManager
{
    static RCIMLocationManager * manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self.class alloc]init];
    });
    return manager;
}
- (instancetype)init
{
    if(self = [super init])
    {
        self.searchAPI = [AMapSearchAPI new];
        self.searchAPI.delegate = self;
        self.locationManager = [AMapLocationManager new];
    }
    return self;
}

- (void)loadAreasWithAreaName:(AMapGeoPoint *)area withRadious:(NSInteger)radious searchAroundAddressBlock:(searchAroundAddressBlock)block
{
    self.block = block;
    AMapPOIAroundSearchRequest * request = [AMapPOIAroundSearchRequest new];
    request.location = area;
    request.radius = radious;
    [self.searchAPI AMapPOIAroundSearch:request];
}
- (void)requestReGeocodeLocation:(locationRquestBlock)block
{
    self.locationBlock = block;
    [self.locationManager requestLocationWithReGeocode:YES completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
        if(block)
        {
            block(regeocode,error);
        }
        _location = location;
        _locationReGeocode = regeocode;
    }];
    
}
#pragma mark AMapSearchDelegate
- (void)onPOISearchDone:(AMapPOISearchBaseRequest *)request response:(AMapPOISearchResponse *)response
{
    if(_block)
    {
        _block(response,nil);
    }
}
- (void)AMapSearchRequest:(id)request didFailWithError:(NSError *)error
{
    if(_block)
    {
        _block(nil,error);
    }
}

@end
