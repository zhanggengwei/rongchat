//
//  RCIMConversationModel.m
//  rongchat
//
//  Created by VD on 2017/9/6.
//  Copyright © 2017年 vd. All rights reserved.
//

#import "RCIMConversationModel.h"

@implementation RCIMConversationModel
- (RACSignal *)loadDataConversation:(RCConversation *)conversation
{
    RACSignal * signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        if(conversation.conversationType == ConversationType_GROUP)
        {
          [[[PPTUserInfoEngine shareEngine]getContactGroupByGroupId:conversation.targetId]subscribeNext:^(RCContactGroupData * model) {
              RCIMConversationModel * data = [RCIMConversationModel new];
              _avatarUrl = model.portraitUri;
              _title = model.name;
              _message = @"";
              [subscriber sendNext:data];
              [subscriber sendCompleted];
          }];
        }
        else
        {
            
        }
        return nil;
    }];
    return signal;
}
@end
