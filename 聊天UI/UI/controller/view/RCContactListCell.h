//
//  RCContactListCell.h
//  rongchat
//
//  Created by VD on 2017/8/29.
//  Copyright © 2017年 vd. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RCContactListCellProtrocal <NSObject>
@property (nonatomic,strong) id model;
@end

@interface RCContactListCell : UITableViewCell<RCContactListCellProtrocal>
@property (nonatomic,strong) id model;

@end
