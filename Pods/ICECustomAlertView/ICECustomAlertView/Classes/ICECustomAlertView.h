//
//  ICECustomAlertView.h
//  ICEAlertView
//
//  Created by WLY on 16/6/1.
//  Copyright © 2016年 ICE. All rights reserved.
//
/**
 *  暂不支持按钮数大于2
 *  暂不支持屏幕旋转
 */


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/**
 *  提示框类型
 */
typedef NS_ENUM(NSInteger, ICEAlertViewStyle) {
    /**
     *  自定义提示内容
     */
    ICEAlertViewStyleCustom = 0,
    /**
     *  显示上下两个标题
     */
     ICEAlertViewStyleDefault,
    /**
     *  输入框类型
     */
     ICEAlertViewStyleTitle  = ICEAlertViewStyleDefault,
};

typedef void(^ICEAlertViewCompletionBlock) (NSInteger index);

@interface ICECustomAlertView : NSObject





/**
 *  展示 自定义界面
 *
 *  @param customView   提示内容视图, 当 custom 的 bounds存在时, 当前弹出视图的大小即为 custom 的大小
 */
+ (void)alertViewWithCustomView:(nonnull UIView *)customView;


/**
 *  标题类提示框
 *
 *  @param title        标题
 *  @param message      提示内容
 *  @param buttontitles 按钮标题
 *  @param completion   回调
 */
+ (void)alertViewWithTitle:(nullable NSString *)title
               withMessage:(nullable NSString *)message
          withButtonTitles:(nullable NSArray  *)buttontitles
                completion:(nullable ICEAlertViewCompletionBlock)completion;


/**
 *  标题类提示框
 *
 *  @param message      提示内容
 *  @param buttontitles 按钮标题
 *  @param completion   回调
 */
+ (void)alertViewWithMessage:(nullable NSString *)message
          withButtonTitles:(nullable NSArray  *)buttontitles
                completion:(nullable ICEAlertViewCompletionBlock)completion;




@end
