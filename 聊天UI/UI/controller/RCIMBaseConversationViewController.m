//
//  RCIMBaseConversationViewController.m
//  rongchat
//
//  Created by VD on 2017/8/4.
//  Copyright © 2017年 vd. All rights reserved.
//

#import "RCIMBaseConversationViewController.h"
#import "RCChatBar.h"
#import "NSObject+RCIMDeallocBlockExecutor.h"
#import "RCIMCellRegisterController.h"
#import <MJRefresh/MJRefresh.h>
#import "RCIMConversationRefreshHeader.h"
static void * const RCIMBaseConversationViewControllerRefreshContext = (void*)&RCIMBaseConversationViewControllerRefreshContext;
static CGFloat const RCIMScrollViewInsetTop = 20.f;
@interface RCIMBaseConversationViewController ()

@end

@implementation RCIMBaseConversationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initilzer];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.left.and.width.equalTo(self.view);
        make.bottom.equalTo(self.chatBar.mas_top);
    }];
    [self.chatBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.and.bottom.equalTo(self.view);
        make.height.mas_greaterThanOrEqualTo(@(kLCCKChatBarMinHeight));
    }];
    // Do any additional setup after loading the view.
}

- (void)dealloc
{
    _chatBar.delegate = nil;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initilzer {
    self.shouldLoadMoreMessagesScrollToTop = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    // KVO注册监听
    [self addObserver:self forKeyPath:@"loadingMoreMessage" options:NSKeyValueObservingOptionNew context:RCIMBaseConversationViewControllerRefreshContext];
    __unsafe_unretained __typeof(self) weakSelf = self;
    [self lcck_executeAtDealloc:^{
        [weakSelf removeObserver:weakSelf forKeyPath:@"loadingMoreMessage"];
    }];
    [RCIMCellRegisterController registerChatMessageCellClassForTableView:self.tableView];
    //    [self setTableViewInsetsWithBottomValue:kLCCKChatBarMinHeight];
    __weak __typeof(self) weakSelf_ = self;
    self.tableView.mj_header = [RCIMConversationRefreshHeader headerWithRefreshingBlock:^{
        if (weakSelf_.shouldLoadMoreMessagesScrollToTop && !weakSelf_.loadingMoreMessage) {
            // 进入刷新状态后会自动调用这个block
            [weakSelf_ loadMoreMessagesScrollTotop];
        } else {
            [weakSelf_.tableView.mj_header endRefreshing];
        }
    }];
}

#pragma mark - Scroll Message TableView Helper Method

- (void)setTableViewInsetsWithBottomValue:(CGFloat)bottom {
    UIEdgeInsets insets = [self tableViewInsetsWithBottomValue:bottom];
    self.tableView.contentInset = insets;
    self.tableView.scrollIndicatorInsets = insets;
}

- (UIEdgeInsets)tableViewInsetsWithBottomValue:(CGFloat)bottom {
    UIEdgeInsets insets = UIEdgeInsetsZero;
    insets.top = RCIMScrollViewInsetTop;
    insets.bottom = bottom;
    return insets;
}

- (void)setShouldLoadMoreMessagesScrollToTop:(BOOL)shouldLoadMoreMessagesScrollToTop {
    _shouldLoadMoreMessagesScrollToTop = shouldLoadMoreMessagesScrollToTop;
    
}

// KVO监听执行
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if(context != RCIMBaseConversationViewControllerRefreshContext) {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        return;
    }
    if(context == RCIMBaseConversationViewControllerRefreshContext) {
        //if ([keyPath isEqualToString:@"loadingMoreMessage"]) {
        id newKey = change[NSKeyValueChangeNewKey];
        BOOL boolValue = [newKey boolValue];
        if (!boolValue) {
            [self.tableView.mj_header endRefreshing];
            if (!_shouldLoadMoreMessagesScrollToTop) {
                self.tableView.mj_header = nil;
            }
        }
    }
}
- (void)loadMoreMessagesScrollTotop {
    // This enforces implementing this method in subclasses
    [self doesNotRecognizeSelector:_cmd];
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
#pragma mark - Getters

- (RCChatBar *)chatBar {
    if (!_chatBar) {
        RCChatBar *chatBar = [[RCChatBar alloc] init];
        [self.view addSubview:(_chatBar = chatBar)];
        [self.view bringSubviewToFront:_chatBar];
    }
    return _chatBar;
}
@end
