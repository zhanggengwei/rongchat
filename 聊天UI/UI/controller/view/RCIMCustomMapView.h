//
//  RCIMCustomMapView.h
//  rongchat
//
//  Created by VD on 2017/8/11.
//  Copyright © 2017年 vd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MAMapKit/MAMapKit.h>

@protocol RCIMCustomMapViewDelegate <NSObject>

- (void)mapViewAnimationDidChange:(id<MAAnnotation>)animation;


@end

@interface RCIMCustomMapView : UIView

@property (nonatomic,weak) id<RCIMCustomMapViewDelegate>delegate;

- (void)addAnimation:(id<MAAnnotation>)animation;
- (UIImage *)snapLocationImage;


@end
