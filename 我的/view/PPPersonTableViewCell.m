//
//  PPPersonTableViewCell.m
//  rongChatDemo1
//
//  Created by vd on 2016/11/1.
//  Copyright © 2016年 vd. All rights reserved.
//

#import "PPPersonTableViewCell.h"
//@class PPPersonal;
#define ImageHeight 60

@interface PPPersonTableViewCell ()
@property (nonatomic,strong) UIImageView * leftIcon;
@property (nonatomic,strong) UIImageView * rightIcon;
@property (nonatomic,strong) UILabel * contentLabel;
@property (nonatomic,assign) PPPersonTableViewCellStyle style;


@end

@implementation PPPersonTableViewCell

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
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        [self createUI];
        
    }
    return self;
}
- (void)createUI
{
    self.leftIcon = [UIImageView new];
    self.rightIcon = [UIImageView new];
    self.contentLabel = [UILabel new];
    [self.contentView addSubview:self.leftIcon];
    [self.contentView addSubview:self.rightIcon];
    [self.contentView addSubview:self.contentLabel];
    
    [self.leftIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_left).mas_offset(10);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.width.mas_equalTo(26);
        make.height.mas_equalTo(25);
        
    }];
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.leftIcon.mas_right).mas_offset(15);
        make.top.mas_equalTo(self.leftIcon.mas_top).mas_offset(5);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(15);
    }];
    
    
    [self.rightIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.contentView.mas_right).mas_offset(-5);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.width.mas_equalTo(14);
        make.height.mas_equalTo(14);
    }];
}

- (void)layoutData:(PPPersonTableViewCellStyle)style cellModel:(PPPersonal *)model
{
    if(style==PPPersonTableViewCellDefault)
    {
        self.rightIcon.hidden = YES;
        [self.leftIcon mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(26);
            make.height.mas_equalTo(25);
        }];
    }else
    {
        
        self.rightIcon.hidden = NO;
        [self.leftIcon mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(ImageHeight);
            make.height.mas_equalTo(ImageHeight);
        }];
    }
    self.leftIcon.image = IMAGE(model.leftIconName);
    //[UIImage imageNamed:model.leftIconName];
    self.rightIcon.image  = IMAGE(model.rightIconName);
    self.contentLabel.text = model.content;
    
}





@end
