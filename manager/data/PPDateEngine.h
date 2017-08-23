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

#pragma mark user
@property (nonatomic,strong,readonly) RACCommand * contactListCommand;
//查询用户信息
@property (nonatomic,strong,readonly) RACCommand * searchUserInfoCommand;
//好友添加 PPHTTPManager * manager = [PPHTTPManager manager];
//NSDictionary *params = @{
//@"friendId" : friendUserID,
//@"message" : content};
@property (nonatomic,strong,readonly) RACCommand * addContactCommand;
//用户修改名称
@property (nonatomic,strong,readonly) RACCommand * modifyNickNameCommand;
//密码重置
@property (nonatomic,strong,readonly) RACCommand * resetPassWordCommand __attribute__((deprecated("")));
//密码修改
@property (nonatomic,strong,readonly) RACCommand * updatePassWordCommand;
//好友黑名单
@property (nonatomic,strong,readonly) RACCommand * friendBlackListCommand;
//通过手机号查找好友
@property (nonatomic,strong,readonly) RACCommand * searchUserInfoByMobleCommand;
//设置好友备注信息
@property (nonatomic,strong,readonly) RACCommand * setFriendNickNameCommand;
//获取用户的详细资料
@property (nonatomic,strong,readonly) RACCommand * userInfoDetailCommand;
//加入黑名单
@property (nonatomic,strong,readonly) RACCommand * addFriendToBlackListCommand;
//删除黑名单中的成员
@property (nonatomic,strong,readonly) RACCommand * delFriendFromBlackListCommand;
//图片上传的token
@property (nonatomic,strong,readonly) RACCommand * uploadImageToken;
//token
@property (nonatomic,strong,readonly) RACCommand * token;
//登陆
@property (nonatomic,strong,readonly) RACCommand * loginCommand;
//注册
@property (nonatomic,strong,readonly) RACCommand * registerCommand;
//checkPhoneNumberAvailable 验证手机号码是否可用
@property (nonatomic,strong,readonly) RACCommand * checkPhoneNumberAvailableCommand;
//获得验证码
@property (nonatomic,strong,readonly) RACCommand * getVrificationCodeCommand;
//验证验证码
@property (nonatomic,strong,readonly) RACCommand * verfifyCodeCommand;


#pragma makr contactGroup
//创建群聊
@property (nonatomic,strong,readonly) RACCommand * createContactGroupCommand;
//修改群聊的名称
@property (nonatomic,strong,readonly) RACCommand * modifyContactGroupNameCommand;
//查询群聊成员
@property (nonatomic,strong,readonly) RACCommand * getGroupMemberCommand;
//退出分组
@property (nonatomic,strong,readonly) RACCommand * quitContactGroupCommand;
//解散群聊
@property (nonatomic,strong,readonly) RACCommand * dismissContactGroupCommand;
//删除分组中的成员
@property (nonatomic,strong,readonly) RACCommand * kickMembersContactGroupCommand;
//添加成员到群聊中
@property (nonatomic,strong,readonly) RACCommand * addMembersContactGroupCommand;
//申请加入群聊
@property (nonatomic,strong,readonly) RACCommand * joinInContactGroupCommand;
//所有的群聊
@property (nonatomic,strong,readonly) RACCommand * contactGroupsCommand;
//上传群聊的图片
@property (nonatomic,strong,readonly) RACCommand * uploadContactGroupAvatarImageCommand;
//获得群聊 groudID
@property (nonatomic,strong,readonly) RACCommand * getContactGroupByGroupIdCommand;




@end
