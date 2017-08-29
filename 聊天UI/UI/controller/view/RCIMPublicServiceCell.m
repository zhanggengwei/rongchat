//
//  RCIMPublicServiceCell.m
//  rongchat
//
//  Created by VD on 2017/8/29.
//  Copyright © 2017年 vd. All rights reserved.
//

#import "RCIMPublicServiceCell.h"

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
    [self.contentView addSubview:self.nameLabel];
    
    [self.avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.
    }];
}

- (void)setModel:(RCPublicServiceProfile *)model
{
    
}


@end
