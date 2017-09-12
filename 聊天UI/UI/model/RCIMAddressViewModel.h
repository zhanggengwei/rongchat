//
//  RCIMAddressViewModel.h
//  rongchat
//
//  Created by VD on 2017/9/12.
//  Copyright © 2017年 vd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RCIMAddressViewModel : NSObject
@property (nonatomic,strong) RACSubject * subject;
@property (nonatomic,strong,readonly) NSMutableArray * data;
@end
