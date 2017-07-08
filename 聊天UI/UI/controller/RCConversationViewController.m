//
//  RCConversationViewController.m
//  rongchat
//
//  Created by Donald on 16/12/6.
//  Copyright © 2016年 vd. All rights reserved.
//

#import "RCConversationViewController.h"
#import "RCConversationCacheObj.h"
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
    NSArray * messageArray =  [[RCIMClient sharedRCIMClient]getLatestMessages:self.conversationType targetId:self.targedId count:10];
    
   
    NSLog(@"%@",messageArray);
}





#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  [self.messageArray count];
}





@end
