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
@interface RCIMConversationViewController ()<RCIMChatMessageCellDelegate,PBViewControllerDelegate,PBViewControllerDataSource>
@property (nonatomic,strong) id currentUser;
@property (nonatomic,strong) RCIMConversationViewModel * viewModel;
@end

@implementation RCIMConversationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
