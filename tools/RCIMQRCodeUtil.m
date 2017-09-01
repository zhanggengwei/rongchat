//
//  RCIMQRCodeUtil.m
//  rongchat
//
//  Created by VD on 2017/9/1.
//  Copyright © 2017年 vd. All rights reserved.
//

#import "RCIMQRCodeUtil.h"
#import <LBXScan/LBXScanNative.h>


@implementation RCIMQRCodeUtil
+ (void)createQRCodeImage:(NSString *)userId QRImageSize:(CGSize)imageSize block:(createQRCodeImageBlock)block
{
    NSString * qrString = [NSString stringWithFormat:@"RCIM://userId=%@",userId];
    UIImage * image = [LBXScanNative createQRWithString:qrString QRSize:imageSize];
    if(block)
    {
        block(image);
    }
}

+ (void)createQRCodeImage:(NSString *)userId QRImageSize:(CGSize)imageSize block:(createQRCodeImageBlock)block bkColor:(UIColor *)backGroudColor QRColor:(UIColor *)QRColor
{
    NSString * qrString = [NSString stringWithFormat:@"RCIM://userId=%@",userId];
    [LBXScanNative createQRWithString:qrString QRSize:imageSize QRColor:QRColor bkColor:backGroudColor];
}

+ (void)createQRCodeImage:(NSString *)userId QRImageSize:(CGSize)imageSize block:(createQRCodeImageBlock)block backGroudColor:(UIColor *)backGroudColor
{
    
}

@end
