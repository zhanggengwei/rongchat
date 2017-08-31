//
//  RCIMAddContactTableViewCell.m
//  rongchat
//
//  Created by VD on 2017/9/1.
//  Copyright © 2017年 vd. All rights reserved.
//

#import "RCIMAddContactTableViewCell.h"
#import "RCIMAddContactModel.h"

@interface RCIMAddContactTableViewCell ()
@property (nonatomic,strong) UIImageView * avatarImageView;
@property (nonatomic,strong) UILabel * titleLabel;
@property (nonatomic,strong) UILabel * detailLabel;

@end

@implementation RCIMAddContactTableViewCell

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
    [self.contentView addSubview:self.avatarImageView];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.detailLabel];
    [self.avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.contentView).mas_offset(UIEdgeInsetsMake(8, 8, 8, 8));
        make.width.mas_equalTo(self.avatarImageView.mas_height).multipliedBy(1);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(self.avatarImageView.mas_right);
//        make.right.lessThanOrEqualTo(self.contentView);
       // make.top.mas_equalTo(self.avatarImageView.mas_top);
    }];
//    [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.right.mas_equalTo(self.titleLabel);
//        make.top.mas_equalTo(self.titleLabel.mas_bottom).mas_offset(4);
//    }];
    
    
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

- (void)setModel:(RCIMAddContactModel *)model
{
    [super setModel:model];
    self.titleLabel.text = model.title;
    self.detailLabel.text = model.detail;
    self.avatarImageView.image = [UIImage imageNamed:model.imageName];
    
}

@end
