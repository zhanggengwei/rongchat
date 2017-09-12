//
//  RCIMAddressBookCell.h
//  rongchat
//
//  Created by VD on 2017/9/1.
//  Copyright © 2017年 vd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RCContactListCell.h"

@interface RCIMAddressModel :NSObject<RCIMCellModel>
@property (nonatomic,strong) UIViewController * targetController;
@property (nonatomic,strong) RCUserInfoBaseData * user;
@property (nonatomic,assign) BOOL add;
@property (nonatomic,strong) NSString * displayName;
@property (nonatomic,strong) NSString * phone;
@property (nonatomic,strong) NSString * indexChar;
@property (nonatomic,strong) NSString * pinyin;
@end

@interface RCIMAddressBookCell : RCContactListCell
@property (nonatomic,strong) RACSubject * subject;
@end
