//
//  LCCKConversationViewModel.m
//  rongchat
//
//  Created by VD on 2017/8/4.
//  Copyright © 2017年 vd. All rights reserved.
//

#import "RCIMConversationViewModel.h"
#import "RCCellIdentifierFactory.h"
#import <UITableView+FDTemplateLayoutCell.h>
#import "NSObject+RCIMDeallocBlockExecutor.h"
#import "RCIMMessageManager.h"
#import "RCMessage+RCTimeShow.h"
#import "RCChatBar.h"

@interface RCIMConversationViewModel ()<RCIMMessageManagerDelegate,RCIMMessageManagerConnectionStatusChangeDelegate>
@property (nonatomic,strong) RCIMMessageManager * messageManager;
@property (nonatomic,strong) NSString * conversationId;
@property (nonatomic,assign) RCConversationType conversationType;
@end


@implementation RCIMConversationViewModel

- (instancetype)initWithParentViewController:(RCIMConversationViewController *)parentViewController withConversationId:(NSString *)converstaionId withConversationType:(RCConversationType)conversationType
{
    if(self = [super init])
    {
        self.conversationType = conversationType;
        _dataArray = [NSMutableArray new];
        _imageArray = [NSMutableArray new];
        _voiceArray = [NSMutableArray new];
        _conversationId = converstaionId;
        _messageManager = [RCIMMessageManager shareManager];
        _messageManager.delegate = self;
        _parentController = parentViewController;
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(backGroundImageDidChanged:) name:RCNotificationConversationViewControllerBackgroundImageDidChanged object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(conversationInvalided:) name:RCNotificationCurrentConversationInvalided object:nil];
         __unsafe_unretained __typeof(self) weakSelf = self;
        [self lcck_executeAtDealloc:^{
            weakSelf.delegate = nil;
            [[NSNotificationCenter defaultCenter]removeObserver:self];
        }];
        
    }
    return self;
}

#pragma makr NSNotificationCenter

- (void)backGroundImageDidChanged:(NSNotification *)noti
{
    
}

- (void)conversationInvalided:(NSNotification *)noti
{
    
}

#pragma mark message 

- (void)appendMessage:(RCMessage *)message
{
    
}

- (void)firstLoadMessages
{
    
}
- (void)appendMessagesToDataArrayTrailing:(NSArray *)messages {
    if (messages.count > 0) {
        @synchronized (self) {
            [self.dataArray addObjectsFromArray:messages];
        }
    }
}
- (void)appendMessagesToTrailing:(NSArray *)messages {
    id lastObject = (self.dataArray.count > 0) ? [self.dataArray lastObject] : nil;
    [self appendMessagesToDataArrayTrailing:[self messagesWithSystemMessages:messages lastMessage:lastObject]];
}
/*!
 * @param messages 从服务端刷新下来的，夹杂着本地失败消息（但还未插入原有的旧消息self.dataArray里)。
 * 该方法能让preload时动态判断插入时间戳，同时也用在第一次加载时插入时间戳。
 */
- (NSArray *)messagesWithSystemMessages:(NSArray *)messages lastMessage:(id)lastMessage {
    NSMutableArray *messageWithSystemMessages = lastMessage ? @[lastMessage].mutableCopy : @[].mutableCopy;
    for (RCMessage * message in messages) {
        [messageWithSystemMessages addObject:message];
        [message lcck_shouldDisplayTimestampForMessages:messageWithSystemMessages callback:^(BOOL shouldDisplayTimestamp, NSTimeInterval messageTimestamp) {
            if (shouldDisplayTimestamp) {
                [messageWithSystemMessages insertObject:[RCMessage systemMessageWithTimestamp:messageTimestamp] atIndex:(messageWithSystemMessages.count - 1)];
            }
        }];
    }
    if (lastMessage) {
        [messageWithSystemMessages removeObjectAtIndex:0];
    }
    return [messageWithSystemMessages copy];
}
/*!
 * 用于加载历史记录，首次进入加载以及下拉刷新加载。
 */
