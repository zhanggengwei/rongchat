//
//  RCConversationViewController.m
//  rongchat
//
//  Created by Donald on 16/12/6.
//  Copyright © 2016年 vd. All rights reserved.
//

#import "RCConversationViewController.h"
#import "RCChatTextMessageCell.h"
#import "RCChatImageMessageCell.h"
#import "RCConversationCacheObj.h"
#import "RCCellIdentifierFactory.h"
#import <UITableView+FDTemplateLayoutCell.h>
#import <ODRefreshControl.h>
#import "NSObject+RCIMExtension.h"
#import "RCIMTableView.h"

@interface RCConversationViewController ()<UITableViewDelegate,UITableViewDataSource,RCIMReceiveMessageDelegate>
@property (nonatomic,strong) NSString * targedId;
@property (nonatomic,assign) RCConversationType conversationType;
@property (nonatomic,strong) RCUserInfo * userInfo;
@property (nonatomic,strong) NSMutableArray * messageArray;
@property (nonatomic,strong) UIImageView * backImageView;
@property (nonatomic,strong) RCIMTableView * tableView;
@property (nonatomic,assign) BOOL allowScrollToBottom;
@property (nonatomic,strong) ODRefreshControl * refreshControl;
@end

@implementation RCConversationViewController

- (instancetype)initWithTargetId:(NSString *)targetId conversationType:(RCConversationType)conversationType
{
    self = [super init];
    if(self)
    {
        self.allowScrollToBottom = YES;
        self.targedId = targetId;
        self.conversationType = conversationType;
        self.messageArrayType = @[RCTextMessageTypeIdentifier];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [[RCIM sharedRCIM]setReceiveMessageDelegate:self];
    self.tableView = [[RCIMTableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];

    [self.tableView registerClass:[RCChatTextMessageCell class] forCellReuseIdentifier:@"RCChatTextMessageCell"];
    [self.tableView registerClass:[RCChatImageMessageCell class] forCellReuseIdentifier:@"RCChatImageMessageCell"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self loadMessageByMessageID];
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

- (void)scrollToBottomAnimated:(BOOL)animated {
    if (!self.allowScrollToBottom) {
        return;
    }
    NSInteger rows = [self.tableView numberOfRowsInSection:0];
    if (rows > 0) {
        dispatch_block_t scrollBottomBlock = ^ {
            [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:rows - 1 inSection:0]
                                  atScrollPosition:UITableViewScrollPositionBottom
                                          animated:animated];
        };
        if (animated) {
            //when use `estimatedRowHeight` and `scrollToRowAtIndexPath` at the same time, there are some issue.
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                scrollBottomBlock();
            });
        } else {
            scrollBottomBlock();
        }
        
    }
}
#pragma mark 加载信息的列表

- (void)loadMessageByMessageID
{
   
    self.messageArray = [NSMutableArray arrayWithArray: [[[[RCIMClient sharedRCIMClient]getLatestMessages:self.conversationType targetId:self.targedId count:10] reverseObjectEnumerator] allObjects]];
    NSLog(@"%@",_messageArray);
    [self.tableView reloadData];
    [self scrollToBottomAnimated:YES];
    
}
#pragma mark UITableViewDelegate

- (void)tableView:(RCIMTableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (UITableViewCell *)tableView:(RCIMTableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RCMessage * message = self.messageArray[indexPath.row];
    //
    RCChatBaseMessageCell * cell = [tableView dequeueReusableCellWithIdentifier:[self RCIM_registerCellReuseIdentifier:message]];
    //
    NSLog(@"object%@",message.objectName);
    [cell configureCellWithData:message];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(RCIMTableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(RCIMTableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  [self.messageArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    id message = self.messageArray[indexPath.row];
    NSString * idenfifier = [self RCIM_registerCell:[self RCIM_registerCellReuseIdentifier:message]];
    NSString *cacheKey = [RCCellIdentifierFactory cacheKeyForMessage:message];
    return [tableView fd_heightForCellWithIdentifier:idenfifier cacheByKey:cacheKey configuration:^(RCChatBaseMessageCell *cell) {
        [cell configureCellWithData:message];
    }];
}

- (void)onRCIMReceiveMessage:(RCMessage *)message left:(int)left
{
    if([message.targetId isEqualToString:self.targedId])
    {
        [self.messageArray addObject:message];
    }
    if(left<=0)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
            [self scrollToBottomAnimated:YES];
        });
    }
}

@end
