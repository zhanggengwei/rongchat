//
//  PPLocationManager.m
//  rongchat
//
//  Created by vd on 2016/11/21.
//  Copyright © 2016年 vd. All rights reserved.
//

#import "PPLocationManager.h"

@interface PPLocationManager ()<AMapSearchDelegate>

@property (nonatomic,strong) AMapLocationReGeocode * regeoCode;
@property (nonatomic,strong) AMapLocationManager * manager;
@property (nonatomic,strong) AMapSearchAPI * searchApi;
@end

@implementation PPLocationManager

+(instancetype)shareManager
{
    static PPLocationManager * shareInstance;
    
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        shareInstance = [[self alloc]init];
        shareInstance.searchApi = [AMapSearchAPI new];
        shareInstance.searchApi.delegate = shareInstance;
        
        [shareInstance requestAllCountry];
        
        
    });
    return shareInstance;
}

-(void)requestLocation
{
    self.manager = [AMapLocationManager new];
    [_manager requestLocationWithReGeocode:YES completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
        if(error==nil)
        {
            self.regeoCode = regeocode;
            
        }
    }];
    
}
- (void)requestAllCountry
{
    AMapPOIKeywordsSearchRequest * searchRequest = [AMapPOIKeywordsSearchRequest new];
    searchRequest.keywords = @"世界";
    [self.searchApi AMapPOIKeywordsSearch:searchRequest];
    
}
- (void)onGeocodeSearchDone:(AMapGeocodeSearchRequest *)request response:(AMapGeocodeSearchResponse *)response
{
    NSLog(@"re%@",response);
}
- (void)AMapSearchRequest:(id)request didFailWithError:(NSError *)error
{
    NSLog(@"error == %@",error);
    self.regeoCode = [AMapLocationReGeocode new];
    
}

- (void)onPOISearchDone:(AMapPOISearchBaseRequest *)request response:(AMapPOISearchResponse *)response
{
    if (response.pois.count == 0)
    {
        return;
    }
    
    //解析response获取POI信息，具体解析见 Demo
}
@end
