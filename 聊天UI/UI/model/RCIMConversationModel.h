//
//  RCIMConversationModel.h
//  rongchat
//
//  Created by VD on 2017/9/6.
//  Copyright © 2017年 vd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RCIMConversationModel : NSObject

@property (nonatomic,strong,readonly) NSString * title;
@property (nonatomic,strong,readonly) NSString * avatarUrl;
@property (nonatomic,strong,readonly) NSString * message;

- (RACSignal *)loadDataConversation:(RCConversation *)conversation;


@end
