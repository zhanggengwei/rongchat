//
//  PPPersonTableViewCell.h
//  rongChatDemo1
//
//  Created by vd on 2016/11/1.
//  Copyright © 2016年 vd. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    
    PPPersonTableViewCellDefault,
    PPPersonTableViewCellBigImage
    
} PPPersonTableViewCellStyle;
@class PPPersonal;

@interface PPPersonTableViewCell : UITableViewCell
- (void)layoutData:(PPPersonTableViewCellStyle)style cellModel:(PPPersonal *)model;

@end
