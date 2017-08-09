//
//  RCIMLocationObj.h
//  rongchat
//
//  Created by VD on 2017/8/9.
//  Copyright © 2017年 vd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RCIMLocationObj : NSObject
@property (nonatomic,strong) NSString * name;
@property (nonatomic,assign) CLLocationCoordinate2D location;
@property (nonatomic,strong) UIImage * thumbnailImage;

@end
