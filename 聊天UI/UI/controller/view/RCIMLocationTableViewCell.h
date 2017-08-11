//
//  RCIMLocationTableViewCell.h
//  rongchat
//
//  Created by VD on 2017/8/10.
//  Copyright © 2017年 vd. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RCIMLocationCellProtrocal <NSObject>
@property (nonatomic,strong) AMapPOI * area;


@end

@interface RCIMShowLocationCell : UITableViewCell<RCIMLocationCellProtrocal>
@property (nonatomic,strong) AMapPOI * area;
@property (nonatomic,strong,readonly) UIImageView * selectdIconImageView;
@end

@interface RCIMLocationTableViewCell : RCIMShowLocationCell
@end

@interface RCIMLocationCustomTableViewCell : RCIMShowLocationCell

@end
