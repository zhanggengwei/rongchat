//
//  ViewController.m
//  rongchat
//
//  Created by vd on 2016/11/16.
//  Copyright © 2016年 vd. All rights reserved.
//

#import "PPConversationListViewController.h"
#import <RongIMKit/RCIM.h>
#import "RCDChatListCell.h"

@interface PPConversationListViewController ()
@property(nonatomic, strong) RCConversationModel *tempModel;

@property(nonatomic, assign) NSUInteger index;

@property(nonatomic, assign) BOOL isClick;
@end

@implementation PPConversationListViewController
- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        //设置要显示的会话类型
        [self setDisplayConversationTypes:@[
                                            @(ConversationType_PRIVATE),
                                            @(ConversationType_DISCUSSION),
                                            @(ConversationType_APPSERVICE),
                                            @(ConversationType_PUBLICSERVICE),
                                            @(ConversationType_GROUP),
                                            @(ConversationType_SYSTEM)
                                            ]];
        
        //聚合会话类型
        [self setCollectionConversationType:@[ @(ConversationType_SYSTEM) ]];
        
    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    if(self)
    {
        //设置要显示的会话类型
        [self setDisplayConversationTypes:@[
                                            @(ConversationType_PRIVATE),
                                            @(ConversationType_DISCUSSION),
                                            @(ConversationType_APPSERVICE),
                                            @(ConversationType_PUBLICSERVICE),
                                            @(ConversationType_GROUP),
                                            @(ConversationType_SYSTEM)
                                            ]];
        
        //聚合会话类型
        [self setCollectionConversationType:@[ @(ConversationType_SYSTEM) ]];
    }
    return self;
}



- (void)viewDidLoad {
    [super viewDidLoad];
 
    self.showConnectingStatusOnNavigatorBar = YES;
    self.conversationListTableView.tableFooterView = [UIView new];
    
    
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}






//*********************插入自定义Cell*********************//

//插入自定义会话model
- (NSMutableArray *)willReloadTableData:(NSMutableArray *)dataSource {
    
    for (int i = 0; i < dataSource.count; i++) {
        RCConversationModel *model = dataSource[i];
        //筛选请求添加好友的系统消息，用于生成自定义会话类型的cell
        if (model.conversationType == ConversationType_SYSTEM &&
            [model.lastestMessage
             isMemberOfClass:[RCContactNotificationMessage class]]) {
                model.conversationModelType = RC_CONVERSATION_MODEL_TYPE_CUSTOMIZATION;
            }
        if ([model.lastestMessage
             isKindOfClass:[RCGroupNotificationMessage class]]) {
            RCGroupNotificationMessage *groupNotification =
            (RCGroupNotificationMessage *)model.lastestMessage;
            if ([groupNotification.operation isEqualToString:@"Quit"]) {
                NSData *jsonData =
                [groupNotification.data dataUsingEncoding:NSUTF8StringEncoding];
                NSDictionary *dictionary = [NSJSONSerialization
                                            JSONObjectWithData:jsonData
                                            options:NSJSONReadingMutableContainers
                                            error:nil];
                NSDictionary *data =
                [dictionary[@"data"] isKindOfClass:[NSDictionary class]]
                ? dictionary[@"data"]
                : nil;
                NSString *nickName =
                [data[@"operatorNickname"] isKindOfClass:[NSString class]]
                ? data[@"operatorNickname"]
                : nil;
                if ([nickName isEqualToString:[RCIM sharedRCIM].currentUserInfo.name]) {
                    [[RCIMClient sharedRCIMClient]
                     removeConversation:model.conversationType
                     targetId:model.targetId];
                    [self refreshConversationTableViewIfNeeded];
                }
            }
        }
    }
    
    return dataSource;
}

