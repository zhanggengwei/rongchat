//
//  PPIndicatorView.h
//  PPDate
//
//  Created by 郭远强 on 16/3/11.
//  Copyright © 2016年 郭远强. All rights reserved.
//

#import <MBProgressHUD/MBProgressHUD.h>

@interface PPIndicatorView : MBProgressHUD

+ (PPIndicatorView *)showString:(NSString *)aString;

+ (PPIndicatorView *)showString:(NSString *)aString duration:(NSUInteger)aDuration;

//loading
+ (PPIndicatorView *)showLoading;

+ (void)hideLoading;

+ (PPIndicatorView *)showLoadingInView:(UIView *)aView;

+ (void)hideLoadingInView:(UIView *)aView;

+ (PPIndicatorView *)showCustomView:(UIView *)aCustomView inView:(UIView *)aView;


@end
