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
+ (void)createQRCode:(NSString *)content imageSize:(CGFloat)size response:(PPResponseBlock())aResponseBlock;






//推入二维码的扫描控制器
- (void)pushQRCodeController:(UIViewController *)currentController;




@end
