//
//  PPSelectAreaViewCell.m
//  rongchat
//
//  Created by vd on 2016/11/22.
//  Copyright © 2016年 vd. All rights reserved.
//

#import "PPSelectAreaViewCell.h"

@interface PPSelectAreaViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;


@end


@implementation PPSelectAreaViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setContent:(NSString *)content
{
    self.contentLabel.text = content;
}

@end
