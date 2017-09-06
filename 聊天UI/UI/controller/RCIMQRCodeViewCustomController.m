//
//  RCIMQRCodeViewCustomController.m
//  rongchat
//
//  Created by VD on 2017/9/6.
//  Copyright © 2017年 vd. All rights reserved.
//

#import "RCIMQRCodeViewCustomController.h"
#import "UIImage+RCIMExtension.h"
#import <GDQrCode/GDQrCode.h>
#import "UIImage+RCIMExtension.h"
#import <NLActionSheet.h>
#import "PPImageUtil.h"

typedef NS_ENUM(NSUInteger,QRCodeStyle) {
    QRCodeStyleCustom1,
    QRCodeStyleCustom2,
    QRCodeStyleCustom3
};
@interface RCIMQRCodeViewCustomController ()
@property (nonatomic,assign) QRCodeStyle style;
@end

@implementation RCIMQRCodeViewCustomController

- (void)viewDidLoad {
    self.title = @"我的二维码";
    self.style = QRCodeStyleCustom1;
    self.name = [PPTUserInfoEngine shareEngine].user_Info.user.name;
    self.extraText = @"扫一扫二维码加为好友";
    self.avatarImageUrl = [PPTUserInfoEngine shareEngine].user_Info.user.portraitUri;
    self.placeHolerImage = RCIM_PLACE_ARATARIMAGE;
    [super viewDidLoad];
    @weakify(self);
    [RACObserve(self, style) subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [self loadImageStyle:[x integerValue] imageView:self.imageView];
    }];
    UIImage * moreImage = [UIImage RCIM_imageNamed:@"barbuttonicon_more" bundleName:@"BarButtonIcon" bundleForClass:nil];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:moreImage style:UIBarButtonItemStylePlain target:self action:@selector(showSheetView)];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)showSheetView
{
    
    void (^changeQRCodeStyle)(void) = ^(void)
    {
        self.style = ++self.style%3;
    };
    void (^saveQRCodeImage)(void) = ^(void)
    {
        UIImage * saveImage =[PPImageUtil imageFromView:self.contentView];
        UIImageWriteToSavedPhotosAlbum(saveImage, self, @selector(imageSavedToPhotosAlbum:didFinishSavingWithError:contextInfo:), NULL);
    };
    NLActionSheet * sheetView = [[NLActionSheet alloc]initWithTitle:@"" cancelTitle:@"取消" otherTitles:@[@"换个样式",@"保存图片",@"扫描二维码"]];
    sheetView.otherTitlesFont = [UIFont systemFontOfSize:15];
    [sheetView showView];
    [sheetView dismissForCompletionHandle:^(NSInteger clickedIndex, BOOL isCancel) {
        if(!isCancel)
        {
            if(clickedIndex==0)
            {
                changeQRCodeStyle();
            }else if (clickedIndex==1)
            {
                saveQRCodeImage();
            }else if (clickedIndex==2)
            {
                
            }else
            {
                
            }
        }
    }];
}

- (void)imageSavedToPhotosAlbum:(UIImage*)image didFinishSavingWithError:  (NSError*)error contextInfo:(id)contextInfo
{
    NSLog(@"save sucessed");
}
- (void)loadImageStyle:(QRCodeStyle)style imageView:(UIImageView *)imageView
{
    
    NSString * message = [NSString stringWithFormat:@"RCIMCONTACT://userId=%@",[PPTUserInfoEngine shareEngine].userId];
    switch (style) {
        case QRCodeStyleCustom1:
        {
            [imageView gd_setQRCodeImageWithQRCodeImageSize:100 qrCodeImageColor:[UIColor orangeColor] qrCodeBgImageColor:[UIColor clearColor] centerImage:nil placeholderImage:nil codeMessage:message];
            break;
        }
        case QRCodeStyleCustom2:
        {
            [imageView gd_setQRCodeImageWithQRCodeImageSize:100 qrCodeImageColor:[UIColor redColor] qrCodeBgImageColor:[UIColor blackColor] centerImage:nil placeholderImage:nil codeMessage:message];
            break;
        }
        case QRCodeStyleCustom3:
        {
            [imageView gd_setQRCodeImageWithQRCodeImageSize:100 qrCodeImageColor:[UIColor yellowColor] qrCodeBgImageColor:[UIColor blackColor] centerImage:nil placeholderImage:nil codeMessage:message];
            break;
        }
        default:
            break;
    }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
