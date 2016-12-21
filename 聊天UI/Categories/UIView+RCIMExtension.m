//
//  UIView+RCIMExtension.m
//  ChatKit
//
//  v0.8.5 Created by ElonChan (微信向我报BUG:chenyilong1010) on 16/6/2.
//  Copyright © 2016年 LeanCloud. All rights reserved.
//

#import "UIView+RCIMExtension.h"

@implementation UIView (RCIMExtension)

- (NSMutableArray*)lcck_allSubViews {
    NSMutableArray *allSubViews = [[NSMutableArray alloc] init];
    [allSubViews addObject:self];
    for (UIView *subview in self.subviews) {
        [allSubViews addObjectsFromArray:(NSArray*)[subview lcck_allSubViews]];
    }
    return allSubViews;
}

- (void)lcck_logViewHierarchy:(RCIMViewActionBlock)viewActionBlcok {
    //view action block - freedom to the caller
    viewActionBlcok(self);
    for (UIView *subview in self.subviews) {
        [subview lcck_logViewHierarchy:viewActionBlcok];
    }
}

@end
