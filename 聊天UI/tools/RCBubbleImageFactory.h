//
//  RCBubbleImageFactory.h
//  rongchat
//
//  Created by VD on 2017/7/8.
//  Copyright © 2017年 vd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RCBubbleImageFactory : NSObject
+ (UIImage *)bubbleImageViewForType:(RCMessageDirection)owner
                        messageType:(NSString *)messageIdentifier
                      isHighlighted:(BOOL)isHighlighted;
@end
