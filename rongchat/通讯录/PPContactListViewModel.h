//
//  PPContactListViewModel.h
//  rongchat
//
//  Created by VD on 2017/8/24.
//  Copyright © 2017年 vd. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol PPContactListViewModelProtrocal <NSObject>

- (void)didSelectedCell:(id)model;


@end

@interface PPContactListViewModel : NSObject

//@property (nonatomic,strong,readonly) RACSubject * contactListSubject;
@property (nonatomic,strong,readonly) RACSignal * changeSignal;
// 冷信号 被动发生


@end
