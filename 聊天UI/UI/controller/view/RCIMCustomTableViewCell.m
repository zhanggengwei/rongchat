//
//  RCIMCustomTableViewCell.m
//  rongchat
//
//  Created by VD on 2017/9/2.
//  Copyright © 2017年 vd. All rights reserved.
//



#import "RCIMCustomTableViewCell.h"
@implementation RCIMCellItem
@end
@implementation RCIMCellCustomItem
@end
@implementation RCIMCellSwitchItem
@end
@implementation RCIMCellIconItem
@end

@interface RCIMTableViewCell ()
@property (nonatomic,strong) UILabel * nameLabel;
@end
@implementation RCIMTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        [self createUI];
    }
    return self;
}

-(void)createUI
{
    [self.contentView addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_left).mas_offset(12);
        make.centerY.mas_equalTo(self.contentView);
    }];
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

- (void)setModel:(RCIMCellItem *)model
{
    [super setModel:model];
    self.nameLabel.text = model.title;
}

@end

@interface RCIMCustomTableViewCell ()
@property (nonatomic,strong) UILabel * detailLabel;
@end

@implementation RCIMCustomTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    return self;
}

- (void)createUI
{
    [super createUI];
    [self.contentView addSubview:self.detailLabel];
    [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.contentView.mas_right);
        make.centerY.mas_equalTo(self.contentView);
    }];
    
}

- (UILabel *)detailLabel
{
    if(_detailLabel==nil)
    {
        _detailLabel = [UILabel new];
        _detailLabel.textColor = UIColorFromRGB(0xa2a2a2);
        _detailLabel.font = [UIFont systemFontOfSize:14];
    }
    return _detailLabel;
}

- (void)setModel:(RCIMCellCustomItem *)model
{
    [super setModel:model];
    self.detailLabel.text = model.detail;
}


@end

@interface RCIMSwithcTableViewCell ()
@property (nonatomic,strong) UISwitch * switchSender;
@end

@implementation RCIMSwithcTableViewCell

- (void)createUI
{
    [super createUI];
    [self.contentView addSubview:self.switchSender];
    [self.switchSender mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.contentView.mas_right).mas_offset(-12);
        make.centerY.mas_equalTo(self.contentView);
    }];
}

- (UISwitch *)switchSender
{
    if(_switchSender==nil)
    {
        _switchSender = [[UISwitch alloc]init];
    }
    return _switchSender;
}

- (void)setModel:(RCIMCellSwitchItem *)model
{
    [super setModel:model];
    [RACObserve(model, On)subscribeNext:^(id on) {
 
        [self.switchSender setOn:[on boolValue] animated:YES];
    }];
}

@end

@interface RCIMIconTableViewCell ()
@property (nonatomic,strong) UIImageView * icon;
@end

@implementation RCIMIconTableViewCell

- (void)createUI
{
    [super createUI];
    [self.contentView addSubview:self.icon];
    [self.icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.contentView.mas_right).mas_offset(-12);
        make.centerY.mas_equalTo(self.contentView);
        make.width.height.mas_equalTo(30);
    }];
}

- (UIImageView *)icon
{
    if(_icon==nil)
    {
        _icon = [UIImageView new];
    }
    return _icon;
}

- (void)setModel:(RCIMCellIconItem *)model
{
    [super setModel:model];
    if([model.imageName isValid])
    {
        self.icon.image = [UIImage imageNamed:model.imageName];
    }else
    {
        if([model.url isValid])
        {
            SD_LOADIMAGE(self.icon, model.url, nil);
        }
    }
}
@end
