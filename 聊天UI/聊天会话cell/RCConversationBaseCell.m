//
//  RCConversationBaseCell.m
//  rongchat
//
//  Created by Donald on 16/12/6.
//  Copyright © 2016年 vd. All rights reserved.
//

#import "RCConversationBaseCell.h"

@interface RCConversationBaseCell ()
@property (nonatomic,strong) UIImageView * avatarImageView;
@property (nonatomic,strong) UILabel * nameLabel;
@end

@implementation RCConversationBaseCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
