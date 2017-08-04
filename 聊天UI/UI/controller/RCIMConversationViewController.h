//
//  RCIMConversationViewController.h
//  rongchat
//
//  Created by VD on 2017/8/4.
//  Copyright © 2017年 vd. All rights reserved.
//

#import "RCIMBaseConversationViewController.h"

@interface RCIMConversationViewController : RCIMBaseConversationViewController

@property (nonnull,strong) NSString * conversationId;
/*!
 *  是否禁用文字的双击放大功能，默认为 NO
 */
@property (nonatomic, assign) BOOL disableTextShowInFullScreen;//
- (instancetype _Nullable )initWithConversationId:(NSString *_Nullable)conversationId;

- (void)sendTextMessage:(NSString *_Nullable)text;
- (void)sendImagesMessage:(NSArray<UIImage *> *_Nullable)images;
- (void)sendFileMessage:(NSString *_Nullable)filePath;
- (void)sendLocationMessage:(CLLocation *_Nullable)location;
- (void)sendVoiceMessageWithPath:(NSString *_Nullable)voicePath time:(NSTimeInterval)recordingSeconds;

- (void)sendLocalFeedbackTextMessge:(NSString *_Nullable)localFeedbackTextMessge;


@end
