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
+ (instancetype)manager;
- (instancetype)init __attribute__((unavailable("PPDateEngine init is not avaliable")));

#pragma mark User

//通过userId 获得个人信息的接口
- (RACSignal *)getUserInfoCommandByUserId:(NSString *)userId;

- (RACSignal *)resgisterUserCommandByAccount:(NSString *)account passWord:(NSString *)passWord nickName:(NSString *)nickName verifyCode:(NSString *)code;

- (RACSignal *)getVerificationCodeCommand:(NSString *)region phone:(NSString *)phone;

- (RACSignal *)verifyVerificationCodeCommand:(NSString *)phoneNumber verifyCode:(NSString *)code;


- (RACSignal *)getContactListCommandWithUserId:(NSString *)userId;

- (RACSignal *)loginCommandWithUserName:(NSString *)account passWord:(NSString *)passWord region:(NSString *)region;

- (RACSignal *)getUserInfoDetailCommand:(NSString *)friendId;

- (RACSignal *)sendSmsCode:(NSString *)phone region:(NSString *)region;
- (RACSignal *)uploadAvatarImage:(UIImage *)avatarImage;




#pragma mark contactGroup

- (RACSignal *)getContactGroupsCommand;

//创建群组
- (RACSignal *)createContactGroupName:(NSString *)name members:(NSArray<RCUserInfoData *> *)users;
//删除群组的成员
- (RACSignal *)deleteMemberFormContactGroup:(NSString *)groudId members:(NSArray<NSString *> *)userIds;
//添加群组成员
- (RACSignal *)addMemberFormContactGroup:(NSString *)groudId members:(NSArray<NSString *> *)userIds;
//修改群姓名
- (RACSignal *)updateContactGroupName:(NSString *)groupName withGroupId:(NSString *)groupId;
//退出群组
- (RACSignal *)leaveContactGroup:(NSString *)groupId;
//解散群组
- (RACSignal *)dismissContactGroup:(NSString *)groupId;
//发布群公告
- (RACSignal *)submitContactGroupPublicService:(NSString *)groupId publicService:(NSString *)publicService;
//修改群组的图片
- (RACSignal *)uploadContactGroupAvatarImage:(NSString *)groupId avatarImage:(UIImage *)avatarImage;
//获得群组资料
- (RACSignal *)getContactGroupByGroupId:(NSString *)groupId;
- (RACSignal *)getContactGroupMembersByGroupId:(NSString *)groupId;



//登录完成后连接容云通讯
- (void)connectRCIM;



@end
