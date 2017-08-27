//
//  PPContactListViewModel.h
//  rongchat
//
//  Created by VD on 2017/8/24.
//  Copyright © 2017年 vd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PPContactListViewModel : NSObject
//联系人列表发生变化
@property (nonatomic,strong,readonly) RACSignal * changeSignal;

@end
