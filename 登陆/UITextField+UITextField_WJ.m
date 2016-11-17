//
//  UITextField+UITextField_WJ.m
//  rongChatDemo1
//
//  Created by vd on 2016/11/6.
//  Copyright © 2016年 vd. All rights reserved.
//

//UITextField+WJ.m
#import "UITextField+UITextField_WJ.h"

#import <objc/runtime.h>

NSString * const WJDelegateString = @"WJDelegate";

NSString * const WJTextFieldDidDeleteBackwardNotification = @"com.whojun.textfield.did.notification";
@implementation UITextField (UITextField_WJ)

@dynamic WJDelegate;
/*
 - (void)setRy_time:(NSTimeInterval)ry_time{
 objc_setAssociatedObject(self, RY_CLICKKEY, @(ry_time), OBJC_ASSOCIATION_ASSIGN);
 
 }
 - (NSTimeInterval)ry_time{
 return [objc_getAssociatedObject(self, RY_CLICKKEY) doubleValue];
 
 }
 */
- (void)setWJDelegate:(id<WJTextFieldDelegate>)WJDelegate
{
    objc_setAssociatedObject(self, (__bridge const void *)(WJDelegateString), WJDelegate, OBJC_ASSOCIATION_ASSIGN);
}

- (id<WJTextFieldDelegate>)WJDelegate
{
    return  objc_getAssociatedObject(self, (__bridge const void *)(WJDelegateString));
}

+ (void)load {
    //交换2个方法中的IMP
    Method method1 = class_getInstanceMethod([self class], NSSelectorFromString(@"deleteBackward"));
    Method method2 = class_getInstanceMethod([self class], @selector(wj_deleteBackward));
    method_exchangeImplementations(method1, method2);
}

- (void)wj_deleteBackward {
    if([self.text isEqualToString:@"+"])
    {
        return;
    }
    [self wj_deleteBackward];
    
    if ([self.WJDelegate respondsToSelector:@selector(textFieldDidDeleteBackward:)])
    {
        id <WJTextFieldDelegate> delegate  = (id<WJTextFieldDelegate>)self.WJDelegate;
        [delegate textFieldDidDeleteBackward:self];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:WJTextFieldDidDeleteBackwardNotification object:self];
}
@end
