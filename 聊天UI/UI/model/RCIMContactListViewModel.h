//
//  RCIMContactListViewModel.h
//  rongchat
//
//  Created by VD on 2017/9/11.
//  Copyright © 2017年 vd. All rights reserved.
//

#import <Foundation/Foundation.h>

//联系人好友发生变化的viewModel
@interface RCIMContactListViewModel : NSObject

@property (nonatomic,strong,readonly) RACSignal * changeSignal;

@end
