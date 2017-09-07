//
//  RCIMObjPinYinHelper.h
//  rongchat
//
//  Created by VD on 2017/9/1.
//  Copyright © 2017年 vd. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^convertBlock)(NSString *);

@interface RCIMObjPinYinHelper : NSObject

+ (RACSignal *)converNameToPinyin:(NSString *)name;

@end
