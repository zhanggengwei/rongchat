//
//  RCIMSelectContactListCell.m
//  rongchat
//
//  Created by VD on 2017/8/30.
//  Copyright © 2017年 vd. All rights reserved.
//

#import "RCIMSelectContactListCell.h"

@interface RCIMSelectContactListCell ()
@property (nonatomic,strong) UIButton * selectButton;
@property (nonatomic,strong) UIImageView * avatarImageView;
@property (nonatomic,strong) UILabel * nameLabel;
@end

@implementation RCIMSelectContactListCell
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
    [self.contentView addSubview:self.selectButton];
    [self.contentView addSubview:self.avatarImageView];
    [self.contentView addSubview:self.nameLabel];
    
    [self.selectButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_left).mas_offset(8);
        make.centerY.mas_equalTo(self.contentView);
    }];
    
    [self.avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.selectButton.mas_right).mas_offset(16);
        make.top.mas_equalTo(self.contentView.mas_top).mas_offset(8);
        make.bottom.mas_equalTo(self.contentView.mas_bottom).mas_offset(-8);
        make.width.mas_equalTo(self.avatarImageView.mas_height).multipliedBy(1);
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView);
        make.left.mas_equalTo(self.avatarImageView.mas_right).mas_offset(12);
        make.right.lessThanOrEqualTo(self.contentView).mas_offset(-30);
    }];
    
}

- (UIButton *)selectButton
{
    if(_selectButton==nil)
    {
        _selectButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_selectButton setBackgroundImage:[UIImage imageNamed:@"icon_checkbox_background"] forState:UIControlStateNormal];
        [_selectButton setBackgroundImage:[UIImage imageNamed:@"icon_checkbox_selected"] forState:UIControlStateSelected];
        [_selectButton setBackgroundImage:[UIImage imageNamed:@"icon_checkbox_unselected"] forState:UIControlStateDisabled];
        
    }
    return _selectButton;
}

- (UILabel *)nameLabel
{
    if(_nameLabel==nil)
    {
        _nameLabel = [UILabel new];
        _nameLabel.font = [UIFont systemFontOfSize:15];
    }
    return _nameLabel;
}

- (UIImageView *)avatarImageView
{
    if(_avatarImageView==nil)
    {
        _avatarImageView = [UIImageView new];
    }
    return _avatarImageView;
}


- (void)setModel:(id)model
{
    [super setModel:model];
    RCUserInfoData * data = model;
    [RACObserve(data, isSelected)subscribeNext:^(id  _Nullable x) {
        BOOL value = [x boolValue];
        self.selectButton.selected = value;
    }];
    
    [RACObserve(data, enabled)subscribeNext:^(id  _Nullable x) {
        BOOL value = [x boolValue];
        self.selectButton.enabled = value;
    }];
    
    SD_LOADIMAGE(self.avatarImageView, data.user.portraitUri, nil);
    self.nameLabel.text = data.user.name;
    
}

@end
