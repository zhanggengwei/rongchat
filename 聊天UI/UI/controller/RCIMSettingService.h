//
//  RCIMSettingService.h
//  rongchat
//
//  Created by VD on 2017/7/8.
//  Copyright © 2017年 vd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RCIMSettingService : NSObject

+ (instancetype)shareManager;//单例

@property (nonatomic, strong, readonly) NSDictionary *defaultSettings;
@property (nonatomic, strong, readonly) NSDictionary *defaultTheme;
@property (nonatomic, strong, readonly) NSDictionary *messageBubbleCustomizeSettings;

@property (nonatomic,strong,readonly) UIImage * placeholderAvatarImage;//聊天默认头像

- (RCUserInfo *)getUserByUserId:(NSString *)userId;

- (UIColor *)defaultThemeColorForKey:(NSString *)key;
- (UIFont *)defaultThemeTextMessageFont;

/**
 * @param capOrEdge 分为：cap_insets和edge_insets
 * @param position 主要分为：CommonLeft、CommonRight等
 */
- (UIEdgeInsets)messageBubbleCustomizeSettingsForPosition:(NSString *)position capOrEdge:(NSString *)capOrEdge;
- (UIEdgeInsets)rightCapMessageBubbleCustomize;
- (UIEdgeInsets)rightEdgeMessageBubbleCustomize;
- (UIEdgeInsets)leftCapMessageBubbleCustomize;
- (UIEdgeInsets)leftEdgeMessageBubbleCustomize;
- (UIEdgeInsets)rightHollowCapMessageBubbleCustomize;
- (UIEdgeInsets)rightHollowEdgeMessageBubbleCustomize;
- (UIEdgeInsets)leftHollowCapMessageBubbleCustomize;
- (UIEdgeInsets)leftHollowEdgeMessageBubbleCustomize;

- (NSString *)imageNameForMessageBubbleCustomizeForPosition:(NSString *)position normalOrHighlight:(NSString *)normalOrHighlight;
- (NSString *)leftNormalImageNameMessageBubbleCustomize;
- (NSString *)leftHighlightImageNameMessageBubbleCustomize;
- (NSString *)rightHighlightImageNameMessageBubbleCustomize;
- (NSString *)rightNormalImageNameMessageBubbleCustomize;
- (NSString *)hollowRightNormalImageNameMessageBubbleCustomize;
- (NSString *)hollowRightHighlightImageNameMessageBubbleCustomize;
- (NSString *)hollowLeftNormalImageNameMessageBubbleCustomize;
- (NSString *)hollowLeftHighlightImageNameMessageBubbleCustomize;


@end
