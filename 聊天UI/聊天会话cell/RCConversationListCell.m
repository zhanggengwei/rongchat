//
//  RCConversationListCell.m
//  rongchat
//
//  Created by vd on 2016/12/18.
//  Copyright © 2016年 vd. All rights reserved.
//

#import "RCConversationListCell.h"
#import "RCThemeDefine.h"
@interface RCConversationListCell ()

@property (nonatomic,assign) RCUserAvatarStyle avatarStyle;// 头像的类型
@property (nonatomic,strong) UIImageView * avaturImageView;//接受者的头像
@property (nonatomic,strong) UILabel * receiveLabel;// 接受者的名字
@property (nonatomic,strong) UILabel * contentLabel;// 最后的一条消息
@property (nonatomic,strong) UILabel * timeLabel;//受到最后一条消息的时间

@end

@implementation RCConversationListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    // Initialization code
}




- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        self.avatarSizeWidth = 36;
        self.avatarStyle = RC_USER_AVATAR_RECTANGLE;
        [self createUI];
        
    }
    return self;
}
- (void)createUI
{
    self.avaturImageView = [UIImageView new];
    [self.contentView addSubview:self.avaturImageView];
    [self.avaturImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_left).mas_offset(15);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.width.mas_equalTo(self.avatarSizeWidth);
        make.height.mas_equalTo(self.avatarSizeWidth);
    }];
    self.timeLabel = [UILabel new];
    [self.contentView addSubview:self.timeLabel];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.contentView.mas_right).mas_offset(-15);
        make.width.lessThanOrEqualTo(@200);
        make.height.mas_equalTo(15);
        make.top.mas_equalTo(self.avaturImageView.mas_top);
    }];
    self.timeLabel.textAlignment = NSTextAlignmentRight;
    self.timeLabel.textColor = UIColorFromRGB(0xa2a2a2);
    self.timeLabel.font = [UIFont systemFontOfSize:11];
    self.receiveLabel = [UILabel new];
    [self.contentView addSubview:self.receiveLabel];
    [self.receiveLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.avaturImageView.mas_right).mas_offset(5);
        make.top.mas_equalTo(self.avaturImageView.mas_top);
        make.height.mas_equalTo(15);
        make.right.mas_equalTo(self.timeLabel.mas_left).mas_offset(-10);
    }];
    
    self.contentLabel = [UILabel new];
    [self.contentView addSubview:self.contentLabel];
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.receiveLabel.mas_left);
        make.bottom.mas_equalTo(self.contentView.mas_bottom).mas_offset(-5);
        make.height.mas_equalTo(15);
        make.width.mas_equalTo(self.receiveLabel.mas_width);
    }];
    self.receiveLabel.font = [UIFont systemFontOfSize:14];
    self.contentLabel.font = [UIFont systemFontOfSize:12];
    self.contentLabel.textColor = UIColorFromRGB(0xa2a2a2);

}

- (void)setConversation:(RCConversation *)conversation avatarStyle:(RCUserAvatarStyle)style
{
    
    if([conversation.objectName isEqualToString:RCTextMessageTypeIdentifier])
    {
        RCTextMessage * message = (RCTextMessage *)conversation.lastestMessage;
        
        self.contentLabel.text = message.content;
        
        RCUserInfo * info = [[RCConversationCacheObj shareManager] searchUserInfoByUserId:conversation.targetId];
        if(info)
        {
            [self.avaturImageView sd_setImageWithURL:[NSURL URLWithString:info.portraitUri]];
            self.receiveLabel.text = info.name;
            
        }else
        {
           
        }
        
    }
    self.timeLabel.text = @"2012...";
   // self.ContentLabel.text = conversation.lastestMessage.t
}

@end
