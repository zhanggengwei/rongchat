//
//  RCConversationViewController.m
//  rongchat
//
//  Created by Donald on 16/12/6.
//  Copyright © 2016年 vd. All rights reserved.
//

#import "RCConversationViewController.h"
#import "RCConversationCacheObj.h"
#import "RCCellIdentifierFactory.h"
#import <UITableView+FDTemplateLayoutCell.h>
#import <ODRefreshControl.h>
#import "NSObject+RCIMExtension.h"
#import "NSDate+RCIMDateTools.h"
#import <MJRefresh.h>
#import "RCIMCellRegisterController.h"
#import "RCCellIdentifierFactory.h"
#import "RCChatBar.h"
#import <RongIMLib/RCIMClient.h>
static CGFloat const LCCKScrollViewInsetTop = 20.f;

@interface RCConversationViewController ()<UITableViewDelegate,UITableViewDataSource,RCIMReceiveMessageDelegate,LCCKChatBarDelegate>
@property (nonatomic,strong) NSString * targedId;
@property (nonatomic,assign) RCConversationType conversationType;
@property (nonatomic,strong) RCUserInfo * userInfo;
@property (nonatomic,strong) NSMutableArray * messageArray;
@property (nonatomic,strong) UIImageView * backImageView;
@property (nonatomic,strong) UITableView * tableView;
@property (nonatomic,assign) BOOL allowScrollToBottom;
@property (nonatomic,strong) ODRefreshControl * refreshControl;
@property (nonatomic,assign) NSUInteger timeInterval;
@property (strong,nonatomic) RCChatBar * chatBar;

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
        self.title = self.targedId;
        self.messageArrayType = @[RCTextMessageTypeIdentifier];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [[RCIM sharedRCIM]setReceiveMessageDelegate:self];
    self.tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    self.chatBar = [RCChatBar new];
    self.chatBar.delegate = self;
    
    [self.view addSubview:self.chatBar];
    [self.view bringSubviewToFront:_chatBar];
    [self.chatBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.and.bottom.equalTo(self.view);
        make.height.mas_greaterThanOrEqualTo(@(kLCCKChatBarMinHeight));
    }];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.view);
        make.top.mas_equalTo(self.view.mas_top).mas_offset(64);
        make.bottom.mas_equalTo(self.chatBar.mas_top);
    }];
    [RCIMCellRegisterController registerChatMessageCellClassForTableView:self.tableView];
    //    [self.tableView registerClass:[RCChatTextMessageCell class] forCellReuseIdentifier:@"RCChatTextMessageCell"];
    //    [self.tableView registerClass:[RCChatImageMessageCell class] forCellReuseIdentifier:@"RCChatImageMessageCell"];
    //    [self.tableView registerClass:[RCChatSystemMessageCell class] forCellReuseIdentifier:@"RCChatSystemMessageCell"];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
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
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        RCMessage * message = self.messageArray.firstObject;
        if([message.objectName isEqualToString:RCTimeMessageTypeIdentifier])
        {
            message = self.messageArray[1];
        }
        [self.tableView.mj_header beginRefreshing];
        [self loadMoreMessageWithMessageId:@(message.messageId).stringValue];
        [self.tableView.mj_header endRefreshing];
    }];
    
    
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSMutableArray *)messageArray
{
    if(_messageArray==nil)
    {
        _messageArray = [NSMutableArray new];
    }
    return _messageArray;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.chatBar open];
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
    
    NSArray * messages = [[[[RCIMClient sharedRCIMClient]getLatestMessages:self.conversationType targetId:self.targedId count:10] reverseObjectEnumerator] allObjects];
    [self loadTimeMessage:messages];
    NSLog(@"%@",_messageArray);
    [self.tableView reloadData];
    [self scrollToBottomAnimated:YES];
    
}

