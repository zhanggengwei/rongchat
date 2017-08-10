//
//  RCIMAnimation.h
//  rongchat
//
//  Created by VD on 2017/8/10.
//  Copyright © 2017年 vd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MAMapKit/MAMapKit.h>
@interface RCIMAnimation : NSObject<MAAnnotation>
///标注view中心坐标
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;


///获取annotation标题
@property (nonatomic, readonly, copy) NSString *title;

///获取annotation副标题
@property (nonatomic, readonly, copy) NSString *subtitle;

- (void)setCoordinate:(CLLocationCoordinate2D)newCoordinate;
@end
