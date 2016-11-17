
//
//  PPSettingCell.m
//  rongChatDemo1
//
//  Created by vd on 2016/11/2.
//  Copyright © 2016年 vd. All rights reserved.
//

#import "PPSettingCell.h"

@interface PPSettingCell ()
@property (nonatomic,strong) UILabel * contentLabel;
@property (nonatomic,strong) UILabel * rightLabel;
@end

@implementation PPSettingCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
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
    self.contentLabel = [UILabel new];
    [self.contentView addSubview:self.contentLabel];
    self.contentLabel.font = [UIFont systemFontOfSize:15];
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.right.mas_equalTo(self.contentView.mas_right).mas_offset(-15);
        make.height.mas_equalTo(15);
        make.left.mas_equalTo(self.contentView.mas_left).mas_equalTo(15);
    }];
    
    
    self.rightLabel = [UILabel new];
    [self.contentView addSubview:self.contentLabel];
    
    [self.detailTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.contentView.mas_right).mas_offset(-10);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(@16);
    }];
    self.detailTextLabel.textAlignment = NSTextAlignmentRight;
    self.contentLabel.font = [UIFont systemFontOfSize:14];
    self.detailTextLabel.textColor = [UIColor grayColor];
}
- (void)layoutContent:(NSString *)content textAligent:(NSTextAlignment)alignent
{
    self.contentLabel.text = content;
    self.contentLabel.textAlignment = alignent;
    
}

- (void)layoutContent:(NSString *)content textAligent:(NSTextAlignment)alignent andDetailText:(NSString *)text
{
    self.contentLabel.text = content;
    self.contentLabel.textAlignment = alignent;
    self.detailTextLabel.text = text;
    
}


@end
