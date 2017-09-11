//
//  RCIMContactGroupListViewModel.h
//  rongchat
//
//  Created by VD on 2017/9/11.
//  Copyright © 2017年 vd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RCIMContactGroupListViewModel : NSObject

@property (nonatomic,strong) RACSubject * subject;
@property (nonatomic,strong,readonly) NSMutableArray * dataSource;
@end
