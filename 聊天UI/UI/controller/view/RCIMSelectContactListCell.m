//
//  RCIMSelectContactListCell.m
//  rongchat
//
//  Created by VD on 2017/8/30.
//  Copyright © 2017年 vd. All rights reserved.
//

#import "RCIMSelectContactListCell.h"

@implementation RCIMSelectContactListCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        
    }
    return self;
}
- (void)setModel:(id)model
{
    [super setModel:model];
    RCUserInfoData * data = model;
    @weakify(self);
    [RACObserve(data, isSelected)subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        self.selectButton.selected = [x boolValue];
    }];
    RAC(self.selectButton,enabled) = RACObserve(data,enabled);
}

@end
