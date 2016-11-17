//
//  PPTabBarController.h
//  rongchat
//
//  Created by vd on 2016/11/16.
//  Copyright © 2016年 vd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PPTabBarController : UITabBarController
- (instancetype)init:(NSArray *)controllerArray selectImageArr:(NSArray *)imageSelect titleArr:(NSArray *)titleArr normalImageArr:(NSArray *)imageArr;
-(void)showPointMarkIndex:(NSInteger)index;
- (void) hideMarkIndex:(NSInteger)index;
-(void)showBadgeMark:(NSInteger)badge index:(NSInteger)index;
@end
