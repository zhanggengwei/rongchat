//
//  RCIMAddressViewModel.m
//  rongchat
//
//  Created by VD on 2017/9/12.
//  Copyright © 2017年 vd. All rights reserved.
//

#import "RCIMAddressViewModel.h"
#import <APAddressBook.h>
#import <APContact.h>
#import "RCIMObjPinYinHelper.h"
#import "RCIMObjPinYinHelper.h"
#import "RCIMAddressBookCell.h"


@interface RCIMAddressViewModel ()
@property (nonatomic,strong) APAddressBook * addressBook;
@property (nonatomic,strong) NSArray * indextitles;
@property (nonatomic,strong) NSMutableArray * data;
@end

@implementation RCIMAddressViewModel

- (instancetype)init
{
    if(self = [super init])
    {
        [self loadAddressBookList];
    }
    return self;
}

- (APAddressBook *)addressBook
{
    if(_addressBook==nil)
    {
        _addressBook = [APAddressBook new];
    }
    return _addressBook;
}
- (void)loadAddressBookList
{
    NSMutableDictionary * dict = [NSMutableDictionary new];
    [self.addressBook requestAccessOnQueue:dispatch_queue_create("adressQueue", DISPATCH_QUEUE_CONCURRENT) completion:^(BOOL granted, NSError * _Nullable error) {
        if(granted)
        {
            [self.addressBook loadContacts:^(NSArray<APContact *> * _Nullable contacts, NSError * _Nullable error) {
                dispatch_group_t group =  dispatch_group_create();
                [contacts enumerateObjectsUsingBlock:^(APContact * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    dispatch_group_enter(group);
                    NSString * name = obj.name.compositeName;
                    RCIMAddressModel * model = [RCIMAddressModel new];
                    model.displayName = name;
                    model.phone = obj.phones.firstObject.number;
                    [[RCIMObjPinYinHelper converNameToPinyin:name]subscribeNext:^(NSString * index) {
                        model.indexChar = index;
                        NSArray * contactList = [dict objectForKey:index];
                        if (contactList==nil) {
                            contactList = [NSArray new];
                            contactList = @[model];
                        }else
                        {
                            contactList = [contactList arrayByAddingObject:model];
                        }
                        [dict setObject:contactList forKey:index];
                        dispatch_group_leave(group);
                    }];
                }];
                dispatch_group_notify(group, dispatch_get_main_queue(), ^{
                    NSMutableArray * lastArray = [NSMutableArray new];
                    BOOL flag = NO;
                    for (NSString * key in [dict.allKeys sortedArrayUsingSelector:@selector(compare:)]) {
                        if([key isEqualToString:@"#"])
                        {
                            flag = YES;
                        }
                        NSDictionary * contactDict = @{key:[dict objectForKey:key]};
                        [lastArray addObject:contactDict];
                    };
                    if(flag)
                    {
                        NSArray *firstIndexs = lastArray.firstObject;
                        [lastArray removeObject:firstIndexs];
                        [lastArray addObject:firstIndexs];
                    }
                    self.data = lastArray;
                    [self.subject sendNext:self.data];
                    [self.subject sendCompleted];
                });
            }];
        }
    }];
}

- (NSMutableArray *)data
{
    if(_data==nil)
    {
        _data = [NSMutableArray new];
    }
    return _data;
}
- (RACSubject *)subject
{
    if(_subject==nil)
    {
        _subject = [RACSubject subject];
    }
    return _subject;
}
@end
