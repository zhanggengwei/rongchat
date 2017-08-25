//
//  PPContactListViewModel.m
//  rongchat
//
//  Created by VD on 2017/8/24.
//  Copyright © 2017年 vd. All rights reserved.
//

#import "PPContactListViewModel.h"

@interface PPContactListViewModel ()
//@property (nonatomic,strong) RACSubject * contactListSubject;
@property (nonatomic,strong) RACSignal * changeSignal;
@property (nonatomic,strong) NSMutableArray * contactList;// @[['A':{}],'B':@{}];
@end

@implementation PPContactListViewModel
- (instancetype)init
{
    if(self = [super init])
    {
        [self loadFriendList];
    }
    return self;
}

- (void)loadFriendList
{
    self.contactList = [NSMutableArray new];
    NSArray * (^indexsContactListBlock)(NSArray<PPUserBaseInfo *> * arr) = ^(NSArray<PPUserBaseInfo *> * arr)
    {
        NSMutableArray * contactlistResults = [NSMutableArray new];
        NSMutableDictionary * results = [NSMutableDictionary new];
        [arr enumerateObjectsUsingBlock:^(PPUserBaseInfo * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if(![results objectForKey:obj.indexChar])
            {
                NSMutableArray * indexContactLists = [NSMutableArray arrayWithObject:obj];
                [results setObject:indexContactLists forKey:obj.indexChar];
            }else
            {
                NSMutableArray * indexContactLists = [results objectForKey:obj.indexChar];
                [indexContactLists addObject:obj];
            }
        }];
        NSArray * indexKeys = [results keysSortedByValueUsingSelector:@selector(compare:)];
        [indexKeys enumerateObjectsUsingBlock:^(NSString * obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSArray<PPUserBaseInfo *> * userInfoArray = results[obj];
            NSArray * sortArray = [userInfoArray sortedArrayUsingComparator:^NSComparisonResult(PPUserBaseInfo *   obj1, PPUserBaseInfo * obj2) {
                return [obj1.nickNameWord compare:obj2.nickNameWord];
            }];
            [contactlistResults addObject:@{obj:sortArray}];
        }];
        return contactlistResults;
    };
    self.changeSignal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        [RACObserve([PPTUserInfoEngine shareEngine], contactList) subscribeNext:^(id  _Nullable x) {
            [subscriber sendNext:indexsContactListBlock([PPTUserInfoEngine shareEngine].contactList)];
            [subscriber sendCompleted];
            
            }];
        return nil;
    }];
    
    
  //  self.contactListSubject = [RACSubject subject];
//    [RACObserve([PPTUserInfoEngine shareEngine], contactList) subscribeNext:^(id  _Nullable x) {
//        [self.contactListSubject sendNext:[PPTUserInfoEngine shareEngine].contactList];
//        [self.contactListSubject sendCompleted];
//    }];
//    //信号的订阅功能 热信号 错过了就错过了 热信号主动调用不需要订阅就能发送消息
//    冷信号被动调用 订阅会发送消息
//    [self.contactListSubject subscribeNext:^(id  _Nullable x) {
//        NSLog(@"x == %@",x);
//    } error:^(NSError * _Nullable error) {
//        NSLog(@"error == %@",error);
//    }];
//    [self.contactListSubject sendNext:[PPTUserInfoEngine shareEngine].contactList];
//    [self.contactListSubject sendCompleted];
    
}
@end
