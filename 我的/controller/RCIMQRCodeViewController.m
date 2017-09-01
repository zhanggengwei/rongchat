//
//  RCIMQRCodeViewController.m
//  rongchat
//
//  Created by VD on 2017/9/1.
//  Copyright © 2017年 vd. All rights reserved.
//

#import "RCIMQRCodeViewController.h"

@interface RCIMQRCodeViewController ()
@property (nonatomic,strong) UIView * contentView;
@property (nonatomic,strong) UIView * QRCodeView;
@end

@implementation RCIMQRCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的二维码";
    self.view.backgroundColor = [UIColor colorWithRed:50/255.0 green:52/255.0 blue:53/255.0 alpha:1];
    [self.view addSubview:self.contentView];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view).insets(UIEdgeInsetsMake(60, 20, 60, 20));
    }];
    
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
        _QRCodeView.backgroundColor = [UIColor orangeColor];
    }
    return _QRCodeView;
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
