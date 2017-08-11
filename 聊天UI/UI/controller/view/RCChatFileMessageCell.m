//
//  RCChatFileMessageCell.m
//  rongchat
//
//  Created by VD on 2017/7/7.
//  Copyright © 2017年 vd. All rights reserved.
//

#import "RCChatFileMessageCell.h"

@interface RCChatFileMessageCell ()
@property (nonatomic,strong) UILabel * fileLabel;
@property (nonatomic,strong) UIButton * downButton;
@property (nonatomic,strong) UIImageView * fileIconImageView;
@property (nonatomic,strong) UIImageView * fileContentView;

@end

@implementation RCChatFileMessageCell
#pragma mark -
#pragma mark - LCCKChatMessageCellSubclassing Method

- (void)configureCellWithData:(RCMessage *)message
{
    [super configureCellWithData:message];
    RCFileMessage * fileContent = (RCFileMessage *)message.content;
    self.fileLabel.text = fileContent.name;
    self.fileIconImageView.image = [self fileImageWithFileExtension:fileContent.type];
    NSString * content = [NSString stringWithFormat:@"%@\n%@",fileContent.name,[self fileSizeString:fileContent.size]];
    NSMutableAttributedString * attributeString = [[NSMutableAttributedString alloc]initWithString:content];
    [attributeString setAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15],NSForegroundColorAttributeName:[UIColor blackColor]} range:NSMakeRange(0, fileContent.name.length)];
    
    [attributeString setAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12],NSForegroundColorAttributeName:UIColorFromRGB(0xa2a2a2)} range:NSMakeRange(fileContent.name.length,content.length- fileContent.name.length)];
    
    self.fileLabel.attributedText = attributeString;
}
- (void)setup
{
    CGFloat fileContentViewHeight = 150;
    [self.messageContentView addSubview:self.fileContentView];
    [self.fileContentView addSubview:self.fileIconImageView];
    [self.fileContentView addSubview:self.fileLabel];
    [self.fileContentView addSubview:self.downButton];
    UIEdgeInsets edgeMessageBubbleCustomize;
    if (self.messageOwner == MessageDirection_SEND) {
        UIEdgeInsets rightEdgeMessageBubbleCustomize = [RCIMSettingService shareManager].rightHollowEdgeMessageBubbleCustomize;
        edgeMessageBubbleCustomize = rightEdgeMessageBubbleCustomize;
    } else {
        UIEdgeInsets leftEdgeMessageBubbleCustomize = [RCIMSettingService shareManager].leftHollowEdgeMessageBubbleCustomize;
        edgeMessageBubbleCustomize = leftEdgeMessageBubbleCustomize;
    }
    [self addGeneralView];
    [super setup];
    CGFloat offset = 8.0;
    [self.fileIconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.fileContentView.mas_left).mas_offset(8);
        make.centerY.mas_equalTo(self.fileContentView.mas_centerY);
        make.top.mas_equalTo(self.fileContentView.mas_top).mas_offset(offset);
    }];
    [self.downButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.fileContentView.mas_centerY);
        make.right.mas_equalTo(self.fileContentView.mas_right).mas_offset(-2*offset);
    }];
    [self.fileContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.messageContentView).with.insets(edgeMessageBubbleCustomize);
        make.width.lessThanOrEqualTo(@200);
        make.height.lessThanOrEqualTo(@(fileContentViewHeight));
    }];
    
    [self.fileLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.fileContentView.mas_centerY);
        make.right.mas_equalTo(self.downButton.mas_left).mas_offset(-2*offset);
        make.left.mas_equalTo(self.fileIconImageView.mas_right);
    }];
}

- (UILabel *)fileLabel
{
    if(_fileLabel==nil)
    {
        _fileLabel = [UILabel new];
        _fileLabel.numberOfLines = 0;
    }
    return _fileLabel;
}

- (UIImageView *)fileIconImageView
{
    if(_fileIconImageView==nil)
    {
        _fileIconImageView = [UIImageView new];
        _fileIconImageView.image = [UIImage imageNamed:@"fav_fileicon_zip90"];
    }
    return _fileIconImageView;
}
//默认
- (NSString *)fileSizeString:(long long)size
{
    long long byte = size;
    if(byte<1024)
    {
        return [@(byte).stringValue stringByAppendingString:@"B"];
    }
    long long kb = byte/1024.0;
    if(kb<1024)
    {
        return [@(kb).stringValue stringByAppendingString:@"KB"];
    }
    long long MB = kb/1024.0;
    if(MB<1024)
    {
        return [@(MB).stringValue stringByAppendingString:@"MB"];
    }
    return [@(MB/1024.0).stringValue stringByAppendingString:@"G"];
}

- (UIButton *)downButton
{
    if(_downButton==nil)
    {
        _downButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_downButton setBackgroundImage:[UIImage imageNamed:@"fav_fileicon_down90Custom"] forState:UIControlStateNormal];
        [_downButton setBackgroundImage:[UIImage imageNamed:@"fav_fileicon_down90h"] forState:UIControlStateHighlighted];
        [_downButton addTarget:self action:@selector(downloadFile:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _downButton;
}

- (UIImageView *)fileContentView
{
    if(_fileContentView==nil)
    {
        _fileContentView = [UIImageView new];
        _fileContentView.userInteractionEnabled = YES;
    }
    return _fileContentView;
}

- (void)downloadFile:(id)sender
{
    if([self.delegate respondsToSelector:@selector(fileMessageDidDownload:)])
    {
        [self.delegate fileMessageDidDownload:self];
    }
}

- (UIImage *)fileImageWithFileExtension:(NSString *)extension
{
    NSString * imageName = nil;
    if([extension containsString:@"ppt"])
    {
        imageName = @"fav_fileicon_ppt90";
    }else if ([extension containsString:@"txt"])
    {
        imageName = @"fav_fileicon_txt90";
    }else if ([extension containsString:@"word"])
    {
        imageName = @"fav_fileicon_word90";
    }else if ([extension containsString:@"xls"])
    {
        imageName = @"fav_fileicon_xls90";
    }else if ([extension containsString:@"zip"])
    {
         imageName = @"fav_fileicon_zip90";
    }else if ([extension containsString:@"pdf"])
    {
        imageName = @"fav_fileicon_pdf90";
    }
    else
    {
        imageName = @"fav_fileicon_unknow90";
    }
    return [UIImage imageNamed:imageName];
}



#pragma mark
+ (void)load {
    [self registerSubclass];
}

+ (NSString *)classMediaType {
    return RCFileMessageTypeIdentifier;
}

@end
