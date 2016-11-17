//
//  PPViewUtil.m
//  PPDate
//
//  Created by 郭远强 on 16/3/11.
//  Copyright © 2016年 郭远强. All rights reserved.
//

#import "PPViewUtil.h"

@implementation PPViewUtil

#pragma mark - 屏幕操作

+ (CGFloat)screenWidth
{
    return [UIScreen mainScreen].bounds.size.width;
}

+ (CGFloat)screenHeight
{
    return [UIScreen mainScreen].bounds.size.height;
}

+ (CGFloat)statusBarHeight
{
    return 20.0;
}

+ (NSString *)iphoneDeviceVersion
{
    if ([[UIDevice currentDevice] systemVersion].floatValue > 8.0) {
        if ( ABS([[UIScreen mainScreen] nativeBounds].size.height/[[UIScreen mainScreen] nativeScale] - 667.0f) < 0.0001)
        {
            return DEVICE_IPHONE_6;
        }
        else if ( ABS([[UIScreen mainScreen] nativeBounds].size.height/[[UIScreen mainScreen] nativeScale] - 736.0f) < 0.0001)
        {
            return DEVICE_IPHONE_6PLUS;
        }
        else
        {
            return DEVICE_IPHONE_5;
        }
        
    }
    else
    {
        if ( ABS([[UIScreen mainScreen] bounds].size.height/[[UIScreen mainScreen] scale] - 667.0f) < 0.0001)
        {
            return DEVICE_IPHONE_6;
        }
        else if ( ABS([[UIScreen mainScreen] bounds].size.height/[[UIScreen mainScreen] scale] - 736.0f) < 0.0001)
        {
            return DEVICE_IPHONE_6PLUS;
        }
        else
        {
            return DEVICE_IPHONE_5;
        }
        
    }
}

+ (BOOL)isRetinaScreen
{
    CGFloat scale = [UIScreen mainScreen].scale;
    return scale !=1.0;
}

+ (UIInterfaceOrientation)curOrientation
{
    return [[UIApplication sharedApplication] statusBarOrientation];
}

+ (BOOL)isPortrait
{
    return UIInterfaceOrientationIsPortrait([[UIApplication sharedApplication] statusBarOrientation]);
}

+ (UIWindow *)mainWindow
{
    return [[UIApplication sharedApplication].delegate window];
}

+ (UIWindow *)keyWindow
{
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel >= UIWindowLevelAlert)
    {
        window = [[UIApplication sharedApplication].delegate window];
    }
    return window;
}

+ (CGFloat)curHeight
{
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    if (UIInterfaceOrientationIsPortrait(orientation))
    {
        return [self screenHeight];
    }
    else
    {
        return [self screenWidth];
    }
}

+ (CGFloat)curWidth
{
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    if (UIInterfaceOrientationIsPortrait(orientation))
    {
        return [self screenWidth];
    }
    else {
        return [self screenHeight];
    }
}


#pragma mark - 视图操作

+ (UISwipeGestureRecognizer *)addSwipeRightGestureForView:(UIView *)aView target:(id)target action:(SEL)action
{
    UISwipeGestureRecognizer *swipeR = nil;
    if (aView) {
        swipeR = [[UISwipeGestureRecognizer alloc] initWithTarget:target action:action];
        [swipeR setDirection:UISwipeGestureRecognizerDirectionRight];
        [aView addGestureRecognizer:swipeR];
    }
    return swipeR;
}

+ (UISwipeGestureRecognizer *)addSwipeLeftGestureForView:(UIView *)aView target:(id)target action:(SEL)action
{
    UISwipeGestureRecognizer *swipeL = nil;
    if (aView) {
        swipeL = [[UISwipeGestureRecognizer alloc] initWithTarget:target action:action];
        [swipeL setDirection:UISwipeGestureRecognizerDirectionLeft];
        [aView addGestureRecognizer:swipeL];
    }
    return swipeL;
}

+ (UITapGestureRecognizer *)addSingleTapGestureForView:(UIView *)aView target:(id)target action:(SEL)action
{
    UITapGestureRecognizer *tap = nil;
    if (aView) {
        tap = [[UITapGestureRecognizer alloc] initWithTarget:target action:action];
        [aView addGestureRecognizer:tap];
        [aView setUserInteractionEnabled:YES];
    }
    return tap;
}

