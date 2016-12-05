//
//  PPContactListCell.m
//  rongChatDemo1
//
//  Created by vd on 2016/11/3.
//  Copyright © 2016年 vd. All rights reserved.
//

#import "PPContactListCell.h"
#import "UITableViewCell+addLineView.h"
@interface PPContactListCell ()
@property (nonatomic,strong) UIImageView * leftIconView;
@property (nonatomic,strong) UILabel * contentLabel;


@end

@implementation PPContactListCell

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
    self.leftIconView = [UIImageView new];
    [self.contentView addSubview:self.leftIconView];
    
    self.contentLabel = [UILabel new];
    [self.contentView addSubview:self.contentLabel];
    
    [self.leftIconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).mas_offset(15);
        make.top.mas_equalTo(self.mas_top).mas_offset(10);
        make.bottom.mas_equalTo(self.mas_bottom).mas_offset(-10);
        make.width.mas_equalTo(self.frame.size.height - 15);
    }];
    
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.height.mas_equalTo(@16);
        make.left.mas_equalTo(self.leftIconView.mas_right).mas_offset(10);
        make.right.mas_equalTo(self.contentView.mas_right);
        
    }];
    
    self.contentLabel.font = [UIFont systemFontOfSize:14];
    self.contentLabel.textAlignment = NSTextAlignmentLeft;
    [self addBottomLine];
    
    
    
}
- (void)setLeftIconImageNamed:(NSString *)imageName andRightContentLabel:(NSString *)content
{
 
    NSLog(@"imageName ==%@",imageName);
    if([imageName containsString:@"//"])
    {
        SD_LOADIMAGE(self.leftIconView, imageName, nil);
    }else
    {
       self.leftIconView.image = [UIImage imageNamed:imageName];
    }
    self.contentLabel.text = content;
}


@end
