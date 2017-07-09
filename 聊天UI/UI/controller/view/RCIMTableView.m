//
//  RCIMTableView.m
//  rongchat
//
//  Created by VD on 2017/7/9.
//  Copyright © 2017年 vd. All rights reserved.
//

#import "RCIMTableView.h"
#import "NSObject+RCIMExtension.h"
#import "RCChatBaseMessageCell.h"

@implementation RCIMTableView


- (nullable __kindof UITableViewCell *)dequeueReusableCellWithIdentifier:(NSString *)identifier
{
    NSString * idenfity = [self RCIM_registerCell:identifier];
    UITableViewCell * cell = [super dequeueReusableCellWithIdentifier:idenfity];
//    cell.custom_reuseIdentifier = identifier;
    return cell;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