+ (UITapGestureRecognizer *)addDoubleTapGestureForView:(UIView *)aView target:(id)target action:(SEL)action
{
    UITapGestureRecognizer *tap = nil;
    if (aView) {
        tap = [[UITapGestureRecognizer alloc] initWithTarget:target action:action];
        [tap setNumberOfTapsRequired:2];
        [aView addGestureRecognizer:tap];
        [aView setUserInteractionEnabled:YES];
    }
    return tap;
}
+ (void)removeAllGestureOfView:(UIView *)aView
{
    while (aView.gestureRecognizers.count >0) {
        UIGestureRecognizer *gesture = aView.gestureRecognizers.lastObject;
        [aView removeGestureRecognizer:gesture];
    }
}

+ (void)extentView:(UIView *)view byOffsetX:(CGFloat)offset
{
    CGRect frame = view.frame;
    frame.size.width += offset;
    view.frame = frame;
}

+ (void)extentView:(UIView *)view byOffsetY:(CGFloat)offset
{
    CGRect frame = view.frame;
    frame.size.height += offset;
    view.frame = frame;
}

+ (void)translateView:(UIView *)view byOffsetY:(CGFloat)offset
{
    CGRect frame = view.frame;
    frame.origin.y += offset;
    view.frame = frame;
}

+ (void)translateView:(UIView *)view byOffsetX:(CGFloat)offset
{
    CGRect frame = view.frame;
    frame.origin.x += offset;
    view.frame = frame;
}

+ (void)resetView:(UIView *)aView ofWidth:(CGFloat)aWidth
{
    CGRect frame = aView.frame;
    frame.size.width = aWidth;
    aView.frame = frame;
}

+ (void)resetView:(UIView *)aView ofHeight:(CGFloat)aHeight
{
    CGRect frame = aView.frame;
    frame.size.height = aHeight;
    aView.frame = frame;
}

+ (void)translateView:(UIView *)aView toPoint:(CGPoint)aPoint
{
    CGRect frame = aView.frame;
    frame.origin = aPoint;
    aView.frame = frame;
}

+ (void)translateView:(UIView *)aView fromView:(UIView *)aFromView byOffsetX:(CGFloat)offset
{
    CGFloat x = CGRectGetMaxX(aFromView.frame);
    CGPoint origin = aView.frame.origin;
    origin.x = x + offset;
    [self translateView:aView toPoint:origin];
}

+ (void)translateView:(UIView *)aView fromView:(UIView *)aFromView byOffsetY:(CGFloat)offset
{
    CGFloat y = CGRectGetMaxY(aFromView.frame);
    CGPoint origin = aView.frame.origin;
    origin.y = y + offset;
    [self translateView:aView toPoint:origin];
}

+ (CGRect)viewBoundRect
{
    CGRect rect = CGRectZero;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        rect = [[UIScreen mainScreen] bounds];
    }
    else {
        rect = [[UIScreen mainScreen] applicationFrame];
    }
    return rect;
}

+ (CGSize)sizeWithString:(NSString *)aString font:(UIFont *)aFont constrainedToSize:(CGSize)aSize lineBreakMode:(NSLineBreakMode)aLineBreakMode
{
    CGSize returnSize = CGSizeZero;
    if ([[[UIDevice currentDevice] systemVersion] floatValue]>=7.0) {
        CGSize boundedSize = [aString boundingRectWithSize:aSize options: NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:aFont} context:nil].size;
        returnSize.width = ceilf(boundedSize.width);
        returnSize.height = ceilf(boundedSize.height);
    }else{
#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wdeprecated-declarations"
        returnSize = [aString sizeWithFont:aFont constrainedToSize:aSize lineBreakMode:aLineBreakMode];
#pragma clang diagnostic pop
    }
    return returnSize;
    
}

+ (void)showAlertViewWithMessage:(NSString *)message withDelegate:(id)delegate
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alertView.delegate = delegate;
    [alertView show];
}

+ (UIImageView *)findSeperatorImageView:(UIView *)view
{
    if ([view isKindOfClass:UIImageView.class] && view.bounds.size.height <= 1.0) {
        return (UIImageView *)view;
    }
    
    for (UIView *subview in view.subviews) {
        UIImageView *imageView = [PPViewUtil findSeperatorImageView:subview];
        if (imageView) {
            return imageView;
        }
    }
    return nil;
}

@end
