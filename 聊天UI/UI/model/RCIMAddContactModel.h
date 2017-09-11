//
//  RCIMAddContactModel.h
//  rongchat
//
//  Created by VD on 2017/9/1.
//  Copyright © 2017年 vd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RCIMAddContactModel : NSObject<RCIMCellModel>
@property (nonatomic,strong) NSString * imageName;
@property (nonatomic,strong) NSString * title;
@property (nonatomic,strong) NSString * detail;
@property (nonatomic,strong) UIViewController * targetController;
@end
