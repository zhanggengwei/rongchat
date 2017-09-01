//
//  RCIMQRCodeViewController.m
//  rongchat
//
//  Created by VD on 2017/9/1.
//  Copyright © 2017年 vd. All rights reserved.
//


typedef NS_ENUM(NSUInteger,QRCodeStyle) {
    QRCodeStyleCustom1,
    QRCodeStyleCustom2,
    QRCodeStyleCustom3
};
#import "RCIMQRCodeViewController.h"
#import <GDQrCode/GDQrCode.h>
#import "UIImage+RCIMExtension.h"
#import <NLActionSheet.h>
#import "PPImageUtil.h"

@interface RCIMQRCodeViewController ()
@property (nonatomic,strong) UIView * contentView;
@property (nonatomic,strong) UIView * QRCodeView;
@property (nonatomic,assign) QRCodeStyle style;
@end

@implementation RCIMQRCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的二维码";
    self.view.backgroundColor = [UIColor colorWithRed:50/255.0 green:52/255.0 blue:53/255.0 alpha:1];
    [self.view addSubview:self.contentView];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.mas_equalTo(self.view);
        make.width.mas_equalTo(300);
        make.height.mas_equalTo(390);
    }];
    self.style = QRCodeStyleCustom1;
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

- (UIView *)contentView
{
    if(_contentView==nil)
    {
        _contentView = [UIView new];
        _contentView.backgroundColor = [UIColor whiteColor];
        _contentView.layer.cornerRadius = 4;
        _contentView.layer.masksToBounds = YES;
        UIImageView * avatarImageView = [UIImageView new];
        [_contentView addSubview:avatarImageView];
        [avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_contentView).mas_offset(20);
            make.top.mas_equalTo(_contentView).mas_offset(20);
            make.width.height.mas_equalTo(50);
        }];
        
        UILabel * nameLabel = [UILabel new];
        [_contentView addSubview:nameLabel];
        nameLabel.font = [UIFont systemFontOfSize:14];
        [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(avatarImageView).mas_offset(4);
            make.left.mas_equalTo(avatarImageView.mas_right).mas_equalTo(10);
            make.right.mas_equalTo(_contentView.mas_right).mas_offset(-10);
        }];
        nameLabel.text = [PPTUserInfoEngine shareEngine].user_Info.user.name;
        SD_LOADIMAGE(avatarImageView, [PPTUserInfoEngine shareEngine].user_Info.user.portraitUri, nil);
        UILabel * bottomLabel = [UILabel new];
        bottomLabel.text = @"扫一扫上面的二维码的图案,加我为好友";
        bottomLabel.textAlignment = NSTextAlignmentCenter;
        bottomLabel.textColor = UIColorFromRGB(0xa2a2a2);
        bottomLabel.font = [UIFont systemFontOfSize:12];
        [_contentView addSubview:bottomLabel];
        [bottomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.mas_equalTo(_contentView);
            make.height.mas_equalTo(40);
        }];
        [_contentView addSubview:self.QRCodeView];
        [self.QRCodeView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_contentView.mas_left).mas_offset(20);
            make.right.mas_equalTo(_contentView.mas_right).mas_offset(-20);
            make.top.mas_equalTo(avatarImageView.mas_bottom).mas_offset(20);
            make.bottom.mas_equalTo(bottomLabel.mas_top);
        }];
    }
    return _contentView;
}

- (UIView *)QRCodeView
{
    if(_QRCodeView==nil)
    {
        _QRCodeView = [UIView new];
        UIImageView * imageView = [UIImageView new];
        [_QRCodeView addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.centerY.mas_equalTo(_QRCodeView);
        }];
        @weakify(self);
        [RACObserve(self, style) subscribeNext:^(id  _Nullable x) {
            @strongify(self);
            [self loadImageStyle:[x integerValue] imageView:imageView];
        }];
        
        
    }
    return _QRCodeView;
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
