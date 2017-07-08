//
//  RCConversationViewController.m
//  rongchat
//
//  Created by Donald on 16/12/6.
//  Copyright © 2016年 vd. All rights reserved.
//

#import "RCConversationViewController.h"
#import "RCChatTextMessageCell.h"
#import "RCConversationCacheObj.h"
#import <UITableView+FDTemplateLayoutCell.h>

@interface RCConversationViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) NSString * targedId;
@property (nonatomic,assign) RCConversationType conversationType;
@property (nonatomic,strong) RCUserInfo * userInfo;
@property (nonatomic,strong) NSArray * messageArray;
@property (nonatomic,strong) UIImageView * backImageView;
@property (nonatomic,strong) UITableView * tableView;
@end

@implementation RCConversationViewController

- (instancetype)initWithTargetId:(NSString *)targetId conversationType:(RCConversationType)conversationType
{
    self = [super init];
    if(self)
    {
        self.targedId = targetId;
        self.conversationType = conversationType;
        self.messageArray = [[RCIMClient sharedRCIMClient]getLatestMessages:self.conversationType targetId:self.targedId count:10];
        NSLog(@"conversationArray ==%@",self.messageArray);
        
        self.messageArrayType = @[RCTextMessageTypeIdentifier];
        
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    [self.tableView registerClass:[RCChatTextMessageCell class] forCellReuseIdentifier:@"RCChatTextMessageCell"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
 
    [self loadMessageByMessageID];
    self.view.backgroundColor = [UIColor whiteColor];
 
    [[PPDateEngine manager]requestGetUserInfoResponse:^(PPUserBaseInfoResponse * aTaskResponse) {
        if(aTaskResponse.code.integerValue == kPPResponseSucessCode)
        {
            PPUserBaseInfo * info  = [PPUserBaseInfo new];
            info.user= aTaskResponse.result;
            [[RCIM sharedRCIM]
             refreshUserInfoCache:info
             withUserId:info.user.indexId];
        }
    } userID:self.targedId];
    
    
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark 加载信息的列表

- (void)loadMessageByMessageID
{
    self.messageArray =  [[RCIMClient sharedRCIMClient]getLatestMessages:self.conversationType targetId:self.targedId count:10];
    NSLog(@"%@",_messageArray);
    [self.tableView reloadData];
}





#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RCChatTextMessageCell * cell = [tableView dequeueReusableCellWithIdentifier:@"RCChatTextMessageCell"];
    [cell configureCellWithData:self.messageArray[indexPath.row]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  [self.messageArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    id message = self.messageArray[indexPath.row];
    NSString *identifier = [LCCKCellIdentifierFactory cellIdentifierForMessageConfiguration:message conversationType:[self.parentConversationViewController getConversationIfExists].lcck_type];
    NSString *cacheKey = [LCCKCellIdentifierFactory cacheKeyForMessage:message];
    return [tableView fd_heightForCellWithIdentifier:identifier cacheByKey:cacheKey configuration:^(RCChatBaseMessageCell *cell) {
        [cell configureCellWithData:message];
    }];
}



@end
