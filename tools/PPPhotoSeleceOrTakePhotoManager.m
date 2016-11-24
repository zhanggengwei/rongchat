//
//  PPPhotoSeleceOrTakePhotoManager.m
//  rongchat
//
//  Created by vd on 2016/11/24.
//  Copyright © 2016年 vd. All rights reserved.
//

#import "PPPhotoSeleceOrTakePhotoManager.h"

@interface PPPhotoSeleceOrTakePhotoManager ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (nonatomic,strong) UIImagePickerController * imagePicker;

@end

@implementation PPPhotoSeleceOrTakePhotoManager
singleton_implementation(PPPhotoSeleceOrTakePhotoManager)

+ (instancetype)shareManager
{
    return [PPPhotoSeleceOrTakePhotoManager sharedPPPhotoSeleceOrTakePhotoManager];
    
}

- (instancetype)init
{
    self = [super init];
    if(self)
    {
        self = [PPPhotoSeleceOrTakePhotoManager new];
        self.imagePicker = [UIImagePickerController new];
        self.imagePicker.delegate = self;
        
        
    }
    return self;
}

- (void)takeCarema
{

}

- (void)selectPhoto
{
    
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}
@end
