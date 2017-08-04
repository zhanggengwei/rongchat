//
//  RCIMBaseTableViewController.h
//  rongchat
//
//  Created by VD on 2017/8/3.
//  Copyright © 2017年 vd. All rights reserved.
//

#import "RCIMBaseViewController.h"
#import "RCIMStatusView.h"
typedef enum : NSUInteger {
    RCIMViewControllerStylePlain = 0,
    RCIMViewControllerStylePresenting
}RCIMViewControllerStyle;
@interface RCIMBaseTableViewController : RCIMBaseViewController<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) RCIMStatusView *clientStatusView;
/*
   初始化的时候使用
 */
@property (nonatomic, assign) UITableViewStyle tableViewStyle;
@property (nonatomic, assign) RCIMViewControllerStyle viewControllerStyle;
/*
   数据显示的控件
 */
@property (nonatomic,weak) UITableView * tableView;
/*
   数据源
 */
@property (nonatomic, strong) NSMutableArray *dataSource;


@property (nonatomic, assign, getter=shouldCheckSessionStatus) BOOL checkSessionStatus;
/**
 *  加载本地或者网络数据源
 */
- (void)loadDataSource;
- (void)updateStatusView;
@end
