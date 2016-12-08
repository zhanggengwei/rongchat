//
//  NSString+isValid.m
//  rongchat
//
//  Created by vd on 2016/12/8.
//  Copyright © 2016年 vd. All rights reserved.
//

#import "NSString+isValid.h"

@implementation NSString (isValid)
-(BOOL)isValid
{
    if(self.length == 0 || self ==nil)
    {
        return NO;
    }
    return YES;
}
@end
