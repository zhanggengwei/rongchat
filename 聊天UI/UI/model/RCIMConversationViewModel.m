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
#import "NSDate+RCIMDateTools.h"


@interface RCIMConversationViewModel ()<RCIMMessageManagerDelegate,RCIMMessageManagerConnectionStatusChangeDelegate>

@property (nonatomic,strong) RCIMMessageManager * messageManager;
@property (nonatomic,assign) NSInteger timeInterval;
@property (nonatomic,strong) NSMutableArray * leftMessages;
//收到消息数组

@end


@implementation RCIMConversationViewModel

- (instancetype)initWithParentViewController:(RCIMConversationViewController *)parentViewController
{
    if(self = [super init])
    {
        
        _dataArray = [NSMutableArray new];
        _imageArray = [NSMutableArray new];
        _voiceArray = [NSMutableArray new];
        _leftMessages = [NSMutableArray new];
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
    
    RCMessage *msg = nil;
    if(self.dataArray.count)
    {
        msg = self.dataArray[1];
    }else
    {
        msg = self.dataArray[0];
    }
    int64_t timestamp = msg.sentTime;
    int messageCount = 10;
    [[RCIMMessageManager shareManager]queryHistoryMessageWithConversationType:self.conversationType withConversationId:self.conversationId withCount:messageCount oldesetMessageId:msg.messageId withHandle:^(NSArray<RCMessage *> *messages, NSError *error) {
        [self insertOldMessages:[self messagesWithLocalMessages:messages freshTimestamp:timestamp] completion: ^{
            self.parentController.loadingMoreMessage = NO;
        }];
    }];
}
- (void)deleteMessageWithCell:(RCChatBaseMessageCell *)cell withMessage:(RCMessage *)message
{
    NSInteger index = [self.dataArray indexOfObject:message];
    void (^deleteMessage)(RCMessage * message) = ^(RCMessage * message)
    {
        [[RCIMMessageManager shareManager]deleteMessage:@[@(message.messageId)]];
    };
    deleteMessage(message);
    if(index)
    {
        NSInteger preIndex = index - 1;
        RCMessage * preMessage = [self.dataArray objectAtIndex:preIndex];
        if([preMessage.objectName isEqualToString:RCTimeMessageTypeIdentifier])
        {
            NSInteger nextIndex = index + 1;
            if(nextIndex>=self.dataArray.count)
            {
                //最后一条消息
                [self.dataArray removeObject:preMessage];
                [self.dataArray removeObject:message];
                [self.parentController.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0],[NSIndexPath indexPathForRow:preIndex inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
            }
            else
            {
                RCMessage * nextMessage = self.dataArray[nextIndex];
                if([nextMessage.objectName isEqualToString:RCTimeMessageTypeIdentifier])
                {
                    
                    [self.dataArray removeObject:preMessage];
                    [self.dataArray removeObject:message];
                    [self.parentController.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0],[NSIndexPath indexPathForRow:preIndex inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
                }else
                {
                    
                    [self.dataArray removeObject:message];
                    [self.parentController.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
                }
                
            }
        }
        else
        {
            [self.dataArray removeObject:message];
            [self.parentController.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
        }
    }
    
}
- (NSArray *)messagesWithLocalMessages:(NSArray *)messages freshTimestamp:(int64_t)timestamp
{
    NSMutableArray * data = [NSMutableArray new];
    for (RCMessage * message in messages) {
        if([NSDate lcck_isShowTime:timestamp otherTimeInterval:message.sentTime])
        {
            RCMessage * timeMessage = [RCMessage new];
            timeMessage.objectName = RCTimeMessageTypeIdentifier;
            timeMessage.receivedTime = message.receivedTime;
            timeMessage.sentTime = message.sentTime;
            [data addObject:timeMessage];
            timestamp = message.sentTime;
        }
        if([message.objectName isEqualToString:RCImageMessageTypeIdentifier])
        {
            [self.imageArray addObject:message];
        }
        [data addObject:message];
    }
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
    
    cell.tableView = self.parentController.tableView;
    cell.indexPath = indexPath;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell configureCellWithData:message];
    cell.delegate = (id)self.parentController;
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
- (void)sendMessage:(RCMessageContent *)content
{
    void (^setMessageSendStatus)(RCSentStatus status,NSInteger messageId,NSInteger index) = ^(RCSentStatus status,NSInteger messageId,NSInteger index)
    {
        RCMessage * sucessSendMessage = [self.dataArray objectAtIndex:index];
        sucessSendMessage.messageId = messageId;
        sucessSendMessage.sentStatus = status;
        RCChatBaseMessageCell * cell = [self.parentController.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
        [cell setMessageSendState:status];
    };
    NSArray<RCMessage *> * sendMessages = [self sendLocalMessages:@[content]];
    [sendMessages enumerateObjectsUsingBlock:^(RCMessage * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if(![obj.objectName isEqualToString:RCTimeMessageTypeIdentifier])
        {
            [[RCIMMessageManager shareManager]sendCustomMessages:content withConversationId:self.conversationId conversationType:self.conversationType failed:^(RCErrorCode error, NSInteger messageId) {
                setMessageSendStatus(SentStatus_FAILED,messageId,[self.dataArray indexOfObject:obj]);
            } sucessBlock:^(NSInteger messageId) {
                setMessageSendStatus(SentStatus_SENT,messageId,[self.dataArray indexOfObject:obj]);
            }];
        }
    }];
    
    /*
     RCMessage * lastMessage = self.dataArray.lastObject;
     RCMessage * message = [[RCMessage alloc]initWithType:self.conversationType targetId:self.conversationId direction:MessageDirection_SEND messageId:0 content:content];
     NSArray<RCMessage *>* messages = [self messagesWithLocalMessages:@[message] freshTimestamp:lastMessage.sentTime];
     __block NSArray<NSIndexPath *> * indexPaths = @[];
     __block RCChatBaseMessageCell * targetCell = nil;
     [messages enumerateObjectsUsingBlock:^(RCMessage * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
     
     NSString * identifier= [RCCellIdentifierFactory cellIdentifierForMessageConfiguration:message conversationType:message.conversationType];
     RCChatBaseMessageCell * cell = [self.parentController.tableView dequeueReusableCellWithIdentifier:identifier];
     if(![message.objectName isEqualToString:RCTimeMessageTypeIdentifier])
     {
     targetCell = cell;
     message.sentStatus = SentStatus_SENDING;
     NSLog(@"pre message %@",message);
     }else
     {
     message.sentStatus = SentStatus_SENT;
     }
     cell.tableView = self.parentController.tableView;
     NSIndexPath * indexPath = [NSIndexPath indexPathForRow:self.dataArray.count + idx inSection:0];
     indexPaths = [indexPaths arrayByAddingObject:indexPath];
     cell.indexPath = indexPath;
     cell.selectionStyle = UITableViewCellSelectionStyleNone;
     [cell configureCellWithData:message];
     cell.delegate = (id)self.parentController;
     
     }];
     [self.dataArray addObjectsFromArray:messages];
     [self.parentController.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
     [self.parentController.tableView scrollToRowAtIndexPath:indexPaths.lastObject atScrollPosition:UITableViewScrollPositionBottom animated:YES];
     //    void (^setMessageSendStatus)(RCSentStatus status,NSInteger messageId) = ^(RCSentStatus status,NSInteger messageId)
     //    {
     //        RCMessage * sucessSendMessage = [self.dataArray objectAtIndex:indexPaths.lastObject.row];
     //        sucessSendMessage.messageId = messageId;
     //        sucessSendMessage.sentStatus = status;
     //        RCChatBaseMessageCell * cell = [self.parentController.tableView cellForRowAtIndexPath:indexPaths.lastObject];
     //        [cell setMessageSendState:status];
     //    };
     //    [[RCIMMessageManager shareManager]sendCustomMessages:content withConversationId:self.conversationId conversationType:self.conversationType failed:^(RCErrorCode error, NSInteger messageId) {
     //        setMessageSendStatus(SentStatus_FAILED,messageId);
     //    } sucessBlock:^(NSInteger messageId) {
     //         setMessageSendStatus(SentStatus_SENT,messageId);
     //    }];
     [self sendCustomMessage:message];
     */
}

- (NSArray<RCMessage *>*)sendLocalMessages:(NSArray<RCMessageContent *> *)contents
{
    RCMessage * lastMessage = self.dataArray.lastObject;
    NSMutableArray * messages = [NSMutableArray new];
    [contents enumerateObjectsUsingBlock:^(RCMessageContent * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        RCMessage * message = [[RCMessage alloc]initWithType:self.conversationType targetId:self.conversationId direction:MessageDirection_SEND messageId:0 content:obj];
        [messages addObject:message];
    }];
    NSArray<RCMessage *>* sendMessages = [self messagesWithLocalMessages:messages freshTimestamp:lastMessage.sentTime];
    __block NSArray<NSIndexPath *> * indexPaths = @[];
    __block RCChatBaseMessageCell * targetCell = nil;
    [sendMessages enumerateObjectsUsingBlock:^(RCMessage * _Nonnull message, NSUInteger idx, BOOL * _Nonnull stop) {
        
        NSString * identifier= [RCCellIdentifierFactory cellIdentifierForMessageConfiguration:message conversationType:message.conversationType];
        RCChatBaseMessageCell * cell = [self.parentController.tableView dequeueReusableCellWithIdentifier:identifier];
        if(![message.objectName isEqualToString:RCTimeMessageTypeIdentifier])
        {
            targetCell = cell;
            message.sentStatus = SentStatus_SENDING;
            NSLog(@"pre message %@",message);
        }else
        {
            message.sentStatus = SentStatus_SENT;
        }
        cell.tableView = self.parentController.tableView;
        NSIndexPath * indexPath = [NSIndexPath indexPathForRow:self.dataArray.count + idx inSection:0];
        indexPaths = [indexPaths arrayByAddingObject:indexPath];
        cell.indexPath = indexPath;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell configureCellWithData:message];
        cell.delegate = (id)self.parentController;
        
    }];
    [self.dataArray addObjectsFromArray:sendMessages];
    [self.parentController.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationBottom];
//    [self.parentController.tableView scrollToRowAtIndexPath:indexPaths.lastObject atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    [self.parentController scrollToBottomAnimated:YES];
    return sendMessages;
}

- (void)sendCustomMessage:(RCMessage *)message
{
    void (^setMessageSendStatus)(RCSentStatus status,NSInteger messageId) = ^(RCSentStatus status,NSInteger messageId)
    {
        NSIndexPath * indexPath = [NSIndexPath indexPathForRow:[self.dataArray indexOfObject:message] inSection:0];
        message.messageId = messageId;
        message.sentStatus = status;
        RCChatBaseMessageCell * cell = [self.parentController.tableView cellForRowAtIndexPath:indexPath];
        [cell setMessageSendState:status];
    };
    [[RCIMMessageManager shareManager]sendCustomMessages:message.content withConversationId:self.conversationId conversationType:self.conversationType failed:^(RCErrorCode error, NSInteger messageId) {
        setMessageSendStatus(SentStatus_FAILED,messageId);
    } sucessBlock:^(NSInteger messageId) {
        setMessageSendStatus(SentStatus_SENT,messageId);
    }];
}

- (void)resendMessage:(RCMessage *)message
{
    [self sendCustomMessage:message];
}

- (void)sendMediaMessages:(NSArray<RCMessageContent *> *)contents
{
    void (^setMessageSendStatus)(RCSentStatus status,NSInteger messageId,NSInteger index) = ^(RCSentStatus status,NSInteger messageId,NSInteger index)
    {
        RCMessage * sucessSendMessage = [self.dataArray objectAtIndex:index];
        sucessSendMessage.messageId = messageId;
        sucessSendMessage.sentStatus = status;
        RCChatBaseMessageCell * cell = [self.parentController.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
        [cell setMessageSendState:status];
    };
    NSArray<RCMessage *> * sendMessages = [self sendLocalMessages:contents];
    [sendMessages enumerateObjectsUsingBlock:^(RCMessage * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if(![obj.objectName isEqualToString:RCTimeMessageTypeIdentifier])
        {
            [[RCIMMessageManager shareManager]sendMediaMessages:obj.content withConversationId:self.conversationId conversationType:self.conversationType withProgress:^(NSInteger percentDone, NSInteger messageId) {
                if([self.delegate respondsToSelector:@selector(messageSendStateChanged:withProgress:forIndex:)])
                {
                    [self.delegate messageSendStateChanged:SentStatus_SENDING withProgress:percentDone/100.0 forIndex:[self.dataArray indexOfObject:obj]];
                }
                
            } failed:^(RCErrorCode error, NSInteger messageId) {
                setMessageSendStatus(SentStatus_FAILED,messageId,[self.dataArray indexOfObject:obj]);
            } sucessBlock:^(NSInteger messageId) {
                NSLog(@"图片 发送陈功");
                setMessageSendStatus(SentStatus_SENT,messageId,[self.dataArray indexOfObject:obj]);
            } cancelBlock:^(NSInteger messageId) {
                 setMessageSendStatus(SentStatus_CANCELED,messageId,[self.dataArray indexOfObject:obj]);
            }];
            
        }
    }];
    
}
- (void)loadMessagesFirstTimeWithCallback:(RCIdBoolResultBlock)callback
{
    [[RCIMMessageManager shareManager]queryLastedMessageWithConversationType:self.conversationType withConversationId:self.conversationId withCount:10 withHandle:^(NSArray<RCMessage *> *messages, NSError *error) {
        [self addMessagesFirstTime:messages];
        dispatch_async(dispatch_get_main_queue(),^{
            [self.parentController.tableView reloadData];
            [self.parentController scrollToBottomAnimated:NO];
            self.parentController.loadingMoreMessage = NO;
            !callback ?: callback(YES, nil, nil);
        });
    }];
    
}
- (void)addMessagesFirstTime:(NSArray *)messages {
    [self appendMessagesToDataArrayTrailing:[self messagesWithLocalMessages:messages freshTimestamp:0]];
}

#pragma mark RCIMMessageManagerDelegate
- (void)onReceived:(RCMessage *)message left:(int)nLeft object:(id)object
{
    
    if([message.targetId isEqualToString:self.conversationId])
    {
        [_leftMessages addObject:message];
        if (nLeft<=0) {
            RCMessage * message = self.dataArray.firstObject;
            NSInteger timeInterval = 0;
            if(message!=nil)
            {
                timeInterval = message.sentTime;
            }
            NSArray * arr = [self messagesWithLocalMessages:_leftMessages freshTimestamp:timeInterval];
            [self.dataArray addObjectsFromArray:arr];
            [_leftMessages removeAllObjects];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.parentController.tableView reloadData];
                [self.parentController scrollToBottomAnimated:YES];
            });
        }
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
