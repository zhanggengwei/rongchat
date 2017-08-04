//
//  RCIMConversationViewController.m
//  rongchat
//
//  Created by VD on 2017/8/4.
//  Copyright © 2017年 vd. All rights reserved.
//

#import "RCIMConversationViewController.h"

@interface RCIMConversationViewController ()
@property (nonatomic,strong) id currentUser;
@end

@implementation RCIMConversationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSAssert(self.conversationId==nil,@"self.conversationId is nil");
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma makr public Methods
- (instancetype _Nullable )initWithConversationId:(NSString *_Nullable)conversationId
{
    if(self=[super init])
    {
        self.conversationId = conversationId;
    }
    return self;
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
