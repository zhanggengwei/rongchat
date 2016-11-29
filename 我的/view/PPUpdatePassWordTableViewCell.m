//
//  PPUpdatePassWordTableViewCell.m
//  rongchat
//
//  Created by vd on 2016/11/29.
//  Copyright © 2016年 vd. All rights reserved.
//

#import "PPUpdatePassWordTableViewCell.h"

@interface PPUpdatePassWordTableViewCell ()<UITextFieldDelegate>
@property (nonatomic,strong) UILabel * leftLabel;
@property (nonatomic,strong) UILabel * rightLabel;
@property (nonatomic,strong) UITextField * textField;


@end

@implementation PPUpdatePassWordTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        [self createUI];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)createUI
{
    self.leftLabel = [UILabel new];
    [self.contentView addSubview:self.leftLabel];
    [self.leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_left).mas_offset(16);
        make.width.mas_equalTo(50);
        make.top.mas_equalTo(self.contentView.mas_top).mas_offset(8);
        make.bottom.mas_equalTo(self.contentView.mas_bottom).mas_offset(-8);
    }];
    self.rightLabel = [UILabel new];
    [self.contentView addSubview:self.rightLabel];
    [self.rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.contentView.mas_right);
        make.left.mas_equalTo(self.leftLabel.mas_right).mas_offset(20);
        
        make.top.mas_equalTo(self.contentView.mas_top).mas_offset(8);
        make.bottom.mas_equalTo(self.contentView.mas_bottom).mas_offset(-8);
    }];
    
    self.textField  = [UITextField new];
    self.textField.font = COMMON_FONT_SIZE;
    [self.contentView addSubview:self.textField];
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.contentView.mas_right).mas_offset(-8);
        make.left.mas_equalTo(self.leftLabel.mas_right).mas_offset(20);
        
        make.top.mas_equalTo(self.contentView.mas_top).mas_offset(8);
        make.bottom.mas_equalTo(self.contentView.mas_bottom).mas_offset(-8);
    }];
    self.leftLabel.font = COMMON_FONT_SIZE;
    self.rightLabel.font =  COMMON_FONT_SIZE;
    
    [self.textField addTarget:self action:@selector(textFieldDidChanged) forControlEvents:UIControlEventEditingChanged];
    self.textField.secureTextEntry = YES;
    self.textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    
}

- (void)setCellStyle:(PPUpdatePassWordTableViewCellStyle)cellStyle
{
    _cellStyle = cellStyle;
    if(cellStyle == PPUpdatePassWordTableViewCellDisable)
    {
        self.leftLabel.textColor = kPPTFontColorGray;
        self.rightLabel.textColor = kPPTFontColorGray;
        self.textField.hidden = YES;
        self.rightLabel.hidden = NO;
        
    }else
    {
        self.leftLabel.textColor = kPPTFontColorBlack;
        self.rightLabel.hidden = YES;
        self.textField.hidden = NO;
    }
}

- (void)setLeftContent:(NSString *)leftContent rightContent:(NSString *)rightcontent
{
    if (self.cellStyle == PPUpdatePassWordTableViewCellDisable) {
        self.leftLabel.text = leftContent;
        self.rightLabel.text = rightcontent;
        
    }else
    {
        self.leftLabel.text = leftContent;
        if(self.textField.text == nil||self.textField.text.length==0)
        {
            self.textField.placeholder = rightcontent;
        }
        
    }
}

- (void)textFieldDidChanged
{
    if(self.blockText)
    {
        self.blockText(self.textField.text);
    }
    
}


@end
