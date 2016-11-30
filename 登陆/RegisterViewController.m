//
//  RegisterViewController.m
//  chatDemoWDdemo
//
//  Created by 123 on 16/6/9.
//  Copyright © 2016年 123. All rights reserved.
//

#import "RegisterViewController.h"
#import "RJBackView.h"
#import "UIButton+ButtonThread.h"


@interface RegisterViewController ()

@property (weak, nonatomic) IBOutlet RJBackView *backView;
@property (weak, nonatomic) IBOutlet UITextField *PassWord;
@property (weak, nonatomic) IBOutlet UIButton *getCodeBtn;
@property (weak, nonatomic) IBOutlet UITextField *numberText;
@property (strong, nonatomic)  UIButton *backBtn;
@end

@implementation RegisterViewController

+(instancetype)createRegisterViewController
{
    return [[UIStoryboard storyboardWithName:@"register" bundle:[NSBundle mainBundle]]instantiateViewControllerWithIdentifier:@"RegisterViewController"];
    
}


- (IBAction)backController:(id)sender {

    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}





//进行验证码获取的方法
- (IBAction)BtnCodeAction:(id)sender {
    
//    if([self.RJNumberTextField.text checkPhoneNumInput]){
//        //进行 手机的注册
    [self.getCodeBtn startTime];
//    [RJRequestSoap postRequestUrl:@"18863014571" andParater:nil  andSucess:^(NSData *data) {
//   
//        
//        
//    } andFailed:^(NSError *error) {
//        
//    }];
    

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
    [self.view addSubview:self.backBtn];
    [self.getCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)registerBtn:(id)sender {
    
    

    
}



@end
