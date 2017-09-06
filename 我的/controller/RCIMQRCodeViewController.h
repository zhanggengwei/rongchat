//
//  RCIMQRCodeViewController.h
//  rongchat
//
//  Created by VD on 2017/9/1.
//  Copyright © 2017年 vd. All rights reserved.
//

#import "PPBaseViewController.h"

@interface RCIMQRCodeViewController : PPBaseViewController
@property (nonatomic,strong,readonly) UIView * contentView;
@property (nonatomic,strong,readonly) UIView * QRCodeView;
@property (nonatomic,strong,readonly) UIImageView * imageView;
@property (nonatomic,strong) NSString * qrCodeString;
@property (nonatomic,strong) NSString * extraText;
@property (nonatomic,strong) NSString * name;
@property (nonatomic,strong) NSString * avatarImageUrl;
@property (nonatomic,strong) UIImage * placeHolerImage;

@end
