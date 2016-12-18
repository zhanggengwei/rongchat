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
@property (nonatomic,strong) UILabel * ContentLabel;// 最后的一条消息
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
        make.right.mas_equalTo(self.contentView.mas_right).mas_offset(-5);
        make.width.mas_equalTo(10);
        make.height.mas_equalTo(15);
        make.top.mas_equalTo(self.avaturImageView.mas_top);
    }];
    
    self.receiveLabel = [UILabel new];
    [self.contentView addSubview:self.receiveLabel];
    [self.receiveLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.avaturImageView.mas_right).mas_offset(5);
        make.top.mas_equalTo(self.avaturImageView.mas_top);
        make.height.mas_equalTo(15);
        make.right.mas_equalTo(self.timeLabel.mas_left).mas_offset(-10);
    }];
    
    self.ContentLabel = [UILabel new];
    [self.contentView addSubview:self.ContentLabel];
    [self.ContentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.receiveLabel.mas_left);
        make.bottom.mas_equalTo(self.contentView.mas_bottom).mas_offset(-5);
        make.height.mas_equalTo(15);
        make.width.mas_equalTo(self.receiveLabel.mas_width);
    }];

}

- (void)setConversation:(RCConversation *)conversation avatarStyle:(RCUserAvatarStyle)style
{
    
    if([conversation.objectName isEqualToString:RCTextMessageTypeIdentifier])
    {
        RCTextMessage * message = (RCTextMessage *)conversation.lastestMessage;
        
        self.ContentLabel.text = message.content;
        
    }
   // self.ContentLabel.text = conversation.lastestMessage.t
}

@end
