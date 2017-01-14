//
//  PPTZeroSelectListCell.h
//  PPDate
//
//  Created by 郭远强 on 16/4/23.
//  Copyright © 2016年 郭远强. All rights reserved.
//

#import "PPTZeroSelectListCell.h"


@implementation PPTZeroSelectListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:NO];

    // Configure the view for the selected state
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.layer.cornerRadius = 3;
    self.layer.masksToBounds = YES;
    
    self.imageView.frame = CGRectMake(15,10,20,20);
    
    CGRect tmpFrame     = self.textLabel.frame;
    tmpFrame.origin.x   = 0;
    tmpFrame.size.width = 80;
    
    self.textLabel.frame = tmpFrame;
    self.textLabel.textAlignment = NSTextAlignmentCenter;
    self.textLabel.textColor = [UIColor whiteColor];
    
   // self.contentView.backgroundColor = [UIColor blackColor];
    
}

@end
