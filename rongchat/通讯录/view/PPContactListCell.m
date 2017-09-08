//
//  PPContactListCell.m
//  rongChatDemo1
//
//  Created by vd on 2016/11/3.
//  Copyright © 2016年 vd. All rights reserved.
//
#define UNREADWIDTH 15
#import "PPContactListCell.h"
#import "UIImage+RCIMExtension.h"

@interface PPContactListCell ()
@property (nonatomic,strong) UIImageView * avatarImageView;
@property (nonatomic,strong) UILabel * nickNameLabel;
@property (nonatomic,strong) UILabel * unreadLabel;
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

- (void)prepareForReuse
{
    [super prepareForReuse];
    self.unreadLabel.hidden = YES;
}

- (void)createUI
{

    [self.contentView addSubview:self.unreadLabel];
    [self.contentView addSubview:self.avatarImageView];
    [self.contentView addSubview:self.nickNameLabel];
    
    [self.avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_left).mas_offset(8);
        make.top.mas_equalTo(self.mas_top).mas_offset(8);
        make.bottom.mas_equalTo(self.mas_bottom).mas_offset(-8);
        make.width.mas_equalTo(self.avatarImageView.mas_height).multipliedBy(1);
    }];
    [self.nickNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.left.mas_equalTo(self.avatarImageView.mas_right).mas_offset(10);
        make.right.mas_lessThanOrEqualTo(self.contentView.mas_right).mas_offset(-100);
    }];
    [self.unreadLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.nickNameLabel.mas_right).mas_offset(16);
        make.centerY.mas_equalTo(self.contentView);
        make.width.height.mas_equalTo(UNREADWIDTH);
    }];
}

- (void)setUnreadCount:(NSInteger)unreadCount
{
    if(unreadCount)
    {
        self.unreadLabel.hidden = NO;
        self.unreadLabel.text = @(unreadCount).stringValue;
    }else
    {
        self.unreadLabel.hidden = YES;
    }
}

- (UIImageView *)avatarImageView
{
    if(_avatarImageView==nil)
    {
        _avatarImageView = [UIImageView new];
    }
    return _avatarImageView;
}

- (UILabel *)unreadLabel
{
    if(_unreadLabel==nil)
    {
        _unreadLabel = [UILabel new];
        _unreadLabel.textAlignment = NSTextAlignmentCenter;
        _unreadLabel.textColor = [UIColor whiteColor];
        _unreadLabel.backgroundColor = [UIColor redColor];
        _unreadLabel.layer.masksToBounds = YES;
        _unreadLabel.layer.cornerRadius = UNREADWIDTH/2.0;
        _unreadLabel.font = [UIFont systemFontOfSize:12];
        _unreadLabel.hidden = YES;
    }
    return _unreadLabel;
}

- (UILabel *)nickNameLabel
{
    if(_nickNameLabel==nil)
    {
        _nickNameLabel = [UILabel new];
        _nickNameLabel.numberOfLines = 0;
        _nickNameLabel.font = [UIFont systemFontOfSize:14];
        _nickNameLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _nickNameLabel;
}

- (void)setModel:(id)model
{
    [super setModel:model];
    if([model isKindOfClass:[PPTContactGroupModel class]])
    {
        NSString *imageName = @"Placeholder_Avatar";
        UIImage *image = [UIImage RCIM_imageNamed:imageName bundleName:@"Placeholder" bundleForClass:[self class]];
        PPTContactGroupModel * contactGroup = model;
        _nickNameLabel.text = contactGroup.group.name;
        if(!contactGroup.group.portraitUri)
        {
            contactGroup.group.portraitUri = @"";
        }
        SD_LOADIMAGE(self.avatarImageView,contactGroup.group.portraitUri,image);
    }else if([model isKindOfClass:[RCIMContactListModelItem class]]){
        RCIMContactListModelItem * item = model;
        if(!item.model.user.portraitUri)
        {
            item.model.user.portraitUri = @"";
        }
        _nickNameLabel.text = item.model.user.name;
        SD_LOADIMAGE(self.avatarImageView,item.model.user.portraitUri,[UIImage imageNamed:item.placeImage]);
    }
}
@end
