//
//  RCIMContactGroupListViewModel.m
//  rongchat
//
//  Created by VD on 2017/9/11.
//  Copyright © 2017年 vd. All rights reserved.
//

#import "RCIMContactGroupListViewModel.h"
#import "RCIMConversationViewController.h"


@interface RCIMContactGroupListViewModel ()
@property (nonatomic,strong) NSMutableArray * dataSource;
@end

@implementation RCIMContactGroupListViewModel

- (instancetype)init
{
    if(self = [super init])
    {
        self.subject = [RACSubject subject];
        @weakify(self);
        [RACObserve([PPTUserInfoEngine shareEngine],contactGroupList)subscribeNext:^(NSArray<PPTContactGroupModel *> * list) {
            @strongify(self);
                [self.dataSource removeAllObjects];
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
                [self.subject sendNext:_dataSource];
                [self.subject sendCompleted];
            }];
        
    }
    return self;
}

- (NSMutableArray *)dataSource
{
    if(_dataSource==nil)
    {
        _dataSource = [NSMutableArray new];
    }
    return _dataSource;
}
- (void)dealloc
{
    NSLog(@"deallloc %@",[self class]);
}


@end