//左滑删除
- (void)rcConversationListTableView:(UITableView *)tableView
                 commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
                  forRowAtIndexPath:(NSIndexPath *)indexPath {
    //可以从数据库删除数据
    RCConversationModel *model = self.conversationListDataSource[indexPath.row];
    [[RCIMClient sharedRCIMClient] removeConversation:ConversationType_SYSTEM
                                             targetId:model.targetId];
    [self.conversationListDataSource removeObjectAtIndex:indexPath.row];
    [self.conversationListTableView reloadData];
}

//高度
- (CGFloat)rcConversationListTableView:(UITableView *)tableView
               heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 67.0f;
}

//自定义cell
- (RCConversationBaseCell *)rcConversationListTableView:(UITableView *)tableView
                                  cellForRowAtIndexPath:
(NSIndexPath *)indexPath {
    RCConversationModel *model = self.conversationListDataSource[indexPath.row];
    
    __block NSString *userName = nil;
    __block NSString *portraitUri = nil;
    
    __weak PPConversationListViewController *weakSelf = self;
    //此处需要添加根据userid来获取用户信息的逻辑，extend字段不存在于DB中，当数据来自db时没有extend字段内容，只有userid
    if (nil == model.extend) {
        // Not finished yet, To Be Continue...
        if (model.conversationType == ConversationType_SYSTEM &&
            [model.lastestMessage
             isMemberOfClass:[RCContactNotificationMessage class]]) {
                RCContactNotificationMessage *_contactNotificationMsg =
                (RCContactNotificationMessage *)model.lastestMessage;
                if (_contactNotificationMsg.sourceUserId == nil) {
                    RCDChatListCell *cell =
                    [[RCDChatListCell alloc] initWithStyle:UITableViewCellStyleDefault
                                           reuseIdentifier:@""];
                    cell.lblDetail.text = @"好友请求";
                    [cell.ivAva sd_setImageWithURL:[NSURL URLWithString:portraitUri]
                                  placeholderImage:[UIImage imageNamed:@"system_notice"]];
                    
                    return cell;
                }
                NSDictionary *_cache_userinfo = [[NSUserDefaults standardUserDefaults]
                                                 objectForKey:_contactNotificationMsg.sourceUserId];
                if (_cache_userinfo) {
                    userName = _cache_userinfo[@"username"];
                    portraitUri = _cache_userinfo[@"portraitUri"];
                } else {
                    NSDictionary *emptyDic = @{};
                    [[NSUserDefaults standardUserDefaults]
                     setObject:emptyDic
                     forKey:_contactNotificationMsg.sourceUserId];
                    [[NSUserDefaults standardUserDefaults] synchronize];
//                    [RCDHTTPTOOL
//                     getUserInfoByUserID:_contactNotificationMsg.sourceUserId
//                     completion:^(RCUserInfo *user) {
//                         if (user == nil) {
//                             return;
//                         }
//                         RCDUserInfo *rcduserinfo_ = [RCDUserInfo new];
//                         rcduserinfo_.name = user.name;
//                         rcduserinfo_.userId = user.userId;
//                         rcduserinfo_.portraitUri = user.portraitUri;
//                         
//                         model.extend = rcduserinfo_;
//                         
//                         // local cache for userInfo
//                         NSDictionary *userinfoDic = @{
//                                                       @"username" : rcduserinfo_.name,
//                                                       @"portraitUri" : rcduserinfo_.portraitUri
//                                                       };
//                         [[NSUserDefaults standardUserDefaults]
//                          setObject:userinfoDic
//                          forKey:_contactNotificationMsg.sourceUserId];
//                         [[NSUserDefaults standardUserDefaults] synchronize];
//                         
//                         [weakSelf.conversationListTableView
//                          reloadRowsAtIndexPaths:@[ indexPath ]
//                          withRowAnimation:
//                          UITableViewRowAnimationAutomatic];
//                     }];
                }
            }
        
    } else {
//        RCDUserInfo *user = (RCDUserInfo *)model.extend;
//        userName = user.name;
//        portraitUri = user.portraitUri;
    }
    
    RCDChatListCell *cell =
    [[RCDChatListCell alloc] initWithStyle:UITableViewCellStyleDefault
                           reuseIdentifier:@""];
    cell.lblDetail.text =
    [NSString stringWithFormat:@"来自%@的好友请求", userName];
    [cell.ivAva sd_setImageWithURL:[NSURL URLWithString:portraitUri]
                  placeholderImage:[UIImage imageNamed:@"system_notice"]];
    cell.labelTime.text = [RCKitUtility ConvertMessageTime:model.sentTime/1000];
    cell.model = model;
    return cell;
}
//*********************插入自定义Cell*********************//

