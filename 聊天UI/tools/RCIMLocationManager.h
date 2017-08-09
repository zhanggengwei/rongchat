//
//  RCIMLocationManager.h
//  rongchat
//
//  Created by VD on 2017/8/8.
//  Copyright © 2017年 vd. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^searchAroundAddressBlock)(AMapPOISearchResponse * response,NSError * error);//周边搜索的查询
typedef void(^locationRquestBlock)(AMapLocationReGeocode * response,NSError * error);//周边搜索的查询

@interface RCIMLocationManager : NSObject

+ (instancetype)shareManager;

@property (nonatomic,strong,readonly) AMapLocationReGeocode * locationReGeocode;
@property (nonatomic,strong,readonly) CLLocation * location;

#pragma makr 位置信息页面

- (void)loadAreasWithAreaName:(AMapGeoPoint *)area withRadious:(NSInteger)radious searchAroundAddressBlock:(searchAroundAddressBlock)block;

#pragma makr 请求定位

- (void)requestReGeocodeLocation:(locationRquestBlock)block;


@end
