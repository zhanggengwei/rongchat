//
//  RCConversationBaseCell.h
//  rongchat
//
//  Created by Donald on 16/12/6.
//  Copyright © 2016年 vd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RCConversationModel.h"

/*!
 会话Cell基类
 */

@interface RCConversationBaseCell : UITableViewCell

/*!
 会话Cell的数据模型
 */
@property(nonatomic, strong,readonly) RCConversationModel *model;

/*!
 设置会话Cell的数据模型
 
 @param model 会话Cell的数据模型
 */
- (void)setDataModel:(RCConversationModel *)model;

@end
