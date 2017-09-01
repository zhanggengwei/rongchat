//
//  RCIMQRCodeUtil.h
//  rongchat
//
//  Created by VD on 2017/9/1.
//  Copyright © 2017年 vd. All rights reserved.
//
typedef void(^createQRCodeImageBlock)(UIImage * image);
#import <Foundation/Foundation.h>

@interface RCIMQRCodeUtil : NSObject

+ (void)createQRCodeImage:(NSString *)userId QRImageSize:(CGSize)imageSize block:(createQRCodeImageBlock)block;


+ (void)createQRCodeImage:(NSString *)userId QRImageSize:(CGSize)imageSize block:(createQRCodeImageBlock)block backGroudColor:(UIColor *)backGroudColor;

+ (void)createQRCodeImage:(NSString *)userId QRImageSize:(CGSize)imageSize block:(createQRCodeImageBlock)block backGroudColor:(UIColor *)backGroudColor;


@end
