//
//  RCIMPublicServiceCell.m
//  rongchat
//
//  Created by VD on 2017/8/29.
//  Copyright © 2017年 vd. All rights reserved.
//

#import "RCIMPublicServiceCell.h"
#import "RCIMPublicServiceProfile.h"

@interface RCIMPublicServiceCell ()

@property (nonatomic,strong) UIImageView * avatarImageView;
@property (nonatomic,strong) UILabel * nameLabel;

@end

@implementation RCIMPublicServiceCell

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
    [self.contentView addSubview:self.avatarImageView];
    self.nameLabel = [UILabel new];
    self.nameLabel.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:self.nameLabel];
    
    [self.avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_left).mas_offset(16);
        make.centerY.mas_equalTo(self.contentView);
        make.top.mas_equalTo(self.contentView.mas_top).mas_offset(8);
        make.width.mas_equalTo(self.avatarImageView.mas_height).multipliedBy(1);
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView);
        make.left.mas_equalTo(self.avatarImageView.mas_right).mas_offset(16);
        make.right.mas_equalTo(self.contentView.mas_right).mas_offset(-8);
    }];
    
}

- (void)setModel:(RCIMPublicServiceProfile *)model
{
    SD_LOADIMAGE(self.avatarImageView,model.model.portraitUrl, nil);
    self.nameLabel.text = model.model.name;
}


@end
