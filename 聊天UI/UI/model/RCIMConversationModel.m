//
//  RCIMConversationModel.m
//  rongchat
//
//  Created by VD on 2017/9/6.
//  Copyright © 2017年 vd. All rights reserved.
//

#import "RCIMConversationModel.h"
#import "UIImage+RCIMExtension.h"

@implementation RCIMConversationModel
- (RACSignal *)loadDataConversation:(RCConversation *)conversation
{
    RACSignal * signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        if(conversation.conversationType == ConversationType_GROUP)
        {
          [[[PPTUserInfoEngine shareEngine]getContactGroupByGroupId:conversation.targetId]subscribeNext:^(RCContactGroupData * model) {
              RCIMConversationModel * data = [RCIMConversationModel new];
              data.avatarUrl = model.portraitUri;
              data.title = model.name;
              data.placeHolerImage =RCIM_CONTACT_GROUP_ARATARIMAGE;
              [subscriber sendNext:data];
              [subscriber sendCompleted];
          }];
        }
        else
        {
            [[[PPTUserInfoEngine shareEngine]getUserInfoByUserId:conversation.targetId]subscribeNext:^(RCUserInfoData * model) {
                 RCIMConversationModel * data = [RCIMConversationModel new];
                data.avatarUrl = model.user.portraitUri;
                data.title = model.user.name;
                data.placeHolerImage =RCIM_PLACE_ARATARIMAGE;
                [subscriber sendNext:data];
                [subscriber sendCompleted];
            }];
            
        }
        return nil;
    }];
    return signal;
}
@end
