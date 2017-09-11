//
//  RCContactListCell.h
//  rongchat
//
//  Created by VD on 2017/8/29.
//  Copyright © 2017年 vd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RCContactListCell : UITableViewCell<RCContactListCellProtrocal>
@property (nonatomic,strong) id<RCIMCellModel> model;
@property (nonatomic,strong) NSIndexPath * indexPath;
@property (nonatomic,weak) UITableView * tableView;

@end