#pragma mark - 收到消息监听
- (void)didReceiveMessageNotification:(NSNotification *)notification {
    __weak typeof(&*self) blockSelf_ = self;
    //处理好友请求
    RCMessage *message = notification.object;
    if ([message.content isMemberOfClass:[RCContactNotificationMessage class]]) {
        
        if (message.conversationType != ConversationType_SYSTEM) {
            NSLog(@"好友消息要发系统消息！！！");
#if DEBUG
            @throw [[NSException alloc]
                    initWithName:@"error"
                    reason:@"好友消息要发系统消息！！！"
                    userInfo:nil];
#endif
        }
        RCContactNotificationMessage *_contactNotificationMsg =
        (RCContactNotificationMessage *)message.content;
        if (_contactNotificationMsg.sourceUserId == nil ||
            _contactNotificationMsg.sourceUserId.length == 0) {
            return;
        }
        
        [[PPDateEngine manager]requestGetUserInfoResponse:^(PPLoginOrRegisterHTTPResponse * aTaskResponse) {
            PPUserBase * userBase = aTaskResponse.result;
            
            
            RCConversationModel *customModel = [RCConversationModel new];
            customModel.conversationModelType =
            RC_CONVERSATION_MODEL_TYPE_CUSTOMIZATION;
            customModel.extend = userBase;
            customModel.conversationType = message.conversationType;
            customModel.targetId = message.targetId;
            customModel.sentTime = message.sentTime;
            customModel.receivedTime = message.receivedTime;
            customModel.senderUserId = message.senderUserId;
            customModel.lastestMessage = _contactNotificationMsg;
            //[_myDataSource insertObject:customModel atIndex:0];
            
            // local cache for userInfo
            NSDictionary *userinfoDic = @{
                                          @"username" : userBase.nickname,
                                          @"portraitUri" : userBase.portraitUri
                                          };
            [[NSUserDefaults standardUserDefaults]
             setObject:userinfoDic
             forKey:_contactNotificationMsg.sourceUserId];
            [[NSUserDefaults standardUserDefaults] synchronize];
            dispatch_async(dispatch_get_main_queue(), ^{
                [blockSelf_
                 refreshConversationTableViewWithConversationModel:
                 customModel];
                 [self notifyUpdateUnreadMessageCount];
                NSNumber *left =
                [notification.userInfo objectForKey:@"left"];
                if (0 == left.integerValue) {
                    [super refreshConversationTableViewIfNeeded];
                }
                
            });
            
            /*
            dispatch_async(dispatch_get_main_queue(), ^{
                //调用父类刷新未读消息数
             
                [self notifyUpdateUnreadMessageCount];
                
                //当消息为RCContactNotificationMessage时，没有调用super，如果是最后一条消息，可能需要刷新一下整个列表。
                //原因请查看super didReceiveMessageNotification的注释。
                NSNumber *left =
                [notification.userInfo objectForKey:@"left"];
                if (0 == left.integerValue) {
                    [super refreshConversationTableViewIfNeeded];
                }
            */
            
        } userID:_contactNotificationMsg.sourceUserId];
        
            
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            //调用父类刷新未读消息数
            [super didReceiveMessageNotification:notification];
        });
    }
}
/*
- (void)didTapCellPortrait:(RCConversationModel *)model {
    if (model.conversationModelType ==
        RC_CONVERSATION_MODEL_TYPE_PUBLIC_SERVICE) {
        RCDChatViewController *_conversationVC =
        [[RCDChatViewController alloc] init];
        _conversationVC.conversationType = model.conversationType;
        _conversationVC.targetId = model.targetId;
        _conversationVC.userName = model.conversationTitle;
        _conversationVC.title = model.conversationTitle;
        _conversationVC.conversation = model;
        _conversationVC.unReadMessage = model.unreadMessageCount;
        [self.navigationController pushViewController:_conversationVC animated:YES];
    }
    
    if (model.conversationModelType == RC_CONVERSATION_MODEL_TYPE_NORMAL) {
        RCDChatViewController *_conversationVC =
        [[RCDChatViewController alloc] init];
        _conversationVC.conversationType = model.conversationType;
        _conversationVC.targetId = model.targetId;
        _conversationVC.userName = model.conversationTitle;
        _conversationVC.title = model.conversationTitle;
        _conversationVC.conversation = model;
        _conversationVC.unReadMessage = model.unreadMessageCount;
        _conversationVC.enableNewComingMessageIcon = YES; //开启消息提醒
        _conversationVC.enableUnreadMessageIcon = YES;
        if (model.conversationType == ConversationType_SYSTEM) {
            _conversationVC.userName = @"系统消息";
            _conversationVC.title = @"系统消息";
        }
        if ([model.objectName isEqualToString:@"RC:ContactNtf"]) {
            RCDAddressBookViewController *addressBookVC = [RCDAddressBookViewController addressBookViewController];
            addressBookVC.needSyncFriendList = YES;
            [self.navigationController pushViewController:addressBookVC animated:YES];
            return;
        }
        //如果是单聊，不显示发送方昵称
        if (model.conversationType == ConversationType_PRIVATE) {
            _conversationVC.displayUserNameInCell = NO;
        }
        [self.navigationController pushViewController:_conversationVC animated:YES];
    }
    
    //聚合会话类型，此处自定设置。
    if (model.conversationModelType == RC_CONVERSATION_MODEL_TYPE_COLLECTION) {
        
        RCDChatListViewController *temp = [[RCDChatListViewController alloc] init];
        NSArray *array = [NSArray
                          arrayWithObject:[NSNumber numberWithInt:model.conversationType]];
        [temp setDisplayConversationTypes:array];
        [temp setCollectionConversationType:nil];
        temp.isEnteredToCollectionViewController = YES;
        [self.navigationController pushViewController:temp animated:YES];
    }
    
    //自定义会话类型
    if (model.conversationModelType == RC_CONVERSATION_MODEL_TYPE_CUSTOMIZATION) {
        //        RCConversationModel *model =
        //        self.conversationListDataSource[indexPath.row];
        
        if ([model.objectName isEqualToString:@"RC:ContactNtf"]) {
            RCDAddressBookViewController *addressBookVC = [RCDAddressBookViewController addressBookViewController];
            [self.navigationController pushViewController:addressBookVC animated:YES];
        }
    }
}
 */
