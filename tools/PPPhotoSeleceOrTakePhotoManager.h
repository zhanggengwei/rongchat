//
//  PPPhotoSeleceOrTakePhotoManager.h
//  rongchat
//
//  Created by vd on 2016/11/24.
//  Copyright © 2016年 vd. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger,PPPhotoSeleceOrTakePhotoManagerStyle) {
    PPPhotoSeleceOrTakePhotoManagerSelectPhoto,
    PPPhotoSeleceOrTakePhotoManagerTakeCarema
};

@protocol PPPhotoSeleceOrTakePhotoManagerDelegate <NSObject>
@optional
- (void)PPPhotoSeleceOrTakePhotoManagerSelectImage:(UIImage *)image;

@end

@protocol PPPhotoSeleceOrTakePhotoManagerDataSource <NSObject>
@optional
- (void)PPPhotoSeleceOrTakePhotoManagerQRCode:(NSString *)content;

@end

@interface PPPhotoSeleceOrTakePhotoManager : NSObject
singleton_interface(PPPhotoSeleceOrTakePhotoManager);

@property (nonatomic,weak) id<PPPhotoSeleceOrTakePhotoManagerDelegate> delegate;
@property (nonatomic,weak) id<PPPhotoSeleceOrTakePhotoManagerDataSource>dataSource;

- (void)takeCaremaController:(UIViewController *)currentController;


//生成一个二维码 通过 content 字符串
+ (UIImage *)createQRCode:(NSString *)content imageWidth:(CGFloat)width;

// 制定二维码的颜色以及底部的颜色
+ (UIImage*)createQRWithString:(NSString*)text imageWidth:(CGFloat)width QRColor:(UIColor*)qrColor backGroundColor:(UIColor*)bkColor;

// 二维码中心的图片设置
+ (UIImage*)addImageLogo:(UIImage*)srcImg centerLogoImage:(UIImage*)LogoImage logoSizeWidth:(CGFloat)width;
// 给二维码上色
+ (UIImage*)imageBlackToTransparent:(UIImage*)image withRed:(CGFloat)red andGreen:(CGFloat)green andBlue:(CGFloat)blue;



//推入二维码的扫描控制器
- (void)pushQRCodeController:(UIViewController *)currentController;




@end
