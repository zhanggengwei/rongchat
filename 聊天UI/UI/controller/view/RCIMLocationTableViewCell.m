//
//  RCIMLocationTableViewCell.m
//  rongchat
//
//  Created by VD on 2017/8/10.
//  Copyright © 2017年 vd. All rights reserved.
//

#import "RCIMLocationTableViewCell.h"

@interface RCIMShowLocationCell ()
@property (nonatomic,strong) UIImageView * selectdIconImageView;

@end

@implementation RCIMShowLocationCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        [self addObserver:self forKeyPath:@"selected" options:NSKeyValueObservingOptionNew context:nil];
    }
    return self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if([keyPath isEqualToString:@"selected"])
    {
        BOOL isSelected = [change objectForKey:NSKeyValueChangeNewKey];
        self.selectdIconImageView.hidden=!isSelected;
    }
}
- (void)dealloc
{
    [self removeObserver:self forKeyPath:@"selected"];
    
}

- (UIImageView*)selectdIconImageView
{
    if(_selectdIconImageView==nil)
    {
        _selectdIconImageView = [UIImageView new];
        [self.contentView addSubview:_selectdIconImageView];
        _selectdIconImageView.image = [UIImage imageNamed:@"locationSelected"];
        [_selectdIconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.contentView.mas_centerY);
            make.right.mas_equalTo(self.contentView.mas_right).mas_offset(-8);
            make.width.height.mas_equalTo(20);
        }];
        _selectdIconImageView.hidden = YES;
        
    }
    return _selectdIconImageView;
}

@end

@interface RCIMLocationTableViewCell ()
@property (nonatomic,strong) UILabel * titleLabel;
@end

@implementation RCIMLocationTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self createUI];
    // Initialization code
}
- (void)prepareForReuse
{
    [super prepareForReuse];
    self.titleLabel.text = @"";
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        [self createUI];
    }
    return self;
}

- (void)createUI
{
    CGFloat offset = 8.0;
    [self.contentView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_left).mas_offset(offset);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.right.mas_equalTo(self.selectdIconImageView.mas_left).mas_offset(-offset);
    }];
}
- (UILabel *)titleLabel
{
    if(_titleLabel==nil)
    {
        _titleLabel = [UILabel new];
        _titleLabel.font = [UIFont systemFontOfSize:15];
    }
    return _titleLabel;
}

- (void)setArea:(AMapPOI *)area
{
    self.titleLabel.text = area.name;
    self.selectdIconImageView.image = [UIImage imageNamed:@"locationSelected"];
}
@end

@interface RCIMLocationCustomTableViewCell ()
@property (nonatomic,strong) UILabel * titleLabel;
@property (nonatomic,strong) UILabel * extraLabel;
@end

@implementation RCIMLocationCustomTableViewCell

- (void)prepareForReuse
{
    [super prepareForReuse];
    self.extraLabel.text = @"";
    self.titleLabel.text = @"";
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        [self createUI];
    }
    return self;
}

- (void)createUI
{
    CGFloat offset = 8.0;
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.extraLabel];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_left).mas_offset(offset);
        make.right.mas_equalTo(self.selectdIconImageView.mas_left).mas_offset(-offset);
        make.top.mas_equalTo(self.contentView.mas_top).mas_offset(offset);
    }];
    [self.extraLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.titleLabel);
        make.top.mas_equalTo(self.titleLabel.mas_bottom).mas_offset(offset/2.0);
        make.bottom.mas_equalTo(self.contentView.mas_bottom).mas_offset(-offset/2.0);
    }];
}

- (void)setArea:(AMapPOI *)area
{
    [super setArea:area];
    self.titleLabel.text = area.name;
    self.extraLabel.text = area.address;
    
}
- (UILabel *)extraLabel
{
    if(_extraLabel==nil)
    {
        _extraLabel = [UILabel new];
        _extraLabel.font = [UIFont systemFontOfSize:12];
        _extraLabel.textColor = UIColorFromRGB(0xa2a2a2);
    }
    return _extraLabel;
}
- (UILabel *)titleLabel
{
    if(_titleLabel==nil)
    {
        _titleLabel = [UILabel new];
        _titleLabel.font = [UIFont systemFontOfSize:15];
        _titleLabel.textColor = [UIColor blackColor];
    }
    return _titleLabel;
}

@end
