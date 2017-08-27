//
//  PPLoginViewController.m
//  rongChatDemo1
//
//  Created by vd on 2016/11/5.
//  Copyright © 2016年 vd. All rights reserved.
//

#import "PPLoginViewController.h"
#import "PPLoginTableViewCell.h"
#import <UIImage+YYWebImage.h>
#import <WActionSheet/NLActionSheet.h>
#import "PPResetPassWordViewController.h"

@interface PPLoginViewController ()<UITableViewDelegate,UITableViewDataSource,PPLoginTableViewCellDelegate>
@property (nonatomic,strong) UITableView * tableView;
@property (nonatomic,strong) UILabel * headerView;
@property (nonatomic,strong) UIView * footerView;
@property (nonatomic,strong) UIBarButtonItem * item;
@property (nonatomic,strong) NSString * acount;
@property (nonatomic,strong) NSString * passWord;
@property (nonatomic,strong) UIButton * loginBtn;
@property (nonatomic,strong) UITextField * textfiled;
@property (nonatomic,strong) RACSignal * userNameSignal;
@property (nonatomic,strong) RACSignal * passWordSignal;
@end

@implementation PPLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.item = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancelAction:)];
    self.navigationItem.leftBarButtonItem = self.item;
    self.item.tintColor = [UIColor colorWithRed:104/255.0 green:187/255.0 blue:30/255.0 alpha:1];
    
    [self createUI];
    [self createLoginNavBarStryle];
    
    RACSubject * subject = [RACSubject subject];
    [[subject rac_signalForSelector:@selector(textFieldChange:style:) fromProtocol:@protocol(PPLoginTableViewCellDelegate)]subscribeNext:^(id x) {
        
        NSLog(@"%@",x);
        
    }];
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    RAC(self.loginBtn,enabled) = [RACSignal combineLatest:@[] reduce:^id _Nullable{
        
        return nil;
    }];
    self.userNameSignal = RACObserve(self,acount);
    self.passWordSignal = RACObserve(self,passWord);
    RAC(self.loginBtn,enabled)=[RACSignal combineLatest:@[self.userNameSignal,self.passWordSignal] reduce:^id (NSString * account,NSString * passWord){
        return @(account&&passWord);
    }];
    
    
    
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)createLoginNavBarStryle
{
 
    [self.navigationController.navigationBar setBackgroundColor:[UIColor whiteColor]];
    self.navigationController.navigationBar.clipsToBounds = YES;
}

- (void)createUI{
    
    self.headerView = [[UILabel alloc]initWithFrame:CGRectMake(0, 0,self.view.frame.size.width, 0)];
    self.headerView.font = [UIFont systemFontOfSize:18];
    self.headerView.text = @"使用手机号码登录";
    self.headerView.textAlignment = NSTextAlignmentCenter;
    self.footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0,SCREEN_WIDTH, 0)];
   
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,64,SCREEN_WIDTH,SCREEN_HEIHGHT - 64) style:UITableViewStyleGrouped];
    
    [self.view addSubview:self.tableView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor whiteColor];
    [self.tableView registerClass:[PPLoginTableViewCell class] forCellReuseIdentifier:@"PPLoginTableViewCell"];
   // self.tableView.contentInset = UIEdgeInsetsMake(-64.0f,.0f, 0.0f, 0.0f);
    self.tableView.tableFooterView = [UIView new];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    UIButton * loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.footerView addSubview:loginBtn];
    
    [loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.footerView.mas_top).mas_offset(20);
        make.left.mas_equalTo(self.footerView.mas_left).mas_offset(31);
        make.right.mas_equalTo(self.footerView.mas_right).mas_offset(-31);
        make.height.mas_equalTo(40);
    }];
    [loginBtn setBackgroundImage:[UIImage yy_imageWithColor:kPPLoginButtonDisableColor] forState:UIControlStateDisabled];
    [loginBtn setBackgroundImage:[UIImage yy_imageWithColor:kPPLoginButtonColor] forState:UIControlStateNormal];
    
    loginBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    loginBtn.enabled = NO;
    [loginBtn addTarget:self action:@selector(loginAction:) forControlEvents:UIControlEventTouchUpInside];
    self.loginBtn = loginBtn;
    UIButton * emailBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [self.footerView addSubview:emailBtn];
    
    [emailBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.footerView.mas_left);
        make.right.mas_equalTo(self.footerView.mas_right);
        make.top.mas_equalTo(loginBtn.mas_bottom).mas_offset(10);
        make.height.mas_equalTo(16);
    }];
    //142, 148, 165
    [emailBtn setTitleColor:kPPEamil_ButtonColor forState:UIControlStateNormal];
    [emailBtn setTitle:@"通过短信验证码登陆" forState:UIControlStateNormal];
    emailBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    
    
    UIButton * moreButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:moreButton];
    [moreButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(50);
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.bottom.mas_equalTo(self.view.mas_bottom).mas_offset(-10);
    }];
    [moreButton setTitleColor:kPPEamil_ButtonColor forState:UIControlStateNormal];
    [moreButton setTitle:@"更多" forState:UIControlStateNormal];
     moreButton.titleLabel.font = COMMON_FONT_SIZE;
    
    [moreButton addTarget:self action:@selector(moreAction:) forControlEvents:UIControlEventTouchUpInside];
}
- (void)moreAction:(id)sender
{
    NLActionSheet * sheet = [[NLActionSheet alloc]initWithTitle:@"" cancelTitle:@"取消" otherTitles:@[@"注册",@"忘记密码"]];
    sheet.otherTitlesFont = COMMON_FONT_SIZE;
    
    [sheet showView];
    [sheet dismissForCompletionHandle:^(NSInteger clickedIndex, BOOL isCancel) {
        if(!isCancel&&clickedIndex == 1)
        {
            PPResetPassWordViewController * controller = [PPResetPassWordViewController createRegisterViewController];
            [self presentViewController:controller animated:YES completion:nil];
            
        }else if (!isCancel&&clickedIndex == 0)
        {
            
        }
    }];
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
    }else
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
    return  3;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return  self.headerView;
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
    return  self.footerView;
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
