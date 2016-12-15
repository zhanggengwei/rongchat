//
//  UITableViewCell+addLineView.m
//  PPDate
//
//  Created by Donald on 16/8/25.
//  Copyright © 2016年 popoteam. All rights reserved.
//

#import "UITableViewCell+addLineView.h"
#import "PPImageUtil.h"


@implementation UITableViewCell (addLineView)
- (void)addTopLine
{
    UIImageView * lineView = [UIImageView new];
    [self.contentView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView.mas_top);
        make.height.mas_equalTo(@1);
        make.width.mas_equalTo(SCREEN_WIDTH);
        make.left.mas_equalTo(self.contentView.mas_left);
    }];
    [lineView setImage:[PPImageUtil resizableImageWithName:@"common_line_g"]];
}
- (void)addBottomLine
{
    UIImageView * lineView = [UIImageView new];
    [self.contentView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.contentView.mas_bottom);
        make.height.mas_equalTo(@1);
        make.width.mas_equalTo(SCREEN_WIDTH);
        make.left.mas_equalTo(self.contentView.mas_left);
    }];
    [lineView setImage:[PPImageUtil resizableImageWithName:@"common_line_g"]];
}
@end
