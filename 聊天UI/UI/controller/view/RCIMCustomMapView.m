//
//  RCIMCustomMapView.m
//  rongchat
//
//  Created by VD on 2017/8/11.
//  Copyright © 2017年 vd. All rights reserved.
//

#import "RCIMCustomMapView.h"
#import <MAMapKit/MAMapKit.h>
@interface RCIMCustomMapView ()<MAMapViewDelegate>
@property (nonatomic,strong) MAMapView * mapView;
@property (nonatomic,strong) RCIMLocationObj * currentObj;
@property (nonatomic,strong) id<MAAnnotation>  currentAnimation;
@end

@implementation RCIMCustomMapView

- (instancetype)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        [self createUI];
    }
    return self;
}
- (instancetype)init
{
    if(self = [super init])
    {
        [self createUI];
    }
    return self;
}

- (void)createUI
{
    [self addSubview:self.mapView];
    self.mapView.frame = self.bounds;
}

- (MAMapView *)mapView
{
    if(_mapView==nil)
    {
        _mapView = [[MAMapView alloc]initWithFrame:self.bounds];
        _mapView.delegate = self;
    }
    return _mapView;
}

- (void)addAnimation:(id<MAAnnotation>)animation
{
    if(self.currentAnimation)
    {
        [self.mapView removeAnnotation:self.currentAnimation];
    }
    self.currentAnimation = animation;
    self.currentObj.location = animation.coordinate;
    [_mapView setCenterCoordinate:animation.coordinate animated:YES];
    _mapView.region = MACoordinateRegionMake(_mapView.centerCoordinate, MACoordinateSpanMake(0.01, 0.01));
    [self.mapView addAnnotation:animation];
}

- (RCIMLocationObj *)currentObj
{
    if(_currentObj == nil)
    {
        _currentObj = [RCIMLocationObj new];
    }
    return _currentObj;
}

- (UIImage *)snapLocationImage
{
    return [self.mapView takeSnapshotInRect:self.mapView.frame];
}

#pragma mark MAMapViewDelegate
- (MAAnnotationView*)mapView:(MAMapView *)mapView viewForAnnotation:(id <MAAnnotation>)annotation
{
    if([annotation isKindOfClass:[MAPointAnnotation class]])
    {
        MAAnnotationView * view = [mapView dequeueReusableAnnotationViewWithIdentifier:@"MAAnnotationView"];
        MAPointAnnotation * animation = self.currentAnimation;
        if(view==nil)
        {
            view = [[MAAnnotationView alloc]initWithAnnotation:animation reuseIdentifier:@"MAAnnotationView"];
            
        }else
        {
            view= [mapView dequeueReusableAnnotationViewWithIdentifier:@"MAAnnotationView"];
        }
        view.draggable = YES;
        [view setAnnotation:animation];
        view.image = [UIImage imageNamed:@"redPin"];
        return view;
    }
    return nil;
}
- (void)mapView:(MAMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    [mapView removeAnnotation:self.currentAnimation];
    self.currentAnimation.coordinate = mapView.centerCoordinate;
    [self.mapView addAnnotation:self.currentAnimation];
    if([self.delegate respondsToSelector:@selector(mapViewAnimationDidChange:)])
    {
        [self.delegate mapViewAnimationDidChange:self.currentAnimation];
    }
}
@end
