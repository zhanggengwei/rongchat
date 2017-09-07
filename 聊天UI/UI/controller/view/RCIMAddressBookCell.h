//
//  RCIMAddressBookCell.h
//  rongchat
//
//  Created by VD on 2017/9/1.
//  Copyright © 2017年 vd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RCContactListCell.h"

@interface RCIMAddressModel : NSObject
@property (nonatomic,strong) NSString * userName;
@property (nonatomic,strong) NSString * userId;
@property (nonatomic,strong) NSString * name;
@property (nonatomic,strong) NSString * pinyin;
@property (nonatomic,strong) NSString * indexChar;
@property (nonatomic,strong) NSString * phone;
@property (nonatomic,assign) BOOL add;
@property (nonatomic,strong) NSString * portraitUri;

@end

@interface RCIMAddressBookCell : RCContactListCell
@property (nonatomic,strong) RACSignal * clickSignal;
@end
