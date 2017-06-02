//
//  CustomView.h
//  rongchat
//
//  Created by Donald on 17/6/2.
//  Copyright © 2017年 vd. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger,CustomViewStyle)
{
    CustomViewCountryStyle,
    CustomViewPhoneStyle,
    CustomViewPassWordStyle
};

@interface LoginModel : NSObject

@property (nonatomic,strong) NSString * countryName;

@property (nonatomic,strong) NSString * contryCode;

@property (nonatomic,strong) NSString * phone;

@property (nonatomic,strong) NSString * passWord;

@property (nonatomic,strong) NSString * placeholderString;

@property  (nonatomic,strong)NSString * content;

@property (nonatomic,strong) NSString * text;


@end

@interface CustomView : UIView

@property (nonatomic,assign)CustomViewStyle style;
@property (nonatomic,strong)LoginModel * model;

@end
