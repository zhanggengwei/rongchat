
//
//  PPUpdatePassWordController.m
//  rongchat
//
//  Created by vd on 2016/11/29.
//  Copyright © 2016年 vd. All rights reserved.
//

#import "PPUpdatePassWordController.h"
#import "PPTool.h"
#import "PPUpdatePassWordTableViewCell.h"
#import "PPImageUtil.h"
#define  content  @"设置微信密码可以用微信绑定的帐号加微信密码登陆,如绑定手机号后,可以使用手机号加微信密码登录微信"

@interface PPUpdatePassWordController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UIButton * leftBtn;
@property (nonatomic,strong) UIButton * rightBtn;
@property (nonatomic,strong) UITableView * tableView;
@property (nonatomic,strong) NSString *  oldPassWord;
@property (nonatomic,strong) NSString *  updatePassWord;
@end

@implementation PPUpdatePassWordController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"设置微信密码";
    self.view.backgroundColor = [UIColor whiteColor];
    self.leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.leftBtn.frame = CGRectMake(0, 0,50, 50);
    
    self.leftBtn.contentHorizontalAlignment =  UIControlContentHorizontalAlignmentLeft;
    self.rightBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    
    
    self.leftBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    self.rightBtn.titleLabel.font = [UIFont systemFontOfSize:14];
   
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.leftBtn];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.rightBtn];
    [self.leftBtn setTitle:@"取消" forState:UIControlStateNormal];
    [self.rightBtn setTitle:@"完成" forState:UIControlStateNormal];
    self.rightBtn.frame = CGRectMake(SCREEN_WIDTH - 50, 0, 50, 50);
    
    self.rightBtn.enabled = NO;
    [self.rightBtn setTitleColor:kPPTFontColorGray forState:UIControlStateNormal];
    
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIHGHT - 64) style:UITableViewStyleGrouped];
    [self.view addSubview:self.tableView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.tableView registerClass:[PPUpdatePassWordTableViewCell class] forCellReuseIdentifier:@"PPUpdatePassWordTableViewCell"];
    
    [self.leftBtn addTarget:self action:@selector(leftAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.rightBtn addTarget:self action:@selector(rightAction:) forControlEvents:UIControlEventTouchUpInside];
    
    
    //self.tableView.backgroundColor = kMainBackGroundColor;
    
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)leftAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)rightAction:(id)sender
{
    [PPIndicatorView showLoadingInView:self.view];
    [[PPDateEngine manager]requestResponse:^(PPHTTPResponse * aTaskResponse) {
        [PPIndicatorView hideLoadingInView:self.view];
        if(aTaskResponse.code.integerValue == kPPResponseSucessCode)
        {
            [PPIndicatorView showString:@"密码修改成功"];
            dispatch_after( dispatch_time(
                                          DISPATCH_TIME_NOW,
                                          1 * NSEC_PER_SEC)
                                          , dispatch_get_main_queue(), ^{
                                              [self.navigationController popViewControllerAnimated:YES];
                                              
            });
            
            
        }else
        {
            [PPIndicatorView showString:aTaskResponse.message];
        }
        
    } changePassWord:self.oldPassWord oldPassWord:self.updatePassWord];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
   
    return 28 + [PPTool sizeWithString:content font:DETAIL_FONT_SIZE constrainedToSize:CGSizeMake(SCREEN_WIDTH - 36, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping].height;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * view = [UIView new];
    UILabel * contentLabel = [UILabel new];
    [view addSubview:contentLabel];
    [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(view.mas_left).mas_offset(16);
        make.right.mas_equalTo(view.mas_right).mas_offset(-20);
        make.top.mas_equalTo(view.mas_top).mas_offset(8);
        make.bottom.mas_equalTo(view.mas_bottom).mas_offset(-20);
    }];
    contentLabel.font = DETAIL_FONT_SIZE;
    contentLabel.textColor = kPPTFontColorGray;
    contentLabel.numberOfLines = 0;
    contentLabel.text = content;
    
    return view;
}

#pragma mark UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PPUpdatePassWordTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"PPUpdatePassWordTableViewCell"];
    if(indexPath.row == 0)
    {
        cell.cellStyle = PPUpdatePassWordTableViewCellDisable;
        
        [cell setLeftContent:@"手机号" rightContent:[SFHFKeychainUtils getPasswordForUsername:kPPLoginName andServiceName:kPPServiceName error:nil]];
       
    }else if (indexPath.row == 1)
    {
        cell.cellStyle = PPUpdatePassWordTableViewCellAble;
        [cell setLeftContent:@"密码" rightContent:@"请输入微信密码"];
        cell.blockText = ^(NSString * text)
        {
            self.oldPassWord = text;
            [self judgeRightClicked];
            
        };
    }else
    {
        cell.cellStyle = PPUpdatePassWordTableViewCellAble;
        [cell setLeftContent:@"新密码" rightContent:@"请输入新密码"];
        cell.blockText = ^(NSString *text)
        {
            self.updatePassWord = text;
            [self judgeRightClicked];
            
            
        };
    }
    return cell;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}
- (void)judgeRightClicked
{
    if((self.oldPassWord.length>=6&&self.oldPassWord!=nil)&&(self.updatePassWord.length>=6&&self.updatePassWord!=nil))
    {
        self.rightBtn.enabled = YES;
        [self.rightBtn setTitleColor:kPPTFontColorWhite forState:UIControlStateNormal];
        
    }else
    {
        self.rightBtn.enabled = NO;
        [self.rightBtn setTitleColor:kPPTFontColorGray forState:UIControlStateNormal];
    }
}




@end
