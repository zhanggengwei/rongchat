//
//  NSString+MD5.m
//  rongChatDemo1
//
//  Created by Donald on 16/11/7.
//  Copyright © 2016年 vd. All rights reserved.
//

#import "NSString+MD5.h"
#import "Md5.h"

@implementation NSString (MD5)
- (NSString *)md5
{
    if(self.length==0 || self == nil)
    {
        return @"";
    }
    return [Md5 encode:self];
    
}
@end
