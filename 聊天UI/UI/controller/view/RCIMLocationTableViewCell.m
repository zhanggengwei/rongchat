//
//  RCIMLocationTableViewCell.m
//  rongchat
//
//  Created by VD on 2017/8/10.
//  Copyright © 2017年 vd. All rights reserved.
//

#import "RCIMLocationTableViewCell.h"

@interface RCIMLocationTableViewCell ()
@property (nonatomic,strong) UILabel * titleLabel;
@property (nonatomic,strong) UILabel * extraLabel;
@end

@implementation RCIMLocationTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self createUI];
    // Initialization code
}
- (void)prepareForReuse
{
    [super prepareForReuse];
    self.extraLabel.text = @"";
    self.titleLabel.text = @"";
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        [self createUI];
    }
    return self;
}

- (void)createUI
{
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.extraLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.contentView).mas_offset(UIEdgeInsetsMake(5, 16, 5, 16));
    }];
    [self.extraLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(0);
        make.left.right.mas_equalTo(self.titleLabel);
        make.top.mas_equalTo(self.titleLabel.mas_bottom).mas_offset(10);
    }];
    
}

- (UILabel *)extraLabel
{
    if(_extraLabel==nil)
    {
        _extraLabel = [UILabel new];
        _extraLabel.font = [UIFont systemFontOfSize:12];
        _extraLabel.textColor = UIColorFromRGB(0xa2a2a2);
    }
    return _extraLabel;
}

- (UILabel *)titleLabel
{
    if(_titleLabel==nil)
    {
        _titleLabel = [UILabel new];
        _titleLabel.font = [UIFont systemFontOfSize:15];
    }
    return _titleLabel;
}

- (void)setArea:(AMapPOI *)area
{
    self.titleLabel.text = area.name;
    self.extraLabel.text = area.address;
}

@end
