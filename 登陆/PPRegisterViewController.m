//
//  PPRegisterViewController.m
//  rongChatDemo1
//
//  Created by vd on 2016/11/5.
//  Copyright © 2016年 vd. All rights reserved.
//

#import "PPRegisterViewController.h"
#import "PPLoginTableViewCell.h"
#import <UIImage+YYWebImage.h>
#import <WActionSheet/NLActionSheet.h>
#import "PPResetPassWordViewController.h"

@interface PPRegisterViewController ()<UITableViewDelegate,UITableViewDataSource,PPLoginTableViewCellDelegate>
@property (nonatomic,strong) UITableView * tableView;
@property (nonatomic,strong) NSString * acount;
@property (nonatomic,strong) NSString * passWord;
@property (nonatomic,strong) UITextField * textfiled;
@property (nonatomic,strong) RACSignal * userNameSignal;
@property (nonatomic,strong) RACSignal * passWordSignal;
@end

@implementation PPRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    self.userNameSignal = RACObserve(self,acount);
    self.passWordSignal = RACObserve(self,passWord);
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)createUI{
    
    [self.view addSubview:self.tableView];
    [self createCancelButton];
}

- (void)createCancelButton
{
    UIButton * cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelButton.frame = CGRectMake(8,36,50, 30);
    [cancelButton setTitleColor:[UIColor colorWithRed:104/255.0 green:187/255.0 blue:30/255.0 alpha:1] forState:UIControlStateNormal];
    cancelButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:cancelButton];
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    @weakify(self);
    [[cancelButton rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
}

- (UILabel *)createHeaderLabel
{
    UILabel * createHeaderLabel;
    createHeaderLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0,self.view.frame.size.width, 0)];
    createHeaderLabel.font = [UIFont systemFontOfSize:18];
    createHeaderLabel.text = @"使用手机号码注册";
    createHeaderLabel.textAlignment = NSTextAlignmentCenter;
    
    return createHeaderLabel;
}

- (UIView *)createFooterView
{
    UIView * footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0,SCREEN_WIDTH, 0)];
    UIButton * registerButton = [self createRegisterButton];
    [footerView addSubview:registerButton];
    [registerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(footerView.mas_top).mas_offset(20);
        make.left.mas_equalTo(footerView.mas_left).mas_offset(31);
        make.right.mas_equalTo(footerView.mas_right).mas_offset(-31);
        make.height.mas_equalTo(40);
    }];
    
    return footerView;
}


- (UIButton *)createRegisterButton
{
    UIButton *registerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [registerButton setBackgroundImage:[UIImage yy_imageWithColor:kPPLoginButtonDisableColor] forState:UIControlStateDisabled];
    [registerButton setBackgroundImage:[UIImage yy_imageWithColor:kPPLoginButtonColor] forState:UIControlStateNormal];
    registerButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [registerButton setTitle:@"注册" forState:UIControlStateNormal];
    registerButton.enabled = NO;
    [[registerButton rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(__kindof UIControl * _Nullable x) {
         //register
    }];
    RAC(registerButton,enabled)=[RACSignal combineLatest:@[self.userNameSignal,self.passWordSignal] reduce:^id (NSString * account,NSString * passWord){
        return @(account&&passWord);
    }];
    return registerButton;
}

- (UITableView *)tableView
{
    if(_tableView==nil)
    {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH,300) style:UITableViewStyleGrouped];
        [_tableView registerClass:[PPLoginTableViewCell class] forCellReuseIdentifier:@"PPLoginTableViewCell"];
        _tableView.scrollEnabled = NO;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.tableFooterView = [UIView new];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    }
    return _tableView;
}

- (void)cancelAction:(UIBarButtonItem *)sender
{
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PPLoginTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"PPLoginTableViewCell"];
    
    if(indexPath.row==0)
    {
        [cell layoutLeftContent:@"国家/地区" content:@"中国" andStyle:PPLoginTableViewCellDefault];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }else if(indexPath.row == 1)
    {
        [cell layoutLeftContent:@"+86" content:@"请填写手机号码" andStyle:PPLoginTableViewCellTextField];
    }else if (indexPath.row==2)
    {
        [cell layoutLeftContent:@"验证码" content:@"请填写验证码" andStyle:PPLoginTableViewCellNotLine];
    }
    else
    {
        [cell layoutLeftContent:@"密码" content:@"请填写密码" andStyle:PPLoginTableViewCellNotLine];
    }
    cell.delegate = self;
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  4;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return  [self  createHeaderLabel];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return  60;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return  80;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return  [self createFooterView];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    self.editing = YES;
}
- (void)loginActionPassWord:(NSString *)passWord style:(PPLoginTableViewCellStyle)astyle
{
    
}
- (void)textFieldChange:(NSString *)text style:(PPLoginTableViewCellStyle)astyle
{
    if(astyle == PPLoginTableViewCellTextField)
    {
        self.acount = text;
        //帐号
    }else if (astyle == PPLoginTableViewCellNotLine)
    {
        //密码
        self.passWord = text;
    }
}
#pragma mark loginMethod

- (void)loginAction:(id)sender
{
    [PPIndicatorView  showLoadingInView:self.view];
    [[[PPDateEngine manager]loginCommandWithUserName:self.acount passWord:self.passWord region:@"86"]subscribeNext:^(PPUserInfoTokenResponse * response) {
        if(response.code.integerValue == kPPResponseSucessCode)
        {
            [[PPTUserInfoEngine shareEngine]loginSucessed:response];
            [[NSNotificationCenter defaultCenter]postNotificationName:RCIMLoginSucessedNotifaction object:nil];
            
            [PPIndicatorView showString:@"登录成功"];
        }else
        {
            [PPIndicatorView showString:response.message];
        }
    } error:^(NSError * _Nullable error) {
    }];
}
@end
