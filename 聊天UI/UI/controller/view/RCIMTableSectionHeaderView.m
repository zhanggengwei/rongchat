//
//  RCIMTableSectionHeaderView.m
//  rongchat
//
//  Created by VD on 2017/8/31.
//  Copyright © 2017年 vd. All rights reserved.
//

#import "RCIMTableSectionHeaderView.h"

@interface RCIMTableSectionHeaderView ()
@property (nonatomic,strong) UILabel * titleLabel;
@end

@implementation RCIMTableSectionHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        [self createUI];
    }
    return self;
}

- (instancetype)init
{
    if(self = [super init])
    {
        [self createUI];
    }
    return self;
}

- (void)createUI
{
    [self addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).mas_offset(8);
        make.centerY.mas_equalTo(self);
    }];
    self.backgroundColor = [UIColor colorWithRed:239/255.0 green:239/255.0 blue:246/255.0 alpha:1];
}

- (UILabel *)titleLabel
{
    if(_titleLabel==nil)
    {
        _titleLabel = [UILabel new];
        _titleLabel.font = [UIFont systemFontOfSize:14];
        _titleLabel.textColor = UIColorFromRGB(0x727272);
    }
    return _titleLabel;
}
-(void)setTitle:(NSString *)title style:(RCIMTableSectionHeaderStyle)style
{
    self.style = style;
    self.titleLabel.text = title;
}

- (void)setStyle:(RCIMTableSectionHeaderStyle)style
{
    _style = style;
    if(style==RCIMTableSectionHeaderStyleCustom)
    {
        _titleLabel.textColor = UIColorFromRGB(0x727272);
    }else
    {
        _titleLabel.textColor = [UIColor greenColor];
    }
}

@end
