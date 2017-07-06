//
//  RCContentView.m
//  rongchat
//
//  Created by VD on 2017/7/6.
//  Copyright © 2017年 vd. All rights reserved.
//

#import "RCContentView.h"

@implementation RCContentView

- (instancetype)init {
    if (self = [super init]) {
        CAShapeLayer *maskLayer = [CAShapeLayer layer];
        maskLayer.fillColor = [UIColor grayColor].CGColor;
        maskLayer.contentsCenter = CGRectMake(.7f, .7f, .1f, .1f);
        maskLayer.contentsScale = [UIScreen mainScreen].scale;
        self.layer.mask = maskLayer;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.maskView.frame = CGRectInset(self.bounds, 0, 0);
}

- (void)layoutSublayersOfLayer:(CALayer *)layer {
    [super layoutSublayersOfLayer:layer];
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    self.layer.mask.frame = CGRectInset(self.bounds, 0, 0);
    [CATransaction commit];
}

@end
