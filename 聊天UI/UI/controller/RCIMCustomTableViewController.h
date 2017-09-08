//
//  RCIMCustomTableViewController.h
//  rongchat
//
//  Created by VD on 2017/8/29.
//  Copyright © 2017年 vd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RCContactListCell.h"

@interface RCIMCustomTableViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong,readonly) UITableView * tableView;
@property (nonatomic,assign) UITableViewStyle style;
@property (nonatomic,strong) NSArray * dataSource;
@property (nonatomic,strong) Class<RCContactListCellProtrocal> cellClass;
@property (nonatomic,assign) BOOL showIndexTitles;
@end
