//
//  RCIMLocationController.h
//  rongchat
//
//  Created by VD on 2017/7/24.
//  Copyright © 2017年 vd. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RCIMLocationControllerDelegate <NSObject>

- (void)cancelLocation;
- (void)sendLocation:(CLPlacemark *)placemark;

@end

@interface RCIMLocationController : UIViewController

@property (nonatomic,weak) id<RCIMLocationControllerDelegate> delegate;


@end