//会话有新消息通知的时候显示数字提醒，设置为NO,不显示数字只显示红点
//-(void)willDisplayConversationTableCell:(RCConversationBaseCell *)cell
//atIndexPath:(NSIndexPath *)indexPath
//{
//    RCConversationModel *model=
//    self.conversationListDataSource[indexPath.row];
//
//    if (model.conversationType == ConversationType_PRIVATE) {
//        ((RCConversationCell *)cell).isShowNotificationNumber = NO;
//    }
//}
- (void)notifyUpdateUnreadMessageCount {
    //[self updateBadgeValueForTabBarItem];
}

- (void)receiveNeedRefreshNotification:(NSNotification *)status {
    __weak typeof(&*self) __blockSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        if (__blockSelf.displayConversationTypeArray.count == 1 &&
            [self.displayConversationTypeArray[0] integerValue] ==
            ConversationType_DISCUSSION) {
            [__blockSelf refreshConversationTableViewIfNeeded];
        }
        
    });
}

//-(void)checkVersion
//{
//    [RCDHTTPTOOL getVersioncomplete:^(NSDictionary *versionInfo) {
//        if (versionInfo) {
//            NSString *isNeedUpdate = [versionInfo objectForKey:@"isNeedUpdate"];
//            NSString *finalURL;
//            if ([isNeedUpdate isEqualToString:@"YES"]) {
//                __weak typeof(self) __weakSelf = self;
//                [__weakSelf.tabBarController.tabBar showBadgeOnItemIndex:3];
//                //获取系统当前的时间戳
//                NSDate *dat = [NSDate dateWithTimeIntervalSinceNow:0];
//                NSTimeInterval now = [dat timeIntervalSince1970] * 1000;
//                NSString *timeString = [NSString stringWithFormat:@"%f", now];
//                //为html增加随机数，避免缓存。
//                NSString *applist = [versionInfo objectForKey:@"applist"];
//                applist = [NSString stringWithFormat:@"%@?%@",applist,timeString];
//                finalURL = [NSString stringWithFormat:@"itms-services://?action=download-manifest&url=%@",applist];
//            }
//            [[NSUserDefaults standardUserDefaults] setObject:finalURL forKey:@"applistURL"];
//            [[NSUserDefaults standardUserDefaults] setObject:isNeedUpdate forKey:@"isNeedUpdate"];
//            [[NSUserDefaults standardUserDefaults] synchronize];
//        }
//    }];
//}

