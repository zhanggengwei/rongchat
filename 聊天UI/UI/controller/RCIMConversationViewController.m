//
//  RCIMConversationViewController.m
//  rongchat
//
//  Created by VD on 2017/8/4.
//  Copyright © 2017年 vd. All rights reserved.
//

#import "RCIMConversationViewController.h"
#import "RCIMConversationViewModel.h"
#import "RCIMTextFullScreenViewController.h"
#import <PhotoBrowser.h>
#import "RCChatBar.h"
@interface RCIMConversationViewController ()<RCIMChatMessageCellDelegate,PBViewControllerDelegate,PBViewControllerDataSource,RCIMChatBarDelegate>
@property (nonatomic,strong) id currentUser;
@property (nonatomic,strong) RCIMConversationViewModel * viewModel;
@end

@implementation RCIMConversationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.chatBar.delegate = self;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.allowScrollToBottom = YES;
    _viewModel = [[RCIMConversationViewModel alloc]initWithParentViewController:self];
    _viewModel.conversationId = self.conversation.targetId;
    _viewModel.conversationType = self.conversation.conversationType;
    self.tableView.delegate = _viewModel;
    self.tableView.dataSource = _viewModel;
    [_viewModel loadMessagesFirstTimeWithCallback:^(BOOL succeeded, id object, NSError *error) {
        
    }];
    // Do any additional setup after loading the view.
}
- (void)loadMoreMessagesScrollTotop
{
    [self.viewModel loadOldMessages];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)sendTextMessage:(NSString *_Nullable)text
{
    
}
- (void)sendImagesMessage:(NSArray<UIImage *> *_Nullable)images
{
    
}
- (void)sendFileMessage:(NSString *_Nullable)filePath
{
    
}
- (void)sendLocationMessage:(CLLocation *_Nullable)location
{
    
}
- (void)sendVoiceMessageWithPath:(NSString *_Nullable)voicePath time:(NSTimeInterval)recordingSeconds
{
    
}
- (void)sendLocalFeedbackTextMessge:(NSString *_Nullable)localFeedbackTextMessge
{
    
}
#pragma mark RCIMChatMessageCellDelegate
- (void)messageCellTappedBlank:(RCChatBaseMessageCell *)messageCell
{
   NSLog(@"%s",__PRETTY_FUNCTION__);
}
- (void)messageCellTappedHead:(RCChatBaseMessageCell *)messageCell
{
    NSLog(@"%s",__PRETTY_FUNCTION__);
    
}
- (void)messageCellTappedMessage:(RCChatBaseMessageCell *)messageCell
{
    NSLog(@"%s",__PRETTY_FUNCTION__);
    PBViewController * controller = [[PBViewController alloc]init];
    NSInteger index = [self.viewModel.imageArray indexOfObject:messageCell.message];
    
    controller.startPage = index;
    controller.blurBackground = NO;
    controller.pb_delegate = self;
    controller.pb_dataSource = self;
    
    [self.navigationController pushViewController:controller animated:YES];
    
    
}
- (void)textMessageCellDoubleTapped:(RCChatBaseMessageCell *)messageCell
{
    if([messageCell.message.objectName isEqualToString:RCTextMessageTypeIdentifier])
    {
        RCTextMessage * textMessage = (RCTextMessage *)messageCell.message.content;
        RCIMTextFullScreenViewController * textFullScreenViewController = [[RCIMTextFullScreenViewController alloc]initWithText:textMessage.content];
        [self.navigationController pushViewController:textFullScreenViewController animated:NO];
        
    }
}
- (void)resendMessage:(RCChatBaseMessageCell *)messageCell
{
    [self.viewModel deleteMessageWithCell:messageCell withMessage:messageCell.message];
    [self.viewModel sendMessage:messageCell.message.content];
}
- (void)avatarImageViewLongPressed:(RCChatBaseMessageCell *)messageCell
{
    NSLog(@"click avatar imageView");
}
- (void)messageCell:(RCChatBaseMessageCell *)messageCell didTapLinkText:(NSString *)linkText linkType:(MLLinkType)linkType
{
    if(linkType==MLLinkTypePhoneNumber)
    {
        
    }else if (linkType ==MLLinkTypeURL)
    {
        
    }else if (linkType == MLLinkTypeEmail)
    {
        
    }
}
- (void)fileMessageDidDownload:(RCChatBaseMessageCell *)messageCell
{
    
}

- (void)messageCellDidDeleteMessageCell:(RCChatBaseMessageCell *)messageCell message:(RCMessage *)message
{
    [self.viewModel deleteMessageWithCell:messageCell withMessage:message];
    
}

- (NSInteger)numberOfPagesInViewController:(nonnull PBViewController *)viewController
{
    return _viewModel.imageArray.count;
}
- (void)viewController:(nonnull PBViewController *)viewController presentImageView:(nonnull UIImageView *)imageView forPageAtIndex:(NSInteger)index progressHandler:(nullable void (^)(NSInteger receivedSize, NSInteger expectedSize))progressHandler
{
     RCImageMessage * imageMessage = (RCImageMessage *)self.viewModel.imageArray[index].content;
     NSLog(@"imageclass == %@",imageMessage.class);
     [imageView sd_setImageWithURL:[NSURL URLWithString:imageMessage.imageUrl]];
    
}

- (void)viewController:(nonnull PBViewController *)viewController didSingleTapedPageAtIndex:(NSInteger)index presentedImage:(nullable UIImage *)presentedImage
{
    [viewController.navigationController popViewControllerAnimated:NO];
}

/// Action call back for long press, presentedImage will be nil untill loaded image
- (void)viewController:(nonnull PBViewController *)viewController didLongPressedPageAtIndex:(NSInteger)index presentedImage:(nullable UIImage *)presentedImage
{
    
}
- (void)chatBarFrameDidChange:(RCChatBar *)chatBar shouldScrollToBottom:(BOOL)shouldScrollToBottom
{
    [UIView animateWithDuration:RCAnimateDuration animations:^{
        [self.tableView.superview layoutIfNeeded];
         self.allowScrollToBottom = shouldScrollToBottom;
        [self scrollToBottomAnimated:NO];
    } completion:nil];
}

/*!
 *  发送图片信息,支持多张图片
 *
 *  @param chatBar
 *  @param pictures 需要发送的图片信息
 */
- (void)chatBar:(RCChatBar *)chatBar sendPictures:(NSArray *)pictures
{
    
}

/*!
 *  发送地理位置信息
 *
 *  @param chatBar
 *  @param locationCoordinate 需要发送的地址位置经纬度
 *  @param locationText       需要发送的地址位置对应信息
 */
- (void)chatBar:(RCChatBar *)chatBar sendLocation:(CLLocationCoordinate2D)locationCoordinate locationText:(NSString *)locationText
{
    
}

/*!
 *  发送普通的文字信息,可能带有表情
 *
 *  @param chatBar
 *  @param message 需要发送的文字信息
 */
- (void)chatBar:(RCChatBar *)chatBar sendMessage:(NSString *)message
{
    RCTextMessage * content = [RCTextMessage messageWithContent:message];
    [self.viewModel sendMessage:content];
}

/*!
 *  发送语音信息
 *
 *  @param chatBar
 *  @param voiceData 语音data数据
 *  @param seconds   语音时长
 */
- (void)chatBar:(RCChatBar *)chatBar sendVoice:(NSString *)voiceFileName seconds:(NSTimeInterval)seconds
{
    
}

/*!
 *  输入了 @ 的时候
 *
 */
- (void)didInputAtSign:(RCChatBar *)chatBar
{
    
}

//- (NSArray *)regulationForBatchDeleteText;
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
