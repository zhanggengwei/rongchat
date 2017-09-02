//
//  RCConversationListCell.m
//  rongchat
//
//  Created by vd on 2016/12/18.
//  Copyright © 2016年 vd. All rights reserved.
//

#import "RCConversationListCell.h"
#import "RCThemeDefine.h"
#import "UIImage+RCIMExtension.h"
#import "PPViewUtil.h"


@interface RCIMRemindLabel : UILabel

@end

@implementation RCIMRemindLabel

- (CGSize)intrinsicContentSize
{
    if (!self.text.length) {
        return CGSizeZero;
    } else {
        CGSize size = [PPViewUtil sizeWithString:self.text font:self.font constrainedToSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) lineBreakMode:NSLineBreakByCharWrapping];
        self.layer.cornerRadius = MIN(size.height,size.width) * 0.5;
        return CGSizeMake(size.width+6, size.height);
    }
}

- (void)setText:(NSString *)text
{
    text = [text integerValue]?text:@"";
    [super setText:text];
}

@end

@interface RCConversationListCell ()

@property (nonatomic,strong) UIImageView * avaturImageView;//接受者的头像
@property (nonatomic,strong) UILabel * receiveLabel;// 接受者的名字
@property (nonatomic,strong) UILabel * contentLabel;// 最后的一条消息
@property (nonatomic,strong) UILabel * timeLabel;//受到最后一条消息的时间
@property (nonatomic,strong) RCIMRemindLabel * reamindLabel;
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
        [self createUI];
    }
    return self;
}
- (void)createUI
{
    
    [self.contentView addSubview:self.avaturImageView];
    [self.avaturImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_left).mas_offset(10);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.top.mas_equalTo(self.contentView.mas_top).mas_offset(10);
        make.width.mas_equalTo(self.avaturImageView.mas_height);
    }];
    [self.contentView addSubview:self.timeLabel];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.contentView.mas_right).mas_offset(-15);
        make.height.mas_equalTo(15);
        make.top.mas_equalTo(self.avaturImageView.mas_top);
    }];
    [self.contentView addSubview:self.receiveLabel];
    [self.receiveLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.avaturImageView.mas_right).mas_offset(8);
        make.top.mas_equalTo(self.avaturImageView.mas_top).mas_offset(4);
        make.right.lessThanOrEqualTo(self.timeLabel.mas_left).mas_offset(-10);
    }];
    
    [self.contentView addSubview:self.contentLabel];
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.receiveLabel.mas_left);
        make.top.mas_equalTo(self.receiveLabel.mas_bottom).mas_offset(4);
        make.width.mas_equalTo(self.receiveLabel.mas_width);
    }];
   
    [self.contentView addSubview:self.reamindLabel];
    [self.reamindLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.avaturImageView.mas_right);
        make.centerY.mas_equalTo(self.avaturImageView.mas_top);
        make.width.mas_greaterThanOrEqualTo(self.reamindLabel.mas_height).multipliedBy(1);
    }];
    
    

}

- (void)setConversation:(RCConversation *)conversation
{
    NSString * avatarUrl = nil;
    UIImage * placeHolderImage = nil;
    if(conversation.conversationType == ConversationType_GROUP)
    {
        avatarUrl = [[PPTUserInfoEngine shareEngine].contactGroupList filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"self.group.indexId = %@",conversation.targetId]].firstObject.group.portraitUri;
        placeHolderImage = RCIM_CONTACT_GROUP_ARATARIMAGE;
        if(![avatarUrl isValid])
        {
             avatarUrl = @"";
        }
        SD_LOADIMAGE(self.avaturImageView, avatarUrl,placeHolderImage);
    }else
    {
        placeHolderImage = RCIM_PLACE_ARATARIMAGE;
    }
    [[PPTUserInfoEngine shareEngine]queryUserInfoWithUserId:conversation.targetId resultCallback:^(RCUserInfoData *userInfo) {
        if (conversation.conversationType==ConversationType_PRIVATE)
        {
            SD_LOADIMAGE(self.avaturImageView, userInfo.user.portraitUri,placeHolderImage);
        }
        self.receiveLabel.text = userInfo.user.name;
    }];
    self.contentLabel.text = [self loadRecentConversation:conversation];
    self.reamindLabel.text = @(conversation.unreadMessageCount).stringValue;
}

- (NSString *)loadRecentConversation:(RCConversation *)conversation
{
    if([conversation.lastestMessage isKindOfClass:[RCTextMessage class]])
    {
        RCTextMessage * textMessage = (RCTextMessage *)conversation.lastestMessage;
        return textMessage.content;
    }else if ([conversation.lastestMessage isKindOfClass:[RCImageMessage class]])
    {
        return @"图片";
    }else if ([conversation.lastestMessage isKindOfClass:[RCVoiceMessage class]])
    {
        return @"语音";
    }
    return @"UNKOWN MESSAGE";
}


- (UIImageView *)avaturImageView
{
    if(_avaturImageView==nil)
    {
        _avaturImageView = [UIImageView new];
        _avaturImageView.layer.cornerRadius = 2;
        _avaturImageView.layer.masksToBounds = YES;
    }
    return _avaturImageView;
}


- (RCIMRemindLabel *)reamindLabel
{
    if(_reamindLabel==nil)
    {
        _reamindLabel = [RCIMRemindLabel new];
        _reamindLabel.backgroundColor = RCIM_REMIND_COLOR;
        _reamindLabel.font = [UIFont systemFontOfSize:12];
        _reamindLabel.layer.masksToBounds = YES;
        _reamindLabel.textColor = [UIColor whiteColor];
        _reamindLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _reamindLabel;
}

- (UILabel *)contentLabel
{
    if(_contentLabel==nil)
    {
        _contentLabel = [UILabel new];
        _contentLabel.font = [UIFont systemFontOfSize:13];
        _contentLabel.textColor = UIColorFromRGB(0xa2a2a2);
    }
    return _contentLabel;
}


- (UILabel *)timeLabel
{
    if(_timeLabel==nil)
    {
        _timeLabel = [UILabel new];
        _timeLabel.textAlignment = NSTextAlignmentRight;
        _timeLabel.textColor = UIColorFromRGB(0xa2a2a2);
        _timeLabel.font = [UIFont systemFontOfSize:12];
    }
    return _timeLabel;
}

- (UILabel *)receiveLabel
{
    if(_receiveLabel==nil)
    {
        _receiveLabel = [UILabel new];
        _receiveLabel.font = [UIFont systemFontOfSize:15];
    }
    return _receiveLabel;
}
@end
