//
//  PPPhotoSeleceOrTakePhotoManager.m
//  rongchat
//
//  Created by vd on 2016/11/24.
//  Copyright © 2016年 vd. All rights reserved.
//

#import "PPPhotoSeleceOrTakePhotoManager.h"
#import <AVFoundation/AVFoundation.h>
#import "SubLBXScanViewController.h"
@interface PPPhotoSeleceOrTakePhotoManager ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (nonatomic,strong) UIImagePickerController * imagePicker;
@end
@implementation PPPhotoSeleceOrTakePhotoManager

singleton_implementation(PPPhotoSeleceOrTakePhotoManager);
- (instancetype)init

{
    self = [super init];
    if(self)
    {
        self = [super init];
        self.imagePicker = [UIImagePickerController new];
        self.imagePicker.delegate = self;
    }
    return self;
}
- (void)takeCaremaController:(UIViewController *)currentController
{
#if !TARGET_IPHONE_SIMULATOR
    [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
        if(granted)
        {
            self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            [currentController presentViewController:self.imagePicker animated:YES completion:nil];
            
        }else
        {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                XIAlertView * alertView  = [[XIAlertView alloc]initWithTitle:@"提示" message:@"前往iphone隐私设置中允许相机访问您的app" cancelButtonTitle:@"取消"];
                [alertView addButtonWithTitle:@"确定" style:XIAlertActionStyleDefault handler:^(XIAlertView *alertView, XIAlertButtonItem *buttonItem) {
                    [alertView dismiss];
                    if([[UIApplication sharedApplication]canOpenURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]])
                    {
                        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
                        
                    }
                }];
                [alertView show];
            });
            
        }
    }];
#else
    NSLog(@"模拟器");
#endif
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    if([self.delegate respondsToSelector:@selector(PPPhotoSeleceOrTakePhotoManagerSelectImage:)])
    {
        [self.delegate PPPhotoSeleceOrTakePhotoManagerSelectImage:[info objectForKey:UIImagePickerControllerOriginalImage]];
    }
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

+ (UIImage *)createQRCode:(NSString *)content imageWidth:(CGFloat)width
{
    
//  return   [LBXScanWrapper createQRWithString:content size:CGSizeMake(width, width)];
    return nil;
}
+ (UIImage*)createQRWithString:(NSString*)text imageWidth:(CGFloat)width QRColor:(UIColor*)qrColor backGroundColor:(UIColor*)bkColor
{
//    return [LBXScanWrapper createQRWithString:text QRSize:CGSizeMake(width, width) QRColor:qrColor bkColor:bkColor];
    return nil;
    
}
+ (UIImage*)imageBlackToTransparent:(UIImage*)image withRed:(CGFloat)red andGreen:(CGFloat)green andBlue:(CGFloat)blue
{
//    return [LBXScanWrapper imageBlackToTransparent:image withRed:red andGreen:green andBlue:blue];
    return nil;
    
}
+ (UIImage*)addImageLogo:(UIImage*)srcImg centerLogoImage:(UIImage*)LogoImage logoSizeWidth:(CGFloat)width;
{
//    return [LBXScanWrapper addImageLogo:srcImg centerLogoImage:LogoImage logoSize:CGSizeMake(width, width)];
    return nil;
}
//推入二维码的扫描控制器
- (void)pushQRCodeController:(UIViewController *)currentController
{
    SubLBXScanViewController * controller = [SubLBXScanViewController new];
    [currentController.navigationController pushViewController:controller animated:YES];
}
@end
