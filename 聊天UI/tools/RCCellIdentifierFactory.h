//
//  RCCellIdentifierFactory.h
//  rongchat
//
//  Created by VD on 2017/7/8.
//  Copyright © 2017年 vd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RCCellIdentifierFactory : NSObject

+ (NSString *)cellIdentifierForMessageConfiguration:(RCMessage *)message conversationType:(RCConversationType)conversationType;

+ (NSString *)cacheKeyForMessage:(id)message;
@end
