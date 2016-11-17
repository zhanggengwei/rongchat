//
//  PPTool.h
//  rongChatDemo1
//
//  Created by vd on 2016/10/29.
//  Copyright © 2016年 vd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PPTool : NSObject
+ (CGSize)sizeWithString:(NSString *)aString font:(UIFont *)aFont constrainedToSize:(CGSize)aSize lineBreakMode:(NSLineBreakMode)aLineBreakMode;
@end
