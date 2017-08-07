//
//  RCIMConversationViewController.m
//  rongchat
//
//  Created by VD on 2017/8/4.
//  Copyright © 2017年 vd. All rights reserved.
//

#import "RCIMConversationViewController.h"
#import "RCIMConversationViewModel.h"

@interface RCIMConversationViewController ()
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
