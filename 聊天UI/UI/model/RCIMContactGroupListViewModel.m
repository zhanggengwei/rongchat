//
//  RCIMContactGroupListViewModel.m
//  rongchat
//
//  Created by VD on 2017/9/11.
//  Copyright © 2017年 vd. All rights reserved.
//

#import "RCIMContactGroupListViewModel.h"
#import "RCIMConversationViewController.h"

@implementation RCIMContactGroupListViewModel
{
    NSMutableArray * _dataSource;
}
- (instancetype)init
{
    if(self = [super init])
    {
        _dataSource = [NSMutableArray new];
        self.subject = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            
            [RACObserve([PPTUserInfoEngine shareEngine],contactGroupList)subscribeNext:^(NSArray<PPTContactGroupModel *> * list) {
                [_dataSource removeAllObjects];
                [list enumerateObjectsUsingBlock:^(PPTContactGroupModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    RCIMContactGroupItemModel * model = [RCIMContactGroupItemModel new];
                    model.model = obj;
                    RCIMConversationViewController * controller = [RCIMConversationViewController new];
                    RCConversation * convesation = [RCConversation new];
                    convesation.conversationType = ConversationType_GROUP;
                    convesation.conversationTitle = obj.group.name;
                    convesation.targetId = obj.group.indexId;
                    controller.conversation = convesation;
                    model.targetController = controller;
                    [_dataSource addObject:model];
                }];
                [subscriber sendNext:_dataSource];
                [subscriber sendCompleted];
            }];
            return nil;
        }];
    }
    return self;
}
@end
