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
@property (nonatomic,strong) UIImageView * avatarImageView;
@property (nonatomic,strong) UILabel * nickNameLabel;

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
    self.avatarImageView = [UIImageView new];
    [self.contentView addSubview:self.avatarImageView];
    
    self.nickNameLabel = [UILabel new];
    self.nickNameLabel.numberOfLines = 0;
    [self.contentView addSubview:self.nickNameLabel];
    
    [self.avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).mas_offset(15);
        make.top.mas_equalTo(self.mas_top).mas_offset(10);
        make.bottom.mas_equalTo(self.mas_bottom).mas_offset(-10);
        make.width.mas_equalTo(self.frame.size.height - 15);
    }];
    
    [self.nickNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.left.mas_equalTo(self.avatarImageView.mas_right).mas_offset(10);
        make.right.mas_equalTo(self.contentView.mas_right);
        make.height.mas_equalTo(@16);
    }];
    self.nickNameLabel.font = [UIFont systemFontOfSize:14];
    self.nickNameLabel.textAlignment = NSTextAlignmentLeft;
    [self addBottomLine];
}
- (void)setModel:(id)model
{
    if([model isKindOfClass:[PPTContactGroupModel class]])
    {
        PPTContactGroupModel * contactGroup = model;
        _nickNameLabel.text = contactGroup.group.name;
        if(!contactGroup.group.portraitUri)
        {
            contactGroup.group.portraitUri = @"";
        }
        SD_LOADIMAGE(self.avatarImageView,contactGroup.group.portraitUri,nil);
    }else if([model isKindOfClass:[RCUserInfoData class]]){
        RCUserInfoData * userInfo = model;
        if(!userInfo.user.portraitUri)
        {
            userInfo.user.portraitUri = @"";
        }
        _nickNameLabel.text = userInfo.user.name;
        SD_LOADIMAGE(self.avatarImageView,userInfo.user.portraitUri,[UIImage imageNamed:userInfo.placeImage]);
    }
}
@end
