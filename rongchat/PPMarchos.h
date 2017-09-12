//
//  PPMarchos.h
//  rongchat
//
//  Created by vd on 2016/11/16.
//  Copyright © 2016年 vd. All rights reserved.
//

#ifndef PPMarchos_h
#define PPMarchos_h
#import <RongIMLib/RongIMLib.h>
#import <Mantle/Mantle.h>
#import <ReactiveObjC.h>
#import "RCIMMessageTools.h"
#import "SFHFKeychainUtils.h"
#import "kPPObserverDef.h"
#import "PPDataDef.h"
#import "PPTDBEngine.h"
#import "NSString+MD5.h"
#import "PPDateEngine.h"
#import "PPHTTPResponse.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "PPTUserInfoEngine.h"
#import "RCConstants.h"

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
#define kPPSperactorColor UIColorFromRGB(0xd3d5d7)

// RGB颜色转换（16进制->10进制）
#define UIColorFromRGB(rgbValue)\
\
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 \
alpha:1.0]

#define UIColorFromRGBA(rgbValue, a) \
\
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 \
alpha:a]

#define UIColorFromFloatValueRGBA(r,g,b,a)\
\
[UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]


#pragma mark - font color
#define kPPTFontColorGray UIColorFromRGB(0x9b9b9b)
#define kPPTFontColorBlack UIColorFromRGB(0x1c1c1c)
#define kPPTFontColorWhite UIColorFromRGB(0xffffff)


#define CONTACT_LIST_NO_FRIENDS_LABEL_COLOR UIColorFromRGB(0xa2a2a2)


#define KPP_LINE_BACK_GROUND_COLOR UIColorFromRGB(0xdddddd)


#pragma mark - font size
#define COMMON_TITLE_FONT_SIZE [UIFont systemFontOfSize:25]
#define kPPTCHAT_TEAMFONT_SIZE [UIFont systemFontOfSize:18]
#define NAVI_TITLE_FONT_SIZE [UIFont systemFontOfSize:17]
#define CONV_LIST_TOP_LABEL_FONT_SIZE [UIFont systemFontOfSize:16]


#pragma mark - font size
#define TITLE_FONT_BLOD_SIZE BOLDSYSTEMFONT(15)
#define TITLE_FONT_SIZE [UIFont systemFontOfSize:15]
#define COMMON_FONT_SIZE [UIFont systemFontOfSize:14]
#define kChatMessageHintFontSize [UIFont systemFontOfSize:12]
#define DETAIL_FONT_SIZE [UIFont systemFontOfSize:12]
#define MESAAGECELL_LOCATION_FONT_SIZE [UIFont systemFontOfSize:10]


#pragma mark - image color
#define kMainBackGroundColor     [UIColor colorWithRed:239/255.0 green:239/255.0 blue:246/255.0 alpha:1];
#define kNavigationBarBackGroundColor UIColorFromRGB(0xffffff)
#define kButtonColorPink UIColorFromRGB(0xfa688f)
#define kButtonColorBlue UIColorFromRGB(0x88ceff)
#define kButtonColorViolet UIColorFromRGB(0xea82ff)
#define kHomePageSelectMatesBackGroudColor UIColorFromRGBA(0xffffff, 0.8)
#define kPPTBackGroundColorGray kMainBackGroundColor
#define kWAITVIEWBACKGROUNDCOLOR UIColorFromRGB(0x88ceff)
#define kPPTWhiteColor UIColorFromRGB(0xffffff)

//104/255.0 green:187/255.0 blue:30/255.0
#define kPPLoginButtonColor  UIColorFromFloatValueRGBA(104,187,30,1.0)

#define kPPLoginButtonDisableColor  UIColorFromFloatValueRGBA(104,187,30,0.4)

//142/255.0 green:148/255.0 blue:165/255.0 alpha:1
#define kPPEamil_ButtonColor UIColorFromFloatValueRGBA(142,148,165,1.0)


#pragma mark UIImageView SDWebImage

#define SD_LOADIMAGE(imageView,urlString,placeImage)\
 [imageView sd_setImageWithURL:[NSURL URLWithString:urlString] placeholderImage:placeImage options:SDWebImageRetryFailed|SDWebImageProgressiveDownload]

#define RCIM_PLACE_ARATARIMAGE [UIImage RCIM_imageNamed:@"Placeholder_Avatar" bundleName:@"Placeholder" bundleForClass:[self class]];

#define RCIM_CONTACT_GROUP_ARATARIMAGE [UIImage RCIM_imageNamed:@"Placeholder_Group" bundleName:@"Placeholder" bundleForClass:[self class]];
#define RCIM_REMIND_COLOR [UIColor colorWithRed:210/255.0 green:56/255.0 blue:52/255.0 alpha:1]
#import <RongIMLib/RongIMLib.h>
#import  <PinYin4Objc/PinYin4Objc.h>

#define WS(weakSelf)  __weak __typeof(&*self)weakSelf = self
#define WSOBJ(weakSelf,obj)  __weak __typeof(&*obj)weakSelf = obj

#endif /* PPMarchos_h */
