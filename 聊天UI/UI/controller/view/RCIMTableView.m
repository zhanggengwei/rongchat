//
//  RCIMTableView.m
//  rongchat
//
//  Created by VD on 2017/7/9.
//  Copyright © 2017年 vd. All rights reserved.
//

#import "RCIMTableView.h"
#import "NSObject+RCIMExtension.h"

@implementation RCIMTableView
- (nullable __kindof UITableViewCell *)dequeueReusableCellWithIdentifier:(NSString *)identifier
{
    NSString * idenfity = identifier;
    UITableViewCell * cell = [super dequeueReusableCellWithIdentifier:[self RCIM_registerCell:idenfity]];
    cell.customIdenfier = idenfity;
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
