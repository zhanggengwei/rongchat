//
//  PPUrlDef.h
//  rongchat
//
//  Created by vd on 2016/11/30.
//  Copyright © 2016年 vd. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kPPUrlHttp @"http://api.sealtalk.im/"

#pragma  用户
#define kPPUrlLoginUrl [NSString stringWithFormat:@"%@user/login",kPPUrlHttp]

#define kPPUrlRegisiter [NSString stringWithFormat:@"%@user/regisiter",kPPUrlHttp]

#define kPPUpdatePassWord [NSString stringWithFormat:@"%@user/change_password",kPPUrlHttp]

#define kPPResetPassWord [NSString stringWithFormat:@"%@user/reset_password",kPPUrlHttp]

#define kPPVertifyPhoneIsValid [NSString stringWithFormat:@"%@user/verify_code",kPPUrlHttp]
///user/set_nickname?userId=%@
#define kPPUrlUpdateNickName(userID) [NSString stringWithFormat:@"%@user/set_nickname?userId=%@",kPPUrlHttp,userID]


#define kPPUrlProfile(friendId) [NSString stringWithFormat:@"%@friendship/%@/profile",kPPUrlHttp,friendId]
#define kPPUrlUploadImageToken [NSString stringWithFormat:@"%@user/get_image_token",kPPUrlHttp]

#define KppUrlsetAvatuaUrl [NSString stringWithFormat:@"%@user/set_portrait_uri",kPPUrlHttp]

#define kPPUrlUserInfo(userId) [NSString stringWithFormat:@"%@user/%@",kPPUrlHttp,userId]

#pragma mark sendSms
#define kPPSendVirtifyCode [NSString stringWithFormat:@"%@user/send_code",kPPUrlHttp]


#pragma mark FriendList
#define kPPGetAllFriendsList [NSString stringWithFormat:@"%@friendship/all",kPPUrlHttp]



//设置备注
#define kPPUrlSetDispalyName [NSString stringWithFormat:@"%@friendship/set_display_name",kPPUrlHttp]

// 获取版本的信息 ///misc/client_version

#define kPPUrlGetVersions [NSString stringWithFormat:@"%@misc/client_version",kPPUrlHttp]
//update_profile

// 获取image token user/get_image_token



#define kPPUrlBlackUserList [NSString stringWithFormat:@"%@user/blacklist",kPPUrlHttp]
//user/add_to_blacklist
#define kPPUrlAddFriendBlackList [NSString stringWithFormat:@"%@user/add_to_blacklist",kPPUrlHttp]

//user/remove_from_blacklist
#define kPPUrlDeleteFriendBlackList [NSString stringWithFormat:@"%@user/remove_from_blacklist",kPPUrlHttp]
//user/groups
#define kPPUrlGetAllGroups [NSString stringWithFormat:@"%@user/groups",kPPUrlHttp]

#define kPPUrlGetGroupId(groupID) [NSString stringWithFormat:@"%@group/%@",kPPUrlHttp,groupID]
//members
#define kPPUrlGetGroupMember(groupID) [NSString stringWithFormat:@"%@group/%@/members",kPPUrlHttp,groupID]
///group/join
#define kPPUrlJoinGroup [NSString stringWithFormat:@"%@group/join",kPPUrlHttp]
///group/add
#define kPPUrlInviteUserGroup [NSString stringWithFormat:@"%@group/add",kPPUrlHttp]
//group/kick
#define kPPUrlKickGroup [NSString stringWithFormat:@"%@group/kick",kPPUrlHttp]
//quit
#define kPPUrlQuitGroup [NSString stringWithFormat:@"%@group/quit",kPPUrlHttp]
///dismiss
#define kPPUrlDismissGroup [NSString stringWithFormat:@"%@group/dismiss",kPPUrlHttp]
//
#define kPPUrlCreateGroup [NSString stringWithFormat:@"%@group/create",kPPUrlHttp]
//rename
#define kPPUrlRenameGroupName [NSString stringWithFormat:@"%@group/rename",kPPUrlHttp]

#define kPPUrlInviteFriend [NSString stringWithFormat:@"%@friendship/invite",kPPUrlHttp]
///user/set_portrait_uri





@interface PPUrlDef : NSObject

@end
