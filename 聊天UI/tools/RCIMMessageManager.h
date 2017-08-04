//
//  RCIMMessageManager.h
//  rongchat
//
//  Created by VD on 2017/8/4.
//  Copyright © 2017年 vd. All rights reserved.
//

#import <Foundation/Foundation.h>

- (void)didReceiveMessages:(RCMessage *)message left:(NSInteger)left;


@interface RCIMMessageManager : NSObject

+ (instance)shareManager;

@end
