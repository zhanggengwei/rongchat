//
//  RCContactUserInfo.h
//  rongchat
//
//  Created by vd on 2016/12/8.
//  Copyright © 2016年 vd. All rights reserved.
//

#import <RongIMLib/RongIMLib.h>

@interface RCContactUserInfo : RCUserInfo
@property (nonatomic,strong) NSString * nickNameChar;

- (instancetype)transFromPPUserBaseInfoToRCContactUserInfo:(PPUserBaseInfo *)baseInfo;




@end
