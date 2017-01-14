//
//  UIView+RCIMExtension.h
//  ChatKit
//
//  v0.8.5 Created by ElonChan (微信向我报BUG:chenyilong1010) on 16/6/2.
//  Copyright © 2016年 LeanCloud. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^RCIMViewActionBlock)(UIView *subview);

@interface UIView (RCIMExtension)

- (NSMutableArray*)lcck_allSubViews;

- (void)lcck_logViewHierarchy:(RCIMViewActionBlock)viewActionBlcok;

@end
