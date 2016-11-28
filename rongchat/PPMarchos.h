//
//  PPMarchos.h
//  rongchat
//
//  Created by vd on 2016/11/16.
//  Copyright © 2016年 vd. All rights reserved.
//

#ifndef PPMarchos_h
#define PPMarchos_h
#import "PPChatTools.h"
#import <RongIMLib/RongIMLib.h>
#import "SFHFKeychainUtils.h"
#import "kPPObserverDef.h"
#import "PPTDBEngine.h"
#import "PPDataDef.h"
#import "NSString+MD5.h"
#import "PPDateEngine.h"
#import "PPHTTPResponse.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "PPTUserInfoEngine.h"

#define SCREEN_WIDTH  [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIHGHT  [UIScreen mainScreen].bounds.size.height

#define kPPResponseSucessCode 200
#define IMAGE(name) [UIImage imageNamed:name]


#define  OBJC_APPIsLogin @"APPIsLogin"
// PPTabBarController

#define TabBarTitleFontSize 12.0f

#define TabBarNumberMarkD  20

#define  TabBarPointMarkD 12.0f

#define TabBarImageTextScale 0.55

#define COLOR(r,g,b,a)    ([UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a])

#define TabBarColor  [UIColor whiteColor]
#define TabBarTitleColor [UIColor grayColor]
#define ColorTitleSel COLOR(0,167,0,1)

#endif /* PPMarchos_h */
