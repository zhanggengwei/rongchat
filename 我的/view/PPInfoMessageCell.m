//
//  PPInfoMessageCell.m
//  rongChatDemo1
//
//  Created by Donald on 16/11/7.
//  Copyright © 2016年 vd. All rights reserved.
//

#import "PPInfoMessageCell.h"

@interface PPInfoMessageCell ()
@property (nonatomic,strong) UILabel * leftLabel;
@property (nonatomic,strong) UIImageView * iconView;

@end

@implementation PPInfoMessageCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        [self createUI];
    }
    return self;
}


- (void)awakeFromNib
{
    [super awakeFromNib];
    // Initialization code
}
- (void)createUI
{
    self.leftLabel = [UILabel new];
    self.iconView = [UIImageView new];
    
    [self.contentView addSubview:self.leftLabel];
    [self.contentView addSubview:self.iconView];
    
    [self.leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_left).mas_offset(15);
        make.width.mas_equalTo(@150);
        make.top.mas_equalTo(self.contentView.mas_top);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
    }];
    
    
    [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.contentView.mas_right);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.height.mas_equalTo(90);
        make.width.mas_equalTo(90);
    }];
    self.leftLabel.font = [UIFont systemFontOfSize:14];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)layoutLeftContent:(NSString *)content rightImage:(id)obj imageWidth:(CGFloat)width
{
    self.leftLabel.text = content;
    if([obj isKindOfClass:[UIImage class]])
    {
        self.iconView.image = obj;
        
    }else
    {
        [self.iconView sd_setImageWithURL:[NSURL URLWithString:obj]];
        
    }
    
    [self.iconView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(width);
        make.height.mas_equalTo(width);
    }];
}
@end
