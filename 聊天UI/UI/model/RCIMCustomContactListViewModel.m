//
//  RCIMContactListViewModel.m
//  rongchat
//
//  Created by VD on 2017/9/11.
//  Copyright © 2017年 vd. All rights reserved.
//

#import "RCIMCustomContactListViewModel.h"
#import "RCIMContactDetailsViewController.h"

@interface RCIMCustomContactListViewModel ()
@end

@implementation RCIMCustomContactListViewModel

- (instancetype)init
{
    if(self = [super init])
    {
        [self loadContactList];
    }
    return self;
}
- (void)loadContactList
{
    _contactList = [NSMutableArray new];
    NSArray * (^indexsContactListBlock)(NSArray<RCUserInfoData *> * arr) = ^(NSArray<RCUserInfoData *> * arr)
    {
        NSMutableArray * contactlistResults = [NSMutableArray new];
        NSMutableDictionary * results = [NSMutableDictionary new];
        [arr enumerateObjectsUsingBlock:^(RCUserInfoData * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            RCIMContactListModelItem * item = [RCIMContactListModelItem new];
            item.model = obj;
            item.enabled = YES;
            RCIMContactDetailsViewController * targetController = [RCIMContactDetailsViewController new];
            item.targetController = targetController;
            if(![results objectForKey:obj.user.indexChar])
            {
                NSMutableArray * indexContactLists = [NSMutableArray arrayWithObject:item];
                [results setObject:indexContactLists forKey:obj.user.indexChar];
            }else
            {
                NSMutableArray * indexContactLists = [results objectForKey:obj.user.indexChar];
                [indexContactLists addObject:item];
            }
        }];
        NSArray * indexKeys = [[results allKeys]sortedArrayUsingSelector:@selector(compare:)];
        [indexKeys enumerateObjectsUsingBlock:^(NSString * obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSArray<RCIMContactListModelItem *> * userInfoArray = results[obj];
            NSArray * sortArray = [userInfoArray sortedArrayUsingComparator:^NSComparisonResult(RCIMContactListModelItem *   obj1, RCIMContactListModelItem * obj2) {
                return [obj1.model.user.nickNameWord compare:obj2.model.user.nickNameWord];
            }];
            [contactlistResults addObject:@{obj:sortArray}];
        }];
        return  contactlistResults;
    };
    self.subject = [RACSubject subject];
    @weakify(self);
    [RACObserve([PPTUserInfoEngine shareEngine], contactList) subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [_contactList removeAllObjects];
        [_contactList addObjectsFromArray:indexsContactListBlock([PPTUserInfoEngine shareEngine].contactList)];
        [self.subject sendNext:_contactList];
        [self.subject sendCompleted];
    }];
    [_contactList addObjectsFromArray:indexsContactListBlock([PPTUserInfoEngine shareEngine].contactList)];
}
@end
