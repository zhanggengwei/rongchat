//
//  PPViewUtil.h
//  PPDate
//
//  Created by 郭远强 on 16/3/11.
//  Copyright © 2016年 郭远强. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define PPLoadNib(aNibName) [[[NSBundle mainBundle] loadNibNamed:aNibName owner:nil options:nil] objectAtIndex:0]
#define PPLoadNibAndOwner(aNibName,aOwner) [[[NSBundle mainBundle] loadNibNamed:aNibName owner:aOwner options:nil] objectAtIndex:0]

#define DEVICE_IPHONE_5 @"device_iphone5"
#define DEVICE_IPHONE_6 @"device_iphone6"
#define DEVICE_IPHONE_6PLUS @"device_iphone6PLUS"

@interface PPViewUtil : NSObject

#pragma mark - 屏幕操作
+ (CGFloat)screenWidth;
+ (CGFloat)screenHeight;
+ (CGFloat)statusBarHeight;
+ (BOOL)isRetinaScreen;
+ (NSString *)iphoneDeviceVersion;
+ (UIInterfaceOrientation)curOrientation;
+ (BOOL)isPortrait;
+ (UIWindow *)keyWindow;
+ (UIWindow *)mainWindow;

#pragma mark - 视图操作

+ (UITapGestureRecognizer *)addSwipeRightGestureForView:(UIView *)aView target:(id)target action:(SEL)action;
+ (UITapGestureRecognizer *)addSwipeLeftGestureForView:(UIView *)aView target:(id)target action:(SEL)action;
+ (UITapGestureRecognizer *)addSingleTapGestureForView:(UIView *)view target:(id)target action:(SEL)action;
+ (UITapGestureRecognizer *)addDoubleTapGestureForView:(UIView *)aView target:(id)target action:(SEL)action;
+ (void)showAlertViewWithMessage:(NSString *)message withDelegate:(id)delegate;

#pragma mark - view调整
+ (void)extentView:(UIView *)aView byOffsetX:(CGFloat)offset;
+ (void)extentView:(UIView *)aView byOffsetY:(CGFloat)offset;
+ (void)translateView:(UIView *)aView byOffsetY:(CGFloat)offset;
+ (void)translateView:(UIView *)aView byOffsetX:(CGFloat)offset;
+ (void)translateView:(UIView *)aView toPoint:(CGPoint)aPoint;
+ (void)translateView:(UIView *)aView fromView:(UIView *)aFromView byOffsetX:(CGFloat)offset;
+ (void)translateView:(UIView *)aView fromView:(UIView *)aFromView byOffsetY:(CGFloat)offset;

#pragma mark - 其他
// 删除view中的所有手势
+ (void)removeAllGestureOfView:(UIView *)aView;

+ (CGSize)sizeWithString:(NSString *)aString font:(UIFont *)aFont constrainedToSize:(CGSize)aSize lineBreakMode:(NSLineBreakMode)aLineBreakMode;

//查找view
+ (UIImageView *)findSeperatorImageView:(UIView *)view;
@end
