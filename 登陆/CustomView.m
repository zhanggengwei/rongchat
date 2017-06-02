//
//  CustomView.m
//  rongchat
//
//  Created by Donald on 17/6/2.
//  Copyright © 2017年 vd. All rights reserved.
//

#import "CustomView.h"

@implementation CustomView

@end


@interface CustomContryView : UIButton
{
    UILabel * _display_label;
    UILabel * _name_label;
}
@property (nonatomic,strong,readonly) RACSignal * clickSignal;
- (void)loadContryName:(NSString *)name;
@end

@implementation CustomContryView

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self createUI];
    _clickSignal = [self rac_signalForControlEvents:UIControlEventTouchUpInside];
}
- (void)createUI
{

    UIView * view = [UIView new];
    [self addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.mas_equalTo(self);
        make.height.mas_equalTo(1);
    }];
    view.backgroundColor = [UIColor grayColor];
    _display_label = [UILabel new];
    _display_label.text = @"国家/地区";
    _name_label = [UILabel new];
    [self addSubview:_display_label];
    [self addSubview:_name_label];
    
    [_display_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.mas_equalTo(self);
        make.width.mas_equalTo(60);
    }];
    
    [_name_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.bottom.mas_equalTo(self);
        make.left.mas_equalTo(_display_label).right.mas_offset(30);
    }];
}
- (void)loadContryName:(NSString *)name
{
    _name_label.text = name;
}

@end

@interface PluginInputView : UIView
@property (nonatomic,strong) LoginModel * model;
@end

@implementation PluginInputView
{
    UILabel * _content;
    UITextField * _textFiled;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    _content = [UILabel new];
    _textFiled = [UITextField new];
    @weakify(self);
    [RACObserve(self,model) subscribeNext:^(LoginModel * model) {
        @strongify(self);
   
    }];
    
    
}

- (void)setModel:(LoginModel *)model
{
    _model = model;
    _textFiled.placeholder = _model.placeholderString;
    _content.text = model.content;
    _textFiled.text = model.text;
}


@end

@implementation LoginModel

@end
