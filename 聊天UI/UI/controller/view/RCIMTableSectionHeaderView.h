//
//  RCIMTableSectionHeaderView.h
//  rongchat
//
//  Created by VD on 2017/8/31.
//  Copyright © 2017年 vd. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger,RCIMTableSectionHeaderStyle) {
    RCIMTableSectionHeaderStyleCustom,
    RCIMTableSectionHeaderStyleSelected
};

@interface RCIMTableSectionHeaderView : UIView
-(void)setTitle:(NSString *)title style:(RCIMTableSectionHeaderStyle)style;
@property (nonatomic,assign) RCIMTableSectionHeaderStyle style;
@end
