//
//  PPPhotoSeleceOrTakePhotoManager.m
//  rongchat
//
//  Created by vd on 2016/11/24.
//  Copyright © 2016年 vd. All rights reserved.
//

#import "PPPhotoSeleceOrTakePhotoManager.h"
#import <AVFoundation/AVFoundation.h>
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
            
             LCAlertView * alertView  = [[LCAlertView alloc]initWithTitle:@"提示" message:@"前往iphone隐私设置中允许相机访问您的app" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
             alertView.alertAnimationStyle=LCAlertAnimationFlipHorizontal;
             
             
             [alertView show];
             alertView.alertAction = ^(NSInteger index)
             {
                 if(index==1)
                 {
                     if([[UIApplication sharedApplication]canOpenURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]])
                     {
                         [[UIApplication sharedApplication]openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
                         
                     }
                 }
             };
             
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
@end
