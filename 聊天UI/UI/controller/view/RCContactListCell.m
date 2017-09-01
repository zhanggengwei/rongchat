//
//  RCContactListCell.m
//  rongchat
//
//  Created by VD on 2017/8/29.
//  Copyright © 2017年 vd. All rights reserved.
//

#import "RCContactListCell.h"

@interface RCContactListCell ()
@property (nonatomic,strong) UIView * line;
@end

@implementation RCContactListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if(self=[super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.line = [UIView new];
        [self.contentView addSubview:self.line];
        [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.bottom.mas_equalTo(self.contentView);
            make.height.mas_equalTo(0.5);
            make.left.mas_equalTo(self.contentView).mas_offset(12);
        }];
        self.line.backgroundColor = UIColorFromRGB(0xd3d5d7);
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setModel:(id)model
{
    _model = model;
    NSInteger rows = [self.tableView numberOfRowsInSection:self.indexPath.section];
    if(rows-1==self.indexPath.row)
    {
        self.line.hidden = YES;
    }else
    {
        self.line.hidden = NO;
    }
}

@end
