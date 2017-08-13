//
//  RCIMDocumentsFileDownController.m
//  rongchat
//
//  Created by VD on 2017/8/13.
//  Copyright © 2017年 vd. All rights reserved.
//

#import "RCIMDocumentsFileDownController.h"
#import "RCIMMessageManager.h"
#import "RCMessage+RCTimeShow.h"
#import "NSString+isValid.h"
#import <QuickLook/QuickLook.h>

@interface RCIMDocumentsFileDownController ()<QLPreviewControllerDataSource,QLPreviewControllerDelegate>

@property (nonatomic,strong) UIView * contentView;
@property (nonatomic,strong) UILabel * downLoadLabel;
@property (nonatomic,strong) UIView * percentageView;
@property (nonatomic,strong) UIView * downLoadView;
@property (nonatomic,strong) UILabel * fileNameLabel;
@property (nonatomic,strong) UIButton * downLoadButton;
@property (nonatomic,strong) QLPreviewController * preViewController;

@end

@implementation RCIMDocumentsFileDownController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    RCFileMessage * messageContent = (RCFileMessage *)self.message.content;
    NSLog(@"messageContent.fileUrl %@",messageContent.localPath);
    if(![self canOpenDocuments])
    {
        [self createUI];
    }
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)canOpenDocuments
{
    RCFileMessage * messageContent = (RCFileMessage *)self.message.content;
    if([self.message.class canReadOpenApp:messageContent]&&[messageContent.localPath isValid])
    {
        [self addChildViewController:self.preViewController];
        [self.view addSubview:self.preViewController.view];
        [self.preViewController.view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self.view);
        }];
        [self.preViewController didMoveToParentViewController:self];
        return YES;
    }
    return NO;
}

- (QLPreviewController *)preViewController
{
    if(_preViewController == nil)
    {
        _preViewController = [QLPreviewController new];
        _preViewController.delegate = self;
        _preViewController.dataSource = self;
    }
    return _preViewController;
}

- (void)downProgressDidChanged:(CGFloat)progress
{
    [self.downLoadView layoutIfNeeded];
    CGFloat width = self.downLoadView.frame.size.width;
    [self.percentageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(progress * width);
    }];
    RCFileMessage * messageContent = (RCFileMessage *)self.message.content;
    self.downLoadLabel.text = [NSString stringWithFormat:@"正在下载...(%@/%@)",[self.message fileSizeString:messageContent.size * progress],[self.message fileSizeString:messageContent.size]];
}

- (void)createUI
{
    RCFileMessage * messageContent = (RCFileMessage *)self.message.content;
    [self addNavUI];
    UIImageView * fileIconImageView = [UIImageView new];
    [self.view addSubview:fileIconImageView];
    [fileIconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top).mas_offset(20);
        make.centerX.mas_equalTo(self.view.mas_centerX);
    }];
    fileIconImageView.image = [[RCIMSettingService shareManager]fileImageWithFileExtension:messageContent.type];
    UILabel * fileNameLabel = [UILabel new];
    self.fileNameLabel = fileNameLabel;
    [self.view addSubview:fileNameLabel];
    [fileNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(fileIconImageView.mas_centerX);
        make.top.mas_equalTo(fileIconImageView.mas_bottom).mas_offset(10);
    }];
    fileNameLabel.text = messageContent.name;
    UIButton * downButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:downButton];
    [downButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).mas_offset(24);
        make.right.mas_equalTo(self.view.mas_right).mas_offset(-24);
        make.height.mas_equalTo(44);
        make.top.mas_equalTo(fileNameLabel.mas_bottom).mas_offset(10);
    }];
    [downButton setBackgroundColor:[UIColor colorWithRed:26/255.0 green:178/255.0 blue:20/255.0 alpha:1]];
    
    downButton.layer.cornerRadius = 4;
    self.downLoadButton = downButton;
    if (([self.message.class canReadOpenApp:messageContent]==NO)&&[messageContent.localPath isValid])
    {
        [downButton setTitle:@"使用其它应用打开" forState:UIControlStateNormal];
        [downButton addTarget:self action:@selector(openWithOtherApp:) forControlEvents:UIControlEventTouchUpInside];
    }
    else
    {
        [downButton setTitle:@"开始下载" forState:UIControlStateNormal];
        [downButton addTarget:self action:@selector(downloadFile:) forControlEvents:UIControlEventTouchUpInside];
    }
    [self.view addSubview:self.contentView];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.fileNameLabel.mas_bottom).mas_offset(20);
        make.left.right.mas_equalTo(downButton);
    }];
    self.contentView.hidden = YES;
}