- (void)loadTimeMessage:(NSArray<RCMessage *> *)messageArray
{
    [self.messageArray removeAllObjects];
    for (RCMessage * message in messageArray) {
        
        if([NSDate lcck_isShowTime:self.timeInterval otherTimeInterval:message.sentTime])
        {
            RCMessage * timeMessage = [RCMessage new];
            timeMessage.objectName = RCTimeMessageTypeIdentifier;
            timeMessage.receivedTime = message.receivedTime;
            timeMessage.sentTime = message.sentTime;
            [self.messageArray addObject:timeMessage];
            self.timeInterval = message.sentTime;
        }
        [self.messageArray addObject:message];
    }
}
- (void)loadMoreMessageWithMessageId:(NSString *)messageId
{
    NSArray * array= [[[[RCIMClient sharedRCIMClient]getHistoryMessages:self.conversationType targetId:self.targedId oldestMessageId:messageId.integerValue count:10]reverseObjectEnumerator]allObjects];
    NSMutableArray * data = [NSMutableArray new];
    for (RCMessage * message in array) {
        
        if([NSDate lcck_isShowTime:self.timeInterval otherTimeInterval:message.sentTime])
        {
            RCMessage * timeMessage = [RCMessage new];
            timeMessage.objectName = RCTimeMessageTypeIdentifier;
            timeMessage.receivedTime = message.receivedTime;
            timeMessage.sentTime = message.sentTime;
            [data addObject:timeMessage];
            self.timeInterval = message.sentTime;
        }
        [data addObject:message];
    }
    RCMessage * firstMessage = self.messageArray.firstObject;
    if(firstMessage==nil)
    {
        [self.messageArray addObject:data];
    }else if (![NSDate lcck_isShowTime:firstMessage.sentTime otherTimeInterval:self.timeInterval])
    {
        [self.messageArray removeObject:firstMessage];
        
    }
    NSRange range = NSMakeRange(0, [data count]);
    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:range];
    [self.messageArray insertObjects:data atIndexes:indexSet];
    RCMessage * lastMessage = self.messageArray.lastObject;
    if(lastMessage)
    {
        self.timeInterval = lastMessage.sentTime;
    }
    [self.tableView reloadData];
}


#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RCMessage * message = self.messageArray[indexPath.row];
    NSString * identifier= [RCCellIdentifierFactory cellIdentifierForMessageConfiguration:message conversationType:message.conversationType];
    RCChatBaseMessageCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    [cell configureCellWithData:message];
    cell.tableView = self.tableView;
    cell.indexPath = indexPath;
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
    
    RCMessage * message = self.messageArray[indexPath.row];
    
    NSString * identifier= [RCCellIdentifierFactory cellIdentifierForMessageConfiguration:message conversationType:message.conversationType];
    NSString *cacheKey = [RCCellIdentifierFactory cacheKeyForMessage:message];
    return [tableView fd_heightForCellWithIdentifier:identifier cacheByKey:cacheKey configuration:^(RCChatBaseMessageCell *cell) {
        [cell configureCellWithData:message];
    }];
    
}

- (void)onRCIMReceiveMessage:(RCMessage *)message left:(int)left
{
    if([message.targetId isEqualToString:self.targedId])
    {
        [self appendTrailingMessage:message];
    }
    if(left<=0)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
            [self scrollToBottomAnimated:YES];
        });
    }
}

- (void)appendTrailingMessage:(RCMessage *)message
{
    if([NSDate lcck_isShowTime:self.timeInterval otherTimeInterval:message.sentTime])
    {
        RCMessage * timeMessage = [RCMessage new];
        timeMessage.objectName = RCTimeMessageTypeIdentifier;
        timeMessage.receivedTime = message.receivedTime;
        timeMessage.sentTime = message.sentTime;
        [self.messageArray addObject:timeMessage];
        self.timeInterval = message.sentTime;
    }
    [self.messageArray addObject:message];
    
}

- (void)setTableViewInsetsWithBottomValue:(CGFloat)bottom {
    UIEdgeInsets insets = [self tableViewInsetsWithBottomValue:bottom];
    self.tableView.contentInset = insets;
    self.tableView.scrollIndicatorInsets = insets;
}

- (UIEdgeInsets)tableViewInsetsWithBottomValue:(CGFloat)bottom {
    UIEdgeInsets insets = UIEdgeInsetsZero;
    insets.top = LCCKScrollViewInsetTop;
    insets.bottom = bottom;
    return insets;
}

- (void)setShouldLoadMoreMessagesScrollToTop:(BOOL)shouldLoadMoreMessagesScrollToTop {
}

- (void)chatBarFrameDidChange:(RCChatBar *)chatBar shouldScrollToBottom:(BOOL)shouldScrollToBottom {
    [UIView animateWithDuration:RCAnimateDuration animations:^{
        [self.tableView.superview layoutIfNeeded];
        self.allowScrollToBottom = shouldScrollToBottom;
        [self scrollToBottomAnimated:NO];
    } completion:nil];
}


