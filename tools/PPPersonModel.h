//
//  PPAddressModel.h
//  PPAddressBook
//
//  Created by AndyPang on 16/8/17.
//  Copyright © 2016年 AndyPang. All rights reserved.
//



#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface PPPersonModel :  PPDataDef

/** 联系人姓名*/
@property (nonatomic, copy) NSString *name;


/** 联系人电话数组,因为一个联系人可能存储多个号码*/
@property (nonatomic, strong) NSMutableArray *mobileArray;
/** 联系人头像*/
@property (nonatomic, strong) UIImage *headerImage;

@property (nonatomic, strong) NSString * nickName;

@property (nonatomic,strong) NSString * phone;

@property (nonatomic,strong) NSString * avatulUrl;

@property (nonatomic,assign) BOOL isFriend;

@property (nonatomic,strong) NSString * indexTitles;//A,B,...

@property (nonatomic,strong) NSString * identify;


@end
