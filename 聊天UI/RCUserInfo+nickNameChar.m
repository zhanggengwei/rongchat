//
//  RCUserInfo+nickNameChar.m
//  rongchat
//
//  Created by vd on 2016/12/8.
//  Copyright © 2016年 vd. All rights reserved.
//

#import "RCUserInfo+nickNameChar.h"
#import <objc/runtime.h>
static NSString const *nickNameChar = @"nickNameChar";


@implementation RCUserInfo (nickNameChar)


- (void)setNickNameChar:(NSString *)nickNameChar
{
    objc_setAssociatedObject(self, (__bridge const void *)(nickNameChar), nickNameChar, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSString * )nickNameChar
{
    return  objc_getAssociatedObject(self, (__bridge const void *)(nickNameChar));
    
}


@end