- (void)startDownload
{
    self.downLoadButton.hidden = YES;
    self.contentView.hidden = NO;
}

- (void)stopDownload
{
    self.downLoadButton.hidden = NO;
    self.contentView.hidden = YES;
}

- (void)addNavUI
{
    self.title = @"文件预览";
}

- (UIView *)contentView
{
    if(_contentView ==nil)
    {
        _contentView = [UIView new];
        [_contentView addSubview:self.downLoadLabel];
        [_contentView addSubview:self.downLoadView];
        [self.downLoadLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.centerX.mas_equalTo(_contentView);
        }];
        [self.downLoadView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(self.downLoadLabel);
            make.height.mas_equalTo(@8);
            make.top.mas_equalTo(self.downLoadLabel.mas_bottom).mas_offset(8);
        }];
    }
    return _contentView;
}

- (UIView *)downLoadView
{
    if(_downLoadView==nil)
    {
        _downLoadView = [UIView new];
        _downLoadView.backgroundColor = UIColorFromRGB(0xa2a2a2);
        [_downLoadView addSubview:self.percentageView];
        [self.percentageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.height.mas_equalTo(_downLoadView);
            make.width.mas_equalTo(0);
        }];
//        _downLoadView.layer.cornerRadius = 1;
        UIButton * cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];[_contentView addSubview:cancelButton];
        [_downLoadView addSubview:cancelButton];
        [cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_downLoadView.mas_right).mas_offset(-20);
            make.centerY.mas_equalTo(_downLoadView.mas_centerY);
            make.width.height.mas_equalTo(40);
        }];
        [cancelButton setBackgroundImage:[UIImage imageNamed:@"download_delete"] forState:UIControlStateNormal];
        [cancelButton addTarget:self action:@selector(cancelDownload:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _downLoadView;
}
- (UILabel *)downLoadLabel
{
    if(_downLoadLabel==nil)
    {
        _downLoadLabel = [UILabel new];
        _downLoadLabel.textColor = UIColorFromRGB(0xa2a2a2);
        _downLoadLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _downLoadLabel;
}

- (UIView *)percentageView
{
    if(_percentageView==nil)
    {
        _percentageView = [UIView new];
        _percentageView.backgroundColor = [UIColor colorWithRed:26/255.0 green:178/255.0 blue:20/255.0 alpha:1];
    }
    return _percentageView;
}

- (void)cancelDownload:(id)sender
{
    NSLog(@"cancelDownload");
}

- (void)downloadFile:(id)sender
{
    [self startDownload];
    [self downProgressDidChanged:0];
    [[RCIMMessageManager shareManager]downloadMediaMessage:self.message withProgress:^(NSInteger percentDone) {
     
        [self downProgressDidChanged:percentDone/100.0];
        
    } failed:^(RCErrorCode error) {
        
    } sucessBlock:^(NSString *path) {
        RCFileMessage * fileMessage = (RCFileMessage *)self.message.content;
        fileMessage.localPath = path;
        [self canOpenDocuments];
        
    } cancelBlock:^(NSInteger messageId) {
        [self stopDownload];
    }];
}

- (void)openWithOtherApp:(id)sender
{
    
}


- (NSInteger)numberOfPreviewItemsInPreviewController:(QLPreviewController *)controller
{
    return 1;
}

/*!
 * @abstract Returns the item that the preview controller should preview.
 * @param panel The Preview Controller.
 * @param index The index of the item to preview.
 * @result An item conforming to the QLPreviewItem protocol.
 */
- (id <QLPreviewItem>)previewController:(QLPreviewController *)controller previewItemAtIndex:(NSInteger)index
{
    RCFileMessage * fileMessage = (RCFileMessage *)self.message.content;
    return [NSURL fileURLWithPath:fileMessage.localPath];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
