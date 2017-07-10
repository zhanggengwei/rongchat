//
//  RCIMCellRegisterController.m
//  rongchat
//
//  Created by VD on 2017/7/10.
//  Copyright © 2017年 vd. All rights reserved.
//

#import "RCIMCellRegisterController.h"

@implementation RCIMCellRegisterController
//
+ (void)registerChatMessageCellClassForTableView:(UITableView *)tableView {
    [RCChatMessageCellMediaTypeDict enumerateKeysAndObjectsUsingBlock:^(NSNumber * _Nonnull mediaType, Class _Nonnull aClass, BOOL * _Nonnull stop) {
        if (mediaType.intValue != -7) {
            [self registerMessageCellClass:aClass ForTableView:tableView];
        }
    }];
    [self registerSystemMessageCellClassForTableView:tableView];
}

+ (void)registerMessageCellClass:(Class)messageCellClass ForTableView:(UITableView *)tableView  {
    NSString *messageCellClassString = NSStringFromClass(messageCellClass);
    UINib *nib = [UINib nibWithNibName:messageCellClassString bundle:nil];
    if([[NSBundle mainBundle] pathForResource:messageCellClassString ofType:@"nib"] != nil) {
        [tableView registerNib:nib forCellReuseIdentifier:[NSString stringWithFormat:@"%@_%@_%@", messageCellClassString, RCCellIdentifierOwnerSelf, RCCellIdentifierGroup]];
        [tableView registerNib:nib forCellReuseIdentifier:[NSString stringWithFormat:@"%@_%@_%@", messageCellClassString, RCCellIdentifierOwnerSelf, RCCellIdentifierSingle]];
        [tableView registerNib:nib forCellReuseIdentifier:[NSString stringWithFormat:@"%@_%@_%@", messageCellClassString, RCCellIdentifierOwnerOther, RCCellIdentifierGroup]];
        [tableView registerNib:nib forCellReuseIdentifier:[NSString stringWithFormat:@"%@_%@_%@", messageCellClassString, RCCellIdentifierOwnerOther , RCCellIdentifierSingle]];
    } else {
        [tableView registerClass:messageCellClass forCellReuseIdentifier:[NSString stringWithFormat:@"%@_%@_%@", messageCellClassString, RCCellIdentifierOwnerSelf, RCCellIdentifierGroup]];
        [tableView registerClass:messageCellClass forCellReuseIdentifier:[NSString stringWithFormat:@"%@_%@_%@", messageCellClassString, RCCellIdentifierOwnerSelf, RCCellIdentifierSingle]];
        [tableView registerClass:messageCellClass forCellReuseIdentifier:[NSString stringWithFormat:@"%@_%@_%@", messageCellClassString, RCCellIdentifierOwnerOther, RCCellIdentifierGroup]];
        [tableView registerClass:messageCellClass forCellReuseIdentifier:[NSString stringWithFormat:@"%@_%@_%@", messageCellClassString, RCCellIdentifierOwnerOther , RCCellIdentifierSingle]];
    }
}

+ (void)registerSystemMessageCellClassForTableView:(UITableView *)tableView {
    [tableView registerClass:[RCChatSystemMessageCell class] forCellReuseIdentifier:@"RCChatSystemMessageCell_LCCKCellIdentifierOwnerSystem_LCCKCellIdentifierSingle"];
    [tableView registerClass:[RCChatSystemMessageCell class] forCellReuseIdentifier:@"RCChatSystemMessageCell_LCCKCellIdentifierOwnerSystem_LCCKCellIdentifierGroup"];
}

@end
