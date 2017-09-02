//
//  RCIMCustomTableViewCell.h
//  rongchat
//
//  Created by VD on 2017/9/2.
//  Copyright © 2017年 vd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RCContactListCell.h"

@interface RCIMCellItem : NSObject
@property (nonatomic,copy) NSString * title;
@property (nonatomic,strong) RACSignal * clickSignal;
@end

@interface RCIMCellIconItem : RCIMCellItem
@property (nonatomic,copy) NSString * url;//图片加载地址
@property (nonatomic,strong) NSString * imageName;
@end

@interface RCIMCellSwitchItem : RCIMCellItem
@property (nonatomic,strong) RACSignal * switchSignal;
@property (nonatomic,assign) BOOL On;
@end

@interface RCIMCellCustomItem : RCIMCellItem
@property (nonatomic,copy) NSString * detail;
@end


@interface RCIMTableViewCell : RCContactListCell
- (void)createUI;
@end

@interface RCIMCustomTableViewCell : RCIMTableViewCell
@end

@interface RCIMIconTableViewCell : RCIMTableViewCell
@end

@interface RCIMSwithcTableViewCell : RCIMTableViewCell

@end

