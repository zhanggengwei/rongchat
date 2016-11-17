//
//  UITextField+UITextField_WJ.h
//  rongChatDemo1
//
//  Created by vd on 2016/11/6.
//  Copyright © 2016年 vd. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WJTextFieldDelegate <UITextFieldDelegate>
@optional
- (void)textFieldDidDeleteBackward:(UITextField *)textField;
@end
@interface UITextField (UITextField_WJ)
@property (weak, nonatomic) id<WJTextFieldDelegate> WJDelegate;
@end
/**
 *  监听删除按钮
 *  object:UITextField
 */
extern NSString * const WJTextFieldDidDeleteBackwardNotification;
