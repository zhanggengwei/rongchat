//
//  PPSelectAreaTableViewCell.m
//  rongchat
//
//  Created by vd on 2016/11/22.
//  Copyright © 2016年 vd. All rights reserved.
//

#import "PPSelectAreaTableViewCell.h"

@interface PPSelectAreaTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;


@end

@implementation PPSelectAreaTableViewCell

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
