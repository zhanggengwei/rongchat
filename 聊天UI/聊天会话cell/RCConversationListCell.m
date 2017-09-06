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
#import "PPImageUtil.h"
#import "RCIMConversationModel.h"


@interface RCConversation (RCConversationList)
- (void)loadConversationData:(void(^)(NSString * title))block;

@end


@interface RCIMRemindButton : UIButton

@end

@implementation RCIMRemindButton

- (CGSize)intrinsicContentSize
{
    if (!self.titleLabel.text.length) {
        return CGSizeZero;
    } else {
        CGSize size = [PPViewUtil sizeWithString:self.titleLabel.text font:self.titleLabel.font constrainedToSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) lineBreakMode:NSLineBreakByCharWrapping];
        self.layer.cornerRadius = MIN(size.height,size.width) * 0.5;
        return CGSizeMake(size.width+6, size.height);
    }
}

- (void)setTitle:(NSString *)title forState:(UIControlState)state
{
    title = [title integerValue]?title:@"";
    [super setTitle:title forState:state];
    
}

@end

@interface RCConversationListCell ()

@property (nonatomic,strong) UIImageView * avaturImageView;//接受者的头像
@property (nonatomic,strong) UILabel * receiveLabel;// 接受者的名字
@property (nonatomic,strong) UILabel * contentLabel;// 最后的一条消息
@property (nonatomic,strong) UILabel * timeLabel;//受到最后一条消息的时间
@property (nonatomic,strong) RCIMRemindButton * reamindButton;
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
        make.top.mas_equalTo(self.avaturImageView.mas_top);
        make.right.lessThanOrEqualTo(self.timeLabel.mas_left).mas_offset(-10);
    }];
    
    [self.contentView addSubview:self.contentLabel];
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.receiveLabel.mas_left);
        make.top.mas_equalTo(self.receiveLabel.mas_bottom).mas_offset(4);
        make.width.mas_equalTo(self.receiveLabel.mas_width);
    }];
   
    [self.contentView addSubview:self.reamindButton];
    [self.reamindButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.avaturImageView.mas_right);
        make.centerY.mas_equalTo(self.avaturImageView.mas_top);
        make.width.mas_greaterThanOrEqualTo(self.reamindButton.mas_height).multipliedBy(1);
    }];
    
    

}

- (void)setConversation:(RCConversation *)conversation
{
    
    [[[RCIMConversationModel new]loadDataConversation:conversation]subscribeNext:^(RCIMConversationModel * model) {
//        self.contentLabel.text = model.message;
        self.receiveLabel.text = model.title;
        SD_LOADIMAGE(self.avaturImageView, model.avatarUrl,model.placeHolerImage);
    }];
     [self.reamindButton setTitle:@(conversation.unreadMessageCount).stringValue forState:UIControlStateNormal];
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


- (RCIMRemindButton *)reamindButton
{
    if(_reamindButton==nil)
    {
        _reamindButton = [RCIMRemindButton new];
        [_reamindButton setBackgroundImage:[PPImageUtil imageFromColor:RCIM_REMIND_COLOR] forState:UIControlStateDisabled];
        _reamindButton.enabled = NO;
        _reamindButton.titleLabel.font = [UIFont systemFontOfSize:12];
        _reamindButton.layer.masksToBounds = YES;
        [_reamindButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    return _reamindButton;
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
