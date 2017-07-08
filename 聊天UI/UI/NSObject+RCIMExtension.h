//
//  NSObject+RCIMExtension.h
//  rongchat
//
//  Created by VD on 2017/7/8.
//  Copyright © 2017年 vd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (RCIMExtension)
- (BOOL)rcim_isCustomMessage;
- (BOOL)rcim_isCustomRCIMMessage;
@end
