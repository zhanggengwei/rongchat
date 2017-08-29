//
//  RCIMAddContactCell.m
//  rongchat
//
//  Created by VD on 2017/8/29.
//  Copyright © 2017年 vd. All rights reserved.
//

#import "RCIMAddContactCell.h"
#import "NSString+isValid.h"
@interface RCIMAddContactCell ()
@property (nonatomic,strong) UIImageView * avatarImageView;
@property (nonatomic,strong) UILabel * nickNameLabel;
@property (nonatomic,strong) UILabel * messageLabel;
@property (nonatomic,strong) UIButton * addContactButton;
@property (nonatomic,strong) UIView * bottomLineView;
@end

@implementation RCIMAddContactCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        [self createUI];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)createUI
{
    self.avatarImageView = [UIImageView new];
    self.nickNameLabel = [UILabel new];
    self.nickNameLabel.textAlignment = NSTextAlignmentLeft;
    self.nickNameLabel.font = [UIFont systemFontOfSize:14];
    self.messageLabel = [UILabel new];
    self.messageLabel.textAlignment = NSTextAlignmentLeft;
    self.messageLabel.font = [UIFont systemFontOfSize:12];
    self.messageLabel.textColor = UIColorFromRGB(0x727272);
    self.addContactButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.bottomLineView = [UIView new];
    
    [self.contentView addSubview:self.avatarImageView];
    [self.contentView addSubview:self.nickNameLabel];
    [self.contentView addSubview:self.messageLabel];
    [self.contentView addSubview:self.addContactButton];
    [self.contentView addSubview:self.bottomLineView];
    
    [self.avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_left).mas_offset(8);
        make.top.mas_equalTo(self.contentView.mas_top).mas_offset(8);
        make.bottom.mas_equalTo(self.contentView.mas_bottom).mas_offset(-8);
        make.height.mas_equalTo(self.avatarImageView.mas_width).multipliedBy(1);
        
    }];
    
    [self.bottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.avatarImageView);
        make.right.mas_equalTo(self.contentView);
        make.height.mas_equalTo(0.5);
        make.bottom.mas_equalTo(self.contentView.mas_bottom);
    }];
    self.bottomLineView.backgroundColor = UIColorFromRGB(0xd3d5d7);
    [self.addContactButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(30);
        make.centerY.mas_equalTo(self.contentView);
        make.right.mas_equalTo(self.contentView.mas_right).mas_offset(-16);
        make.width.mas_equalTo(50);
    }];
    
    [self.nickNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.avatarImageView.mas_right).mas_offset(16);
        make.right.mas_equalTo(self.addContactButton.mas_left).mas_offset(-16);
        make.top.mas_equalTo(self.avatarImageView.mas_top);
    }];
    [self.messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.nickNameLabel);
        make.top.mas_equalTo(self.nickNameLabel.mas_bottom).mas_offset(8);
    }];
}

- (void)setModel:(RCUserInfoData *)model
{
    self.nickNameLabel.text = [model.displayName isValid]?model.displayName:model.user.name;
    self.messageLabel.text = model.message;
    
}

@end
