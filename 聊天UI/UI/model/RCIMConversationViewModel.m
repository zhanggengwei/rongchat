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
@implementation RCIMConversationViewModel

- (instancetype)initWithParentViewController:(RCIMConversationViewController *)parentViewController
{
    if(self = [super init])
    {
        _dataArray = [NSMutableArray new];
        _imageArray = [NSMutableArray new];
        _voiceArray = [NSMutableArray new];
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

@end