- (void)fillSenderMessage:(RCMessage *)message
{
    message.sentTime = [[NSDate date]timeIntervalSince1970]*1000;
    message.receivedTime = message.sentTime;
    message.messageDirection = MessageDirection_SEND;
    message.conversationType = self.conversationType;
    message.targetId = self.targedId;
    message.senderUserId = [RCIMClient sharedRCIMClient].currentUserInfo.userId;
    message.sentStatus = SentStatus_SENDING;
}
//图片连续
- (void)appendCustomMessages:(NSArray<UIImage *> *)images
{
    for (UIImage * image in images) {
        RCImageMessage * messageContent = [RCImageMessage messageWithImage:image];
        RCMessage * message = [[RCMessage alloc]initWithType:self.conversationType targetId:self.targedId direction:MessageDirection_SEND messageId:0 content:messageContent];
        [self fillSenderMessage:message];
        [self.messageArray addObject:message];
        [self sendImage:messageContent index:self.messageArray.count-1];
    }
     [self.tableView reloadData];
    [self scrollToBottomAnimated:YES];
}

#pragma mark
- (void)chatBar:(RCChatBar *)chatBar sendMessage:(NSString *)message
{
    RCTextMessage * textMessage = [RCTextMessage new];
    textMessage.content = message;
    RCMessage * senderMessage= [RCMessage new];
    senderMessage.content = textMessage;
    senderMessage.objectName = RCTextMessageTypeIdentifier;
    [self fillSenderMessage:senderMessage];
    NSInteger messageCount = self.messageArray.count;
    [self appendTrailingMessage:senderMessage];
    NSInteger currentMessageCount = self.messageArray.count;
    NSArray * indexPaths = @[];
    if(currentMessageCount-messageCount>=2)
    {
        NSIndexPath * indexpath1 = [NSIndexPath indexPathForRow:self.messageArray.count-2 inSection:0];
        NSIndexPath * indexpath = [NSIndexPath indexPathForRow:self.messageArray.count-1 inSection:0];
        indexPaths = [indexPaths arrayByAddingObjectsFromArray:@[indexpath1,indexpath]];
    }else
    {
        NSIndexPath * indexpath = [NSIndexPath indexPathForRow:self.messageArray.count-1 inSection:0];
        indexPaths = [indexPaths arrayByAddingObject:indexpath];
    }
    self.allowScrollToBottom = YES;
    NSIndexPath * targetIndexPath = indexPaths.lastObject;
    dispatch_async(dispatch_get_main_queue(),^{
        [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
        [self scrollToBottomAnimated:YES];
        [[RCIMClient sharedRCIMClient]sendMessage:self.conversationType targetId:self.targedId content:textMessage pushContent:nil pushData:nil success:^(long messageId) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                RCMessage * sucessSendMessage = [self.messageArray objectAtIndex:targetIndexPath.row];
                sucessSendMessage.messageId = messageId;
                sucessSendMessage.sentStatus = SentStatus_SENT;
                RCChatBaseMessageCell * cell = [self.tableView cellForRowAtIndexPath:targetIndexPath];
                [cell setMessageSendState:SentStatus_SENT];
                
                
            });
        } error:^(RCErrorCode nErrorCode, long messageId) {
            dispatch_async(dispatch_get_main_queue(), ^{
                RCMessage * sucessSendMessage = [self.messageArray objectAtIndex:targetIndexPath.row];
                sucessSendMessage.messageId = messageId;
                sucessSendMessage.sentStatus = SentStatus_FAILED;
                RCChatBaseMessageCell * cell = [self.tableView cellForRowAtIndexPath:targetIndexPath];
                [cell setMessageSendState:SentStatus_FAILED];
            
            });
        }];
    });
}

- (void)sendImages:(NSArray<UIImage *> *)images
{
    [self appendCustomMessages:images];
}

- (void)sendImage:(RCImageMessage *)messageImage index:(NSInteger)index
{
    if(messageImage==nil)
    {
        return;
    }
    void (^cellMessageSendStatesChanged)(RCSentStatus status,NSInteger messageId) = ^(RCSentStatus status,NSInteger messageId)
    {
        RCMessage * message = [self.messageArray objectAtIndex:index];
        message.messageId = messageId;
        message.sentStatus = SentStatus_SENT;
        RCChatBaseMessageCell * cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
        dispatch_async(dispatch_get_main_queue(), ^{
            [cell setMessageSendState:status];
        });
    };
    [[RCIMClient sharedRCIMClient]sendMediaMessage:self.conversationType targetId:self.targedId content:messageImage pushContent:nil pushData:nil progress:^(int progress, long messageId) {
        RCChatImageMessageCell * cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
        dispatch_async(dispatch_get_main_queue(), ^{
            [cell setUploadProgress:progress/100.0];
        });
   
    } success:^(long messageId) {
       
        cellMessageSendStatesChanged(SentStatus_SENT,messageId);
        
    } error:^(RCErrorCode errorCode, long messageId) {
         cellMessageSendStatesChanged(SentStatus_FAILED,messageId);
        
    } cancel:^(long messageId) {
        cellMessageSendStatesChanged(SentStatus_CANCELED,messageId);
    }];
}



@end
