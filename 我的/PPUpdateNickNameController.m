//
//  PPUpdateNickNameController.m
//  rongchat
//
//  Created by Donald on 16/11/30.
//  Copyright © 2016年 vd. All rights reserved.
//

#import "PPUpdateNickNameController.h"

@interface PPUpdateNickNameController ()
@property (nonatomic,strong) UITextField * nickNameTextField;
@end

@implementation PPUpdateNickNameController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.nickNameTextField = [UITextField new];
    [self.view addSubview:self.nickNameTextField];
    
    [self.nickNameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).mas_offset(20);
        make.right.mas_equalTo(self.view.mas_right).mas_offset(-20);
        make.top.mas_equalTo(self.view.mas_top).mas_offset(20);
        make.height.mas_equalTo(30);
        
    }];
    self.nickNameTextField.backgroundColor =  kPPTWhiteColor;
    self.nickNameTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
