//
//  PPLocationManager.h
//  rongchat
//
//  Created by vd on 2016/11/21.
//  Copyright © 2016年 vd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PPLocationManager : NSObject

@property (nonatomic,strong,readonly) AMapLocationReGeocode * regeoCode;
+(instancetype)shareManager;
-(void)requestLocation;



@end
