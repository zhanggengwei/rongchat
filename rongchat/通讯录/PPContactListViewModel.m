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
#import "RCIMCustomContactListViewModel.h"


@interface PPContactListViewModel ()
@property (nonatomic,strong) NSMutableArray * contactList;
@property (nonatomic,strong) NSArray * headerArray;
@property (nonatomic,strong) RCIMCustomContactListViewModel * viewModel;

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
    self.viewModel = [RCIMCustomContactListViewModel new];
 
    self.subject = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        @weakify(self);
        [self.viewModel.subject subscribeNext:^(id  _Nullable x) {
            @strongify(self);
            [self.contactList removeAllObjects];
            [self.contactList addObject:self.headerArray.firstObject];
            [self.contactList addObjectsFromArray:x];
            [subscriber sendNext:self.contactList];
            [subscriber sendCompleted];
        }];
        return nil;
    }];
    
}

- (void)dealloc
{
    NSLog(@"");
}

- (NSArray *)headerArray
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
    if(_headerArray==nil)
    {
        _headerArray = @[headerArrayBlock()];
    }
    return _headerArray;
}
- (NSMutableArray *)contactList
{
    if(_contactList==nil)
    {
        _contactList = [NSMutableArray new];
    }
    return _contactList;
}

@end
