//
//  PPResetPassWordViewController.m
//  chatDemoWDdemo
//
//  Created by 123 on 16/6/9.
//  Copyright © 2016年 123. All rights reserved.
//

#import "PPResetPassWordViewController.h"
#import "RJBackView.h"
#import "UIButton+ButtonThread.h"


@interface PPResetPassWordViewController ()

@property (weak, nonatomic) IBOutlet RJBackView *backView;
@property (weak, nonatomic) IBOutlet UITextField *PassWord;
@property (weak, nonatomic) IBOutlet UIButton *getCodeBtn;
@property (weak, nonatomic) IBOutlet UITextField *numberText;
@property (weak, nonatomic) IBOutlet UITextField *vertifyCode;

@property (weak, nonatomic) IBOutlet UITextField *againPassWord;


@property (strong, nonatomic)  UIButton *backBtn;
@end

@implementation PPResetPassWordViewController

+(instancetype)createRegisterViewController
{
    return [[UIStoryboard storyboardWithName:@"register" bundle:[NSBundle mainBundle]]instantiateViewControllerWithIdentifier:@"PPResetPassWordViewController"];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.backView.layer.cornerRadius = 10;
    self.backView.layer.masksToBounds = YES;
    self.backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.backBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    self.backBtn.frame = CGRectMake(16,35,40,16);
    self.backBtn.titleLabel.font = COMMON_FONT_SIZE;
    [self.backBtn setTitle:@"取消" forState:UIControlStateNormal];
    [self.backBtn setTitleColor:kPPLoginButtonColor forState:UIControlStateNormal];
    [self.backBtn addTarget:self action:@selector(backController:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.backBtn];
    [self.getCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)backController:(id)sender {

    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}





//进行验证码获取的方法
- (IBAction)BtnCodeAction:(id)sender
{

    [[PPDateEngine manager]sendVerifyWithResponse:^(PPHTTPResponse * aTaskResponse) {
        if(aTaskResponse.code.integerValue == kPPResponseSucessCode)
        {
            [self.getCodeBtn startTime];
        }
    } phone:self.numberText.text regionString:@"86"];
    

}
- (IBAction)finishAction:(id)sender
{
    [[PPDateEngine manager]requestJudegeVaildWithResponse:^(PPJudgeVerificationResponse * aTaskResponse) {
        if(aTaskResponse.code.integerValue == kPPResponseSucessCode)
        {
            PPVertifyDef * obj = aTaskResponse.result;
            
            [[PPDateEngine manager]requestResetPassWordResponse:^(id aTaskResponse) {
                
            } resetPassWord:self.PassWord.text verification_token:obj.verification_token];
            
        }
        
    } verfityCode:self.vertifyCode.text region:@"86" phone:self.numberText.text];
    
    
}



@end