- (NSArray *)messagesWithSystemMessages:(NSArray *)messages {
    return [self messagesWithSystemMessages:messages lastMessage:nil];
}
- (void)loadOldMessages {
    RCMessage *msg = [self.dataArray firstObject];
    int64_t timestamp = msg.sentTime;
    int messageCount = 10;
    [[RCIMMessageManager shareManager]queryHistoryMessageWithConversationType:self.conversationType withConversationId:self.conversationId withCount:messageCount oldesetMessageId:msg.messageId withHandle:^(NSArray<RCMessage *> *messages, NSError *error) {
        [self insertOldMessages:[self messagesWithLocalMessages:messages freshTimestamp:timestamp] completion: ^{
            self.parentController.loadingMoreMessage = messages.count>=messageCount;
        }];
    }];
}
- (NSArray *)messagesWithLocalMessages:(NSArray *)messages freshTimestamp:(int64_t)timestamp
{
    NSMutableArray * data = [NSMutableArray new];
    [messages enumerateObjectsUsingBlock:^(RCMessage * message, NSUInteger idx, BOOL * _Nonnull stop) {
     
    }];
    return data;
}
- (void)insertOldMessages:(NSArray *)oldMessages completion:(void (^)())completion {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
        NSMutableArray *messages = [NSMutableArray arrayWithArray:oldMessages];
        [messages addObjectsFromArray:self.dataArray];
        CGSize beforeContentSize = self.parentController.tableView.contentSize;
        NSMutableArray *indexPaths = [NSMutableArray arrayWithCapacity:oldMessages.count];
        [oldMessages enumerateObjectsUsingBlock:^(id message, NSUInteger idx, BOOL *stop) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:idx inSection:0];
            [indexPaths addObject:indexPath];
        }];
        dispatch_async(dispatch_get_main_queue(),^{
            BOOL animationEnabled = [UIView areAnimationsEnabled];
            if (animationEnabled) {
                [UIView setAnimationsEnabled:NO];
                [self.parentController.tableView beginUpdates];
                _dataArray = [messages mutableCopy];
                [self.parentController.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
                [self.parentController.tableView reloadData];
                [self.parentController.tableView endUpdates];
                CGSize afterContentSize = self.parentController.tableView.contentSize;
                CGPoint afterContentOffset = self.parentController.tableView.contentOffset;
                CGPoint newContentOffset = CGPointMake(afterContentOffset.x, afterContentOffset.y + afterContentSize.height - beforeContentSize.height);
                [self.parentController.tableView setContentOffset:newContentOffset animated:NO] ;
                [UIView setAnimationsEnabled:YES];
            }
            !completion ?: completion();
        });
    });
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RCMessage * message = self.dataArray[indexPath.row];
    NSString * identifier= [RCCellIdentifierFactory cellIdentifierForMessageConfiguration:message conversationType:message.conversationType];
    RCChatBaseMessageCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    [cell configureCellWithData:message];
    cell.tableView = self.parentController.tableView;
    cell.indexPath = indexPath;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RCMessage * message = self.dataArray[indexPath.row];
    NSString * identifier= [RCCellIdentifierFactory cellIdentifierForMessageConfiguration:message conversationType:message.conversationType];
    NSString *cacheKey = [RCCellIdentifierFactory cacheKeyForMessage:message];
    return [tableView fd_heightForCellWithIdentifier:identifier cacheByKey:cacheKey configuration:^(RCChatBaseMessageCell *cell) {
        [cell configureCellWithData:message];
    }];
}

#pragma mark RCIMMessageManagerDelegate
- (void)onReceived:(RCMessage *)message left:(int)nLeft object:(id)object
{
    if([message.targetId isEqualToString:self.conversationId])
    {
        [self.dataArray addObject:message];
        
    }
}
#pragma mark - UIScrollView Delegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    self.parentController.isUserScrolling = YES;
    UIMenuController *menu = [UIMenuController sharedMenuController];
    if (menu.isMenuVisible) {
        [menu setMenuVisible:NO animated:YES];
    }
    [self.parentController.chatBar endInputing];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    self.parentController.isUserScrolling = NO;
    BOOL allowScrollToBottom = self.parentController.allowScrollToBottom;
    CGFloat frameBottomToContentBottom = scrollView.contentSize.height - scrollView.frame.size.height - scrollView.contentOffset.y;
    //200：差不多是两行
    if (frameBottomToContentBottom < 200) {
        allowScrollToBottom = YES;
    } else {
        allowScrollToBottom = NO;
    }
    self.parentController.allowScrollToBottom = allowScrollToBottom;
}
@end
