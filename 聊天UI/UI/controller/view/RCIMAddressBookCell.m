//
//  RCIMAddressBookCell.m
//  rongchat
//
//  Created by VD on 2017/9/1.
//  Copyright © 2017年 vd. All rights reserved.
//

#import "RCIMAddressBookCell.h"

@implementation RCIMAddressModel

- (NSString *)portraitUri
{
    if(_portraitUri==nil)
    {
        return @"";
    }
    return _portraitUri;
}

@end

@interface RCIMAddressBookCell ()

@property (nonatomic,strong) UILabel * nameLabel;
@property (nonatomic,strong) UILabel * detailLabel;
@property (nonatomic,strong) UIImageView * avatarImageView;
@property (nonatomic,strong) UIButton * addButton;

@end

@implementation RCIMAddressBookCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
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
    [self.contentView addSubview:self.avatarImageView];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.detailLabel];
    [self.contentView addSubview:self.addButton];
    
    [self.avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_left).mas_offset(10);
        make.top.mas_equalTo(self.contentView.mas_top).mas_offset(10);
        make.bottom.mas_equalTo(self.contentView.mas_bottom).mas_offset(-10);
        make.width.mas_equalTo(self.contentView.mas_height).multipliedBy(1);
    }];
    
    [self.addButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.contentView.mas_right).mas_offset(-16);
        make.centerY.mas_equalTo(self.contentView);
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(50);
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.avatarImageView.mas_right).mas_offset(10);
        make.top.mas_equalTo(self.avatarImageView.mas_top);
        make.right.lessThanOrEqualTo(self.addButton.mas_left).mas_offset(-10);
    }];
    
    [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.nameLabel);
        make.top.mas_equalTo(self.nameLabel.mas_bottom).mas_offset(8);
    }];
}

- (UIImageView *)avatarImageView
{
    if(_avatarImageView == nil)
    {
        _avatarImageView = [UIImageView new];
    }
    return _avatarImageView;
}

- (UILabel *)nameLabel
{
    if(_nameLabel==nil)
    {
        _nameLabel = [UILabel new];
        _nameLabel.font = [UIFont systemFontOfSize:14];
    }
    return _nameLabel;
}

- (UILabel *)detailLabel
{
    if(_detailLabel==nil)
    {
        _detailLabel = [UILabel new];
        _detailLabel.font = [UIFont systemFontOfSize:12];
        _detailLabel.textColor = UIColorFromRGB(0xa2a2a2);
    }
    return _detailLabel;
}

- (UIButton *)addButton
{
    if(_addButton==nil)
    {
        _addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    }
    return _addButton;
}

- (void)setModel:(RCIMAddressModel *)model
{
    _model = model;
    SD_LOADIMAGE(self.avatarImageView,model.portraitUri, nil);
    self.nameLabel.text = model.userName;
    self.detailLabel.text = model.name;
    [RACObserve(self.model, add)subscribeNext:^(id  _Nullable x) {
        BOOL add = [x boolValue];
        if(add)
        {
            
        }else
        {
            
        }
    }];
    
}

@end
