
//
//  RCIMContactGroupQRCodeViewController.m
//  rongchat
//
//  Created by VD on 2017/9/6.
//  Copyright © 2017年 vd. All rights reserved.
//

#import "RCIMContactGroupQRCodeViewController.h"
#import "UIImage+RCIMExtension.h"
#import <GDQrCode/GDQrCode.h>
@interface RCIMContactGroupQRCodeViewController ()

@end

@implementation RCIMContactGroupQRCodeViewController

- (void)viewDidLoad {
    self.name = self.model.name;
    self.placeHolerImage = RCIM_CONTACT_GROUP_ARATARIMAGE;
    self.avatarImageUrl = self.model.portraitUri;
    [super viewDidLoad];
    self.title = @"群二维码名片";
    [self loadImageView:self.imageView];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)loadImageView:(UIImageView *)imageView
{
    NSString * message = [NSString stringWithFormat:@"RCIMCONTACTGROUP://groupId=%@",self.model.indexId];
    [imageView gd_setQRCodeImageWithQRCodeImageSize:100 qrCodeImageColor:[UIColor orangeColor] qrCodeBgImageColor:[UIColor clearColor] centerImage:nil placeholderImage:nil codeMessage:message];
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
