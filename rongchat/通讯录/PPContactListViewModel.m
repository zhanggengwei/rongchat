//
//  PPContactListViewModel.m
//  rongchat
//
//  Created by VD on 2017/8/24.
//  Copyright © 2017年 vd. All rights reserved.
//

#import "PPContactListViewModel.h"
#import "RCIMNewContactListViewController.h"
#import "RCIMPublicServiceViewController.h"
#import "RCIMContactGroupListViewController.h"
#import "RCIMContactGroupDetilsViewController.h"
#import "RCIMContactDetailsViewController.h"

@interface PPContactListViewModel ()

@property (nonatomic,strong) RACSignal * changeSignal;
@property (nonatomic,strong) NSMutableArray * contactList;
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
    NSDictionary * (^headerArrayBlock)(void) = ^(void)
    {
        NSMutableArray * source = [NSMutableArray new];
        NSArray * array = @[@"新的朋友",@"群聊",@"标签",@"公众号"];
        NSArray * imageArray = @[@"plugins_FriendNotify",@"add_friend_icon_addgroup",@"Contact_icon_ContactTag",@"add_friend_icon_offical"];
        NSArray  * targerControllerArray = @[[RCIMNewContactListViewController class],[RCIMContactGroupListViewController class],[RCIMContactGroupListViewController class],[RCIMPublicServiceViewController class]];
        [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            RCIMContactListModelItem *  item = [RCIMContactListModelItem new];
            item.model = [RCUserInfoData new];
            item.model.user = [RCUserInfoBaseData new];
            item.model.user.name = obj;
            item.placeImage = imageArray[idx];
            item.targetController = [targerControllerArray[idx] new];
            [source addObject:item];
        }];
        return @{@"":source};
    };

    self.contactList = [NSMutableArray new];
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
        [contactlistResults insertObject:headerArrayBlock() atIndex:0];
        return  contactlistResults;
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

- (void)dealloc
{
    NSLog(@"");
}

@end