//- (void)pushToCreateDiscussion:(id)sender {
//    RCDContactSelectedTableViewController * contactSelectedVC= [[RCDContactSelectedTableViewController alloc]init];
//    contactSelectedVC.forCreatingDiscussionGroup = YES;
//    contactSelectedVC.isAllowsMultipleSelection = YES;
//    contactSelectedVC.titleStr = @"选择联系人";
//    [self.navigationController pushViewController:contactSelectedVC animated:YES];
//}

- (void)scrollViewDidScroll:(UIScrollView*)scrollView
{
    NSIndexPath *indexPath = [self.conversationListTableView indexPathForRowAtPoint:scrollView.contentOffset];
    self.index = indexPath.row;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    //恢复conversationListTableView的自动回滚功能。
    self.conversationListTableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
}

//-(void) GotoNextCoversation
//{
//    NSUInteger i;
//    //设置contentInset是为了滚动到底部的时候，避免conversationListTableView自动回滚。
//    self.conversationListTableView.contentInset = UIEdgeInsetsMake(0, 0, self.conversationListTableView.frame.size.height, 0);
//    for (i = self.index + 1; i < self.conversationListDataSource.count; i++) {
//        RCConversationModel *model = self.conversationListDataSource[i];
//        if (model.unreadMessageCount > 0) {
//            NSIndexPath *scrollIndexPath = [NSIndexPath indexPathForRow:i inSection:0];
//            self.index = i;
//            [self.conversationListTableView scrollToRowAtIndexPath:scrollIndexPath
//                                                  atScrollPosition:UITableViewScrollPositionTop animated:YES];
//            break;
//        }
//    }
//    //滚动到起始位置
//    if (i >= self.conversationListDataSource.count) {
//        //    self.conversationListTableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
//        for (i = 0; i < self.conversationListDataSource.count; i++) {
//            RCConversationModel *model = self.conversationListDataSource[i];
//            if (model.unreadMessageCount > 0) {
//                NSIndexPath *scrollIndexPath = [NSIndexPath indexPathForRow:i inSection:0];
//                self.index = i;
//                [self.conversationListTableView scrollToRowAtIndexPath:scrollIndexPath
//                                                      atScrollPosition:UITableViewScrollPositionTop animated:YES];
//                break;
//            }
//        }
//    }
//}

- (void)updateForSharedMessageInsertSuccess{
    [self refreshConversationTableViewIfNeeded];
}
@end
