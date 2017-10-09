//
//  PPShowSelectIconViewController.m
//  rongChatDemo1
//
//  Created by Donald on 16/11/8.
//  Copyright © 2016年 vd. All rights reserved.
//

#import "PPShowSelectIconViewController.h"
#import <WActionSheet/NLActionSheet.h>
#import <SFHFKeychainUtils/SFHFKeychainUtils.h>
#import "PPImageUtil.h"
#import "PPPhotoSeleceOrTakePhotoManager.h"
#import "singleton.h"

@interface PPShowSelectIconViewController ()<UIImagePickerControllerDelegate,PPPhotoSeleceOrTakePhotoManagerDelegate>
@property (nonatomic,strong) UIImageView * imageView;
@property (nonatomic,strong) UIImage * uploadImage;

@end

@implementation PPShowSelectIconViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"个人头像";
    
    [self.view addSubview:self.imageView];
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.view.mas_centerY);
        make.width.mas_equalTo(SCREEN_WIDTH);
        make.height.mas_equalTo(SCREEN_WIDTH);
        make.left.mas_equalTo(self.view.mas_left);
        
    }];
    self.view.backgroundColor = [UIColor blackColor];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"icon"] style:UIBarButtonItemStylePlain target:self action:@selector(showImageSelected:)];
    
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIImageView *)imageView
{
    if(_imageView==nil)
    {
        _imageView = [UIImageView new];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        NSString * imageURL = [PPTUserInfoEngine shareEngine].user_Info.user.portraitUri;
        SD_LOADIMAGE(_imageView,[imageURL isValid]?imageURL:@"",nil);
    }
    return _imageView;
}

- (void)showImageSelected:(UIBarButtonItem *)item
{
    NLActionSheet * sheet = [[NLActionSheet alloc]initWithTitle:@"" cancelTitle:@"取消" otherTitles:@[@"拍照",@"从手机相册选择",@"保存图片"]];
    sheet.otherTitlesFont = [UIFont systemFontOfSize:15];
    [sheet showView];
    
    [sheet dismissForCompletionHandle:^(NSInteger clickedIndex, BOOL isCancel) {
        if(clickedIndex==0&&isCancel==NO)
        {
            [self showCarema];
        }else if (clickedIndex == 1&&isCancel == NO)
        {
            [self photoSelect];
        }else if(clickedIndex == 2 && isCancel == NO)
        {
            if(self.imageView.image)
            {
               UIImageWriteToSavedPhotosAlbum(self.imageView.image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
            }else
            {
                
            }
            
            
        }
    }];
     
    
}
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if(error)
    {
        NSLog(@"save imag faild");
    }else
    {
        NSLog(@"sucess");
    }
}
- (void)showCarema
{
    
    PPPhotoSeleceOrTakePhotoManager * manager =[PPPhotoSeleceOrTakePhotoManager sharedPPPhotoSeleceOrTakePhotoManager];
    manager.delegate = self;
    [manager takeCaremaController:self];
    
}

- (void)photoSelect
{
    [self uploadImage:[UIImage imageNamed:@"MoreExpressionShops"]];
}

- (void)uploadImage:(UIImage *)uploadImage
{
    
    self.uploadImage =  [PPImageUtil imageCompressLargeImageToAspectFillScreen:uploadImage];
    self.imageView.image = self.uploadImage;
    [[[PPDateEngine manager]uploadAvatarImage:self.uploadImage]subscribeNext:^(id  _Nullable x) {
        NSLog(@"x====%@",x);
    } error:^(NSError * _Nullable error) {
         NSLog(@"x====%@",error);
    } completed:^{
         NSLog(@"upload finish");
    }];
    
//    [[PPDateEngine manager]requestUploadImageToken:^(PPUploadImageTokenResponse *  aTaskResponse) {
//        NSLog(@"aTaskResponse  == %@",aTaskResponse);
//        if(aTaskResponse.code.integerValue == kPPResponseSucessCode)
//        {
//            PPUploadImageToken * resulst = aTaskResponse.result;
//            NSString * image_token = resulst.token;
//            [[PPDateEngine manager]requsetUploadImageResponse:^(PPHTTPResponse * aTaskResponse) {
//                if(aTaskResponse.code.integerValue == kPPResponseSucessCode)
//                {
//                    NSLog(@"图片上传成功");
//                }
//            } UploadFile:UIImagePNGRepresentation(self.uploadImage) UserId:[SFHFKeychainUtils getPasswordForUsername:kPPUserInfoUserID andServiceName:kPPServiceName error:nil] uploadToken:image_token];
//        }
//    }];
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(nullable NSDictionary<NSString *,id> *)editingInfo NS_DEPRECATED_IOS(2_0, 3_0)
{
   
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    [self uploadImage:[info objectForKey:UIImagePickerControllerOriginalImage]];
    
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}
#pragma mark PPPhotoSeleceOrTakePhotoManagerDelegate

- (void)PPPhotoSeleceOrTakePhotoManagerSelectImage:(UIImage *)image
{
     [self uploadImage:image];
}
@end
