//
//  UITableViewCell+category.m
//  rongchat
//
//  Created by VD on 2017/7/10.
//  Copyright © 2017年 vd. All rights reserved.
//

#import "UITableViewCell+category.h"
#import <objc/message.h>
void const * customIdenfierKey = &customIdenfierKey;


@implementation UITableViewCell (category)

- (void)setCustomIdenfier:(NSString *)customIdenfier
{
    objc_setAssociatedObject(self,customIdenfierKey , customIdenfier, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSString *)customIdenfier
{
    return objc_getAssociatedObject(self, customIdenfierKey);
}
@end
