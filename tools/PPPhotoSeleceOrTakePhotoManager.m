//
//  PPPhotoSeleceOrTakePhotoManager.m
//  rongchat
//
//  Created by vd on 2016/11/24.
//  Copyright © 2016年 vd. All rights reserved.
//

#import "PPPhotoSeleceOrTakePhotoManager.h"
#import <AVFoundation/AVFoundation.h>
#import <WQQrCode/WQQRCode.h>

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

+ (void)createQRCode:(NSString *)content imageSize:(CGFloat)size response:(PPResponseBlock())aResponseBlock;
{
//    pod 'WQQrCode', '~> 0.0.2'
    [WQQRCode qr_CodeWithString:content imageSize:size qrCodeImageCompletionHandle:^(UIImage *qrCodeImage) {
        aResponseBlock(qrCodeImage);
        
    }];
}

@end
