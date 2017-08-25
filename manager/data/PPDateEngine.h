//
//  PPDateEngine.h
//  rongChatDemo1
//
//  Created by vd on 2016/10/30.
//  Copyright © 2016年 vd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveObjC/ReactiveObjC.h>

@interface PPDateEngine : NSObject
#define PPResponseBlock(blockName) void(^blockName)(id aTaskResponse)


+ (instancetype)manager;
- (instancetype)init __attribute__((unavailable("PPDateEngine init is not avaliable")));
//注册
- (void)registerWithResponse:(PPResponseBlock())aResponseBlock Phone:(NSString *)phone passWord:(NSString *)passWord verifyCode:(NSString *)code andNickName:(NSString *)nickName;

// 登陆
- (void)loginWithWithResponse:(PPResponseBlock())aResponseBlock Phone:(NSString *)phone passWord:(NSString *)passWord region:(NSString *)region;

- (void)logout;

//发送验证码
- (void)sendVerifyWithResponse:(PPResponseBlock())aResponseBlock phone:(NSString *)phoneNumber regionString:(NSString *)region;
//判断验证码是否有效
- (void)requestJudegeVaildWithResponse:(PPResponseBlock())aResponseBlock verfityCode:(NSString *)verificationCode region:(NSString *)region phone:(NSString *)phoneNumber;

//修改密码
- (void)requestResponse:(PPResponseBlock())aResponseBlock
         changePassWord:(NSString *)newPassWord oldPassWord:(NSString * )oldPassWord;

//重置密码
- (void)requestResetPassWordResponse:(PPResponseBlock())aResponseBlock resetPassWord:(NSString *)passWord verification_token:(NSString *)token;


//更新用户的昵称
- (void)requestUpdateNickNameResponse:(PPResponseBlock())aResponseBlock nickName:(NSString *)nickName;


//获得用户的个人信息
- (void)requestGetUserInfoResponse:(PPResponseBlock())aResponseBlock userID:(NSString *)userId;

//获取 friendList
- (void)getFriendListResponse:(PPResponseBlock())aResponseBlock;
//kPPUrlProfile 查询用户的信息
- (void)searchUserInfoResponse:(PPResponseBlock())aResponseBlock friendID:(NSString *)friendid;


- (void)requestUploadImageToken:(PPResponseBlock())aResponseBlock;

//user/blacklist
//获取用户的黑名单
- (void)requestGetBlackFriendListResponse:(PPResponseBlock())aResponseBlock;
//将好友添加到黑名单当中
- (void)requestAddBlackFriendListResponse:(PPResponseBlock())aResponseBlock  friendUserId:(NSString *)userId;
//将好友移除黑名单
- (void)requsetDeleteBlackFriendListResponse:(PPResponseBlock())aResponseBlock  friendUserId:(NSString *)userId;
//user/groups
// 获得用户所有的分组
- (void)requsetGetAllGroups:(PPResponseBlock())aResponseBlock;
//根据groupid 分区具体的信息
- (void)requestGetGroupDetails:(PPResponseBlock())aResponseBlock groupId:(NSString *)groupId;
//getGroupMembersByID
- (void)requsetGetGroupMembers:(PPResponseBlock())aResponseBlock groupId:(NSString *)groupId;
//  加入group
- (void)requsetJoinResponse:(PPResponseBlock())aResponseBlock Group:(NSString *)groupId;
// 邀请用户进行group  addUsersIntoGroup
- (void)requestInviteResponse:(PPResponseBlock())aResponseBlock
                      usersId:(NSMutableArray *)usersIdArr groupID:(NSString *)agroupId;

- (void)requestKickResponse:(PPResponseBlock())aResponseBlock
                 OutOfGroup:(NSString *)groupID
                    usersId:(NSMutableArray *)usersId;

- (void)requsetQuitGroupResponse:(PPResponseBlock())aResponseBlock OutOfGroup:(NSString *)groupID;
//解散群
- (void)requestDismissGroupResponse:(PPResponseBlock()) aResponseBlock dismissGroupId:(NSString *)groupId;

//+ (void)createGroupWithGroupName:(NSString *)groupName
                 //  groupMemberList:(NSArray *)groupMemberList

- (void)requsetCreateGroupResponse:(PPResponseBlock()) aResponseBlock GroupName:(NSString *)groupName
                   groupMemberList:(NSArray *)groupMemberList;

- (void)requsetUpdateGroupResponse:(void (^)(id))aResponseBlock GroupName:(NSString *)groupName groupId:(NSString *)groupId;

- (void)requsetInviteUsersResponse:(void (^)(id))aResponseBlock addUserId:(NSString *)friendUserID content:(NSString *)content;

- (void)requsetUploadImageResponse:(PPResponseBlock())aResponseBlock UploadFile:(NSData *)imageData UserId:(NSString *)auserId uploadToken:(NSString *)token;

- (void)requestSetHeadUrlResponse:(PPResponseBlock())aResponseBlock  headUrl:(NSString *)headUrl;//user/set_portrait_uri

- (RACCommand *)loginCommandWithUserName:(NSString *)account passWord:(NSString *)passWord;

- (RACSignal *)getContactListCommandWithUserId:(NSString *)userId;

@end
