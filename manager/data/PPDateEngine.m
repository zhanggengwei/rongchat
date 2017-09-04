//
//  PPDateEngine.m
//  rongChatDemo1
//
//  Created by vd on 2016/10/30.
//  Copyright © 2016年 vd. All rights reserved.
//

#import "PPDateEngine.h"
#import "PPHTTPManager.h"
#import "PPHTTPResponse.h"
#import "PPFileManager.h"
#import "OTFileManager.h"

#define ContentType @"application/json"

@interface PPDateEngine ()
#pragma mark user
@property (nonatomic,strong) RACCommand * contactListCommand;
//查询用户信息
@property (nonatomic,strong) RACCommand * searchUserInfoCommand;
@property (nonatomic,strong) RACCommand * addContactCommand;
//用户修改名称
@property (nonatomic,strong) RACCommand * modifyNickNameCommand;
//密码重置
@property (nonatomic,strong) RACCommand * resetPassWordCommand;
//密码修改
@property (nonatomic,strong) RACCommand * updatePassWordCommand;
//好友黑名单
@property (nonatomic,strong) RACCommand * friendBlackListCommand;
//通过手机号查找好友
@property (nonatomic,strong) RACCommand * searchUserInfoByMobleCommand;
//设置好友备注信息
@property (nonatomic,strong) RACCommand * setFriendNickNameCommand;
//获取用户的详细资料
@property (nonatomic,strong) RACCommand * userInfoDetailCommand;
//加入黑名单
@property (nonatomic,strong) RACCommand * addFriendToBlackListCommand;
//删除黑名单中的成员
@property (nonatomic,strong) RACCommand * delFriendFromBlackListCommand;
//图片上传的token
@property (nonatomic,strong) RACCommand * uploadImageToken;
//token
@property (nonatomic,strong) RACCommand * token;
//登陆
@property (nonatomic,strong) RACCommand * loginCommand;
//注册
@property (nonatomic,strong) RACCommand * registerCommand;
//checkPhoneNumberAvailable 验证手机号码是否可用
@property (nonatomic,strong) RACCommand * checkPhoneNumberAvailableCommand;
//获得验证码
@property (nonatomic,strong) RACCommand * getVrificationCodeCommand;
//验证验证码
@property (nonatomic,strong) RACCommand * verfifyCodeCommand;

@property (nonatomic,strong) RACCommand * connectRCIMCommand;

#pragma mark contactGroup
//创建群聊
@property (nonatomic,strong) RACCommand * createContactGroupCommand;
//修改群聊的名称
@property (nonatomic,strong) RACCommand * modifyContactGroupNameCommand;
//查询群聊成员
@property (nonatomic,strong) RACCommand * groupMembersCommand;
//退出分组
@property (nonatomic,strong) RACCommand * leaveContactGroupCommand;
//解散群聊
@property (nonatomic,strong) RACCommand * dismissContactGroupCommand;
//删除分组中的成员
@property (nonatomic,strong) RACCommand * kickMembersContactGroupCommand;
//添加成员到群聊中
@property (nonatomic,strong) RACCommand * addMembersContactGroupCommand;
//申请加入群聊
@property (nonatomic,strong) RACCommand * joinInContactGroupCommand;
//所有的群聊
@property (nonatomic,strong) RACCommand * contactGroupsCommand;
//上传群聊的图片
@property (nonatomic,strong) RACCommand * uploadContactGroupAvatarImageCommand;
//获得群聊通过contactGroupId
@property (nonatomic,strong) RACCommand * contactGroupByGroupIdCommand;
//群公告
@property (nonatomic,strong) RACCommand * contactGroupPublicServiceCommand;

@end

@implementation PPDateEngine

+(instancetype)manager
{
    static dispatch_once_t token;
    static PPDateEngine * manager;
    dispatch_once(&token, ^{
        manager = [self new];
        
    });
    return manager;
}

- (void)_completeWithResponse:(PPHTTPResponse *)aResponse block:(PPResponseBlock())aResponseBlock
{
    if (aResponseBlock) {
        aResponseBlock(aResponse);
    }
}
- (void)registerWithResponse:(PPResponseBlock())aResponseBlock Phone:(NSString *)phone passWord:(NSString *)passWord verifyCode:(NSString *)code andNickName:(NSString *)nickName
{
    
}

- (void)requestGetUserInfoResponse:(PPResponseBlock())aResponseBlock userID:(NSString *)userId
{
    NSLog(@"userId ==%@",userId);
    
    PPHTTPManager * manager = [PPHTTPManager manager];
    [manager GET:kPPUrlUserInfo(userId) parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSError * error;
        PPLoginOrRegisterHTTPResponse * response = [MTLJSONAdapter modelOfClass:[PPLoginOrRegisterHTTPResponse class] fromJSONDictionary:responseObject error:&error];
        [self _completeWithResponse:response block:aResponseBlock];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        PPHTTPResponse * response = [PPHTTPResponse responseWithError:error];
        [self _completeWithResponse:response
                              block:aResponseBlock];
        
        
    }];
    
    RACCommand * command = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
        
        RACSignal * signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            [subscriber sendNext:nil];
            [subscriber sendError:nil];
            [subscriber sendCompleted];
            return nil;
        }];
        
        return  signal;
        
    }];
    [command.executionSignals subscribeNext:^(id x) {
        
    } error:^(NSError *error) {
        
    } completed:^{
        
    }];
    
    
    
    
}

- (void)regisiterWithResponse:(PPResponseBlock())aResponseBlock  userName:(NSString *)userName verficationToken:(NSString *)token passWord:(NSString *)passWord

{
    
}


- (void)requestJudegeVaildWithResponse:(PPResponseBlock())aResponseBlock   verfityCode:(NSString *)verificationCode region:(NSString *)region phone:(NSString *)phoneNumber
{
    
    PPHTTPManager * manager = [PPHTTPManager manager];
    NSDictionary *params = @{
                             @"region" : region,
                             @"phone" : phoneNumber,
                             @"code" : verificationCode
                             };
    
    [manager POST:kPPVertifyPhoneIsValid parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        PPJudgeVerificationResponse * response = [MTLJSONAdapter modelOfClass:[PPJudgeVerificationResponse class] fromJSONDictionary:responseObject error:nil];
        [self _completeWithResponse:response block:aResponseBlock];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        PPHTTPResponse * response = [PPHTTPResponse responseWithError:error];
        [self _completeWithResponse:response block:aResponseBlock];
    }];
    
}

/*
 + (void)registerWithNickname:(NSString *)nickname
 password:(NSString *)password
 verficationToken:(NSString *)verficationToken
 success:(void (^)(id response))success
 failure:(void (^)(NSError *err))failure {
 NSDictionary *params = @{
 @"nickname" : nickname,
 @"password" : password,
 @"verification_token" : verficationToken
 };
 
 [AFHttpTool requestWihtMethod:RequestMethodTypePost
 url:@"user/register"
 params:params
 success:success
 failure:failure];
 }
 */


//获取用户详细资料
- (void)getFriendDetailsByID:(NSString *)friendId
                     success:(void (^)(id response))success
                     failure:(void (^)(NSError *err))failure
{
    
    PPHTTPManager * manager = [PPHTTPManager manager];
    [manager GET:kPPUrlUserInfo(friendId) parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
}

//设置好友备注
- (void)setFriendDisplayName:(NSString *)friendId
                 displayName:(NSString *)displayName
                     success:(void (^)(id response))success
                     failure:(void (^)(NSError *err))failure {
    NSDictionary *params = @{
                             @"friendId" : friendId,
                             @"displayName" : displayName
                             };
    PPHTTPManager * manager = [PPHTTPManager manager];
    [manager POST:kPPUrlSetDispalyName parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
}

//获取版本信息
- (void)getVersionsuccess:(void (^)(id response))success
                  failure:(void (^)(NSError *err))failure
{
    
    PPHTTPManager * manager = [PPHTTPManager manager];
    [manager GET:kPPUrlGetVersions parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
}

- (void)sendVerifyWithResponse:(PPResponseBlock())aResponseBlock phone:(NSString *)phoneNumber regionString:(NSString *)region
{
    PPHTTPManager * manager = [PPHTTPManager manager];
    NSDictionary *params = @{@"region": region,@"phone" : phoneNumber};
    
    [manager POST:kPPSendVirtifyCode parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSError * error;
        PPHTTPResponse * response = [MTLJSONAdapter modelOfClass:[PPHTTPResponse class] fromJSONDictionary:responseObject error:&error];
        [self _completeWithResponse:response block:aResponseBlock];
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        PPHTTPResponse * response = [PPHTTPResponse responseWithError:error];
        [self _completeWithResponse:response block:aResponseBlock];
    }];
    
    
}

- (void)getFriendListResponse:(PPResponseBlock())aResponseBlock
{
    PPHTTPManager * manager = [PPHTTPManager manager];
    [manager GET:kPPGetAllFriendsList parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSError * error;
        PPUserFriendListResponse * response = [MTLJSONAdapter modelOfClass:[PPUserFriendListResponse class] fromJSONDictionary:responseObject error:&error];
        [self _completeWithResponse:response block:aResponseBlock];
        
        NSLog(@"%@",responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        PPHTTPResponse * response = [PPHTTPResponse responseWithError:error];
        [self _completeWithResponse:response block:aResponseBlock];
        
    }];
    
}

- (void)searchUserInfoResponse:(PPResponseBlock())aResponseBlock friendID:(NSString *)friendid
{
    PPHTTPManager * manager = [PPHTTPManager manager];
    [manager GET:kPPUrlProfile(friendid) parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
}

//设置用户的备注信息

- (void)setResponse:(PPResponseBlock())aResponseBlock  DisPlayName:(NSString *)displayName friendID:(NSString *)afriendID
{
    PPHTTPManager * manager = [PPHTTPManager manager];
    NSDictionary * dict = @{@"friendId":afriendID,@"displayName":displayName};
    
    [manager POST:kPPUrlSetDispalyName parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
}
- (void)requestResponse:(PPResponseBlock())aResponseBlock
         changePassWord:(NSString *)newPassWord oldPassWord:(NSString * )oldPassWord
{
    PPHTTPManager * manager = [PPHTTPManager manager];
    NSDictionary * params = @{@"oldPassword" : oldPassWord, @"newPassword" : newPassWord};
    
    [manager POST:kPPUpdatePassWord parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSError * error;
        PPHTTPResponse * reponse = [MTLJSONAdapter modelOfClass:[PPHTTPResponse class] fromJSONDictionary:responseObject error:&error];
        [self _completeWithResponse:reponse block:aResponseBlock];
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        PPHTTPResponse * response = [PPHTTPResponse responseWithError:error];
        [self _completeWithResponse:response block:aResponseBlock];
        
    }];
}
- (void)requestResetPassWordResponse:(void (^)(id))aResponseBlock resetPassWord:(NSString *)passWord verification_token:(NSString *)token
{
    PPHTTPManager * manager = [PPHTTPManager manager];
    NSDictionary *params = @{
                             @"password":passWord,
                             @"verification_token" : token
                             };
    
    [manager POST:kPPResetPassWord parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"response object == %@",responseObject);
        PPHTTPResponse * response = [MTLJSONAdapter modelOfClass:[PPHTTPResponse class] fromJSONDictionary:responseObject error:nil];
        [self _completeWithResponse:response block:aResponseBlock];
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        PPHTTPResponse * response = [PPHTTPResponse responseWithError:error];
        [self _completeWithResponse:response block:aResponseBlock];
        
        
    }];
}
- (void)requestUpdateNickNameResponse:(PPResponseBlock())aResponseBlock nickName:(NSString *)nickName
{
    PPHTTPManager * manager = [PPHTTPManager manager];
    NSDictionary * dict = @{@"nickname" : nickName};
    
    
    //    [manager POST:kPPUrlUpdateNickName([PPTUserInfoEngine shareEngine].user_Info.user.userId) parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
    //        PPHTTPResponse * resonse = [MTLJSONAdapter modelOfClass:[PPHTTPResponse class] fromJSONDictionary:responseObject error:nil];
    //
    //        PPUserBaseInfo * user_info=[PPTUserInfoEngine shareEngine].user_Info;
    //        user_info.user.name = nickName;
    //        [[PPTUserInfoEngine shareEngine]saveUserInfo:user_info];
    //
    //        [self _completeWithResponse:resonse block:aResponseBlock];
    //
    //    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    //
    //        PPHTTPResponse * response = [PPHTTPResponse responseWithError:error];
    //        [self _completeWithResponse:response block:aResponseBlock];
    //
    //
    //    }];
    
}

- (void)requestUploadImageToken:(PPResponseBlock())aResponseBlock
{
    PPHTTPManager * manager = [PPHTTPManager manager];
    
    [manager GET:kPPUrlUploadImageToken parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSError * error;
         PPUploadImageTokenResponse * response = [MTLJSONAdapter modelOfClass:[PPUploadImageTokenResponse class] fromJSONDictionary:responseObject error:&error];
         [self _completeWithResponse:response block:aResponseBlock];
         
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         NSLog(@"error == %@",error);
         PPHTTPResponse * response = [PPHTTPResponse responseWithError:error];
         [self _completeWithResponse:response block:aResponseBlock];
         
     }];
}

- (void)requsetUploadImageResponse:(PPResponseBlock())aResponseBlock UploadFile:(NSData *)imageData UserId:(NSString *)auserId uploadToken:(NSString *)token
{
    //进行 图片的上传
    
    
    //获取系统当前的时间戳
    NSDate *dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval now = [dat timeIntervalSince1970] * 1000;
    NSString *timeString = [NSString stringWithFormat:@"%f", now];
    NSString *key = [NSString stringWithFormat:@"%@%@", auserId, timeString];
    //去掉字符串中的.
    NSMutableString *str = [NSMutableString stringWithString:key];
    for (int i = 0; i < str.length; i++) {
        unichar c = [str characterAtIndex:i];
        NSRange range = NSMakeRange(i, 1);
        if (c == '.') { //此处可以是任何字符
            [str deleteCharactersInRange:range];
            --i;
        }
    }
    key = [NSString stringWithString:str];
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setValue:token forKey:@"token"];
    [params setValue:key forKey:@"key"];
    
    NSMutableDictionary *ret = [NSMutableDictionary dictionary];
    [params addEntriesFromDictionary:ret];
    
    NSString *url = @"http://upload.qiniu.com";
    PPHTTPManager * manager = [PPHTTPManager manager];
    [manager POST:url
       parameters:params
constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
    [formData appendPartWithFileData:imageData
                                name:@"file"
                            fileName:key
                            mimeType:@"application/octet-stream"];
}
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              NSLog(@"resoonse == %@",responseObject);
              
              NSString * url = [NSString stringWithFormat:@"http://7xogjk.com1.z0.glb.clouddn.com/%@",responseObject[@"key"]];
              [self requestSetHeadUrlResponse:^(PPHTTPResponse * aTaskResponse) {
                  [self _completeWithResponse:aTaskResponse block:aResponseBlock];
                  
              } headUrl:url];
              
              
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              NSLog(@"请求失败");
              PPHTTPResponse * response = [PPHTTPResponse responseWithError:error];
              [self _completeWithResponse:response block:aResponseBlock];
              
          }];
}
- (void)requestGetBlackFriendListResponse:(PPResponseBlock())aResponseBlock
{
    PPHTTPManager * manager = [PPHTTPManager manager];
    [manager GET:kPPUrlBlackUserList parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
}
- (void)requestAddBlackFriendListResponse:(PPResponseBlock())aResponseBlock  friendUserId:(NSString *)userId
{
    PPHTTPManager * manager = [PPHTTPManager manager];
    NSDictionary *params = @{ @"friendId" : userId };
    [manager POST:kPPUrlAddFriendBlackList parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}
- (void)requsetDeleteBlackFriendListResponse:(PPResponseBlock())aResponseBlock  friendUserId:(NSString *)userId
{
    PPHTTPManager * manager = [PPHTTPManager manager];
    NSDictionary *params = @{ @"friendId" : userId };
    [manager POST:kPPUrlDeleteFriendBlackList parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

- (void)requsetGetAllGroups:(PPResponseBlock())aResponseBlock
{
    PPHTTPManager * manager = [PPHTTPManager manager];
    [manager GET:kPPUrlGetAllGroups parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}
- (void)requestGetGroupDetails:(PPResponseBlock())aResponseBlock groupId:(NSString *)groupId
{
    PPHTTPManager * manager = [PPHTTPManager manager];
    [manager GET:kPPUrlGetGroupId(groupId) parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}
- (void)requsetGetGroupMembers:(PPResponseBlock())aResponseBlock groupId:(NSString *)groupId
{
    PPHTTPManager * manager = [PPHTTPManager manager];
    [manager GET:kPPUrlGetGroupMember(groupId) parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
}
- (void)requsetJoinResponse:(PPResponseBlock())aResponseBlock Group:(NSString *)groupId
{
    PPHTTPManager * manager = [PPHTTPManager manager];
    NSDictionary *params = @{ @"groupId" : groupId };
    
    [manager POST:kPPUrlJoinGroup parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
}
- (void)requestInviteResponse:(PPResponseBlock())aResponseBlock
                      usersId:(NSMutableArray *)usersIdArr groupID:(NSString *)agroupId
{
    
    PPHTTPManager * manager = [PPHTTPManager manager];
    NSDictionary *params = @{ @"groupId" : agroupId, @"memberIds" : usersIdArr };
    [manager POST:kPPUrlInviteUserGroup parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
}
- (void)requestKickResponse:(PPResponseBlock())aResponseBlock
                 OutOfGroup:(NSString *)groupID
                    usersId:(NSMutableArray *)usersId
{
    PPHTTPManager * manager = [PPHTTPManager manager];
    NSDictionary *params = @{ @"groupId" : groupID, @"memberIds" : usersId };
    [manager POST:kPPUrlKickGroup parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
}
- (void)requsetQuitGroupResponse:(PPResponseBlock())aResponseBlock OutOfGroup:(NSString *)groupID
{
    NSDictionary *params = @{ @"groupId" : groupID };
    PPHTTPManager * manager = [PPHTTPManager manager];
    [manager POST:kPPUrlQuitGroup parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}
- (void)requestDismissGroupResponse:(PPResponseBlock()) aResponseBlock dismissGroupId:(NSString *)groupId
{
    PPHTTPManager * manager = [PPHTTPManager manager];
    NSDictionary *params = @{ @"groupId" : groupId };
    [manager POST:kPPUrlDismissGroup parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
}
- (void)requsetCreateGroupResponse:(PPResponseBlock()) aResponseBlock GroupName:(NSString *)groupName
                   groupMemberList:(NSArray *)groupMemberList
{
    PPHTTPManager * manager = [PPHTTPManager manager];
    NSDictionary *params = @{
                             @"name" : groupName,
                             @"memberIds" : groupMemberList
                             };
    [manager POST:kPPUrlCreateGroup parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
}
- (void)requsetUpdateGroupResponse:(void (^)(id))aResponseBlock GroupName:(NSString *)groupName groupId:(NSString *)groupId
{
    PPHTTPManager * manager = [PPHTTPManager manager];
    NSDictionary *params = @{ @"groupId" : groupId, @"name" : groupName };
    [manager POST:kPPUrlRenameGroupName parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}
- (void)requsetInviteUsersResponse:(void (^)(id))aResponseBlock addUserId:(NSString *)friendUserID content:(NSString *)content
{
    PPHTTPManager * manager = [PPHTTPManager manager];
    NSDictionary *params = @{
                             @"friendId" : friendUserID,
                             @"message" : content};
    
    [manager POST:kPPUrlInviteFriend parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
}

- (void)requestSetHeadUrlResponse:(PPResponseBlock())aResponseBlock  headUrl:(NSString *)headUrl
{
    PPHTTPManager * manager = [PPHTTPManager manager];
    NSDictionary *params = @{ @"portraitUri" : headUrl };
    [manager POST:KppUrlsetAvatuaUrl parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
        PPHTTPResponse * response = [MTLJSONAdapter modelOfClass:[PPHTTPResponse class] fromJSONDictionary:responseObject error:nil];
        if(response.code.integerValue == kPPResponseSucessCode)
        {
          
        }
        [self _completeWithResponse:response block:aResponseBlock];
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error == %@",error);
        PPHTTPResponse * response = [PPHTTPResponse responseWithError:error];
        [self _completeWithResponse:response block:aResponseBlock];
    }];
    
}

- (RACCommand *)contactListCommand
{
    if(_contactListCommand==nil)
    {
        _contactListCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            RACSignal * signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                PPHTTPManager * manager = [PPHTTPManager manager];
                [manager GET:kPPGetAllFriendsList parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
                    NSError * error;
                    PPUserFriendListResponse * response = [MTLJSONAdapter modelOfClass:[PPUserFriendListResponse class] fromJSONDictionary:responseObject error:&error];
                    [subscriber sendNext:response];
                    [subscriber sendCompleted];
                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    [subscriber sendError:error];
                    [subscriber sendCompleted];
                }];
                return nil;
            }];
            return signal;
        }];
    }
    return _contactListCommand;
}

- (RACCommand *)searchUserInfoCommand
{
    if(_searchUserInfoCommand==nil)
    {
        _searchUserInfoCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            RACSignal * signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                PPHTTPManager * manager = [PPHTTPManager manager];
                [manager GET:kPPUrlUserInfo(input) parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
                    NSError * error;
                    PPUserBaseInfoResponse * response = [MTLJSONAdapter modelOfClass:[PPUserBaseInfoResponse class] fromJSONDictionary:responseObject error:&error];
                    [subscriber sendNext:response];
                    [subscriber sendCompleted];
                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    [subscriber sendError:error];
                    [subscriber sendCompleted];
                }];
                return nil;
            }];
            return signal;
        }];
        
    }
    return _searchUserInfoCommand;
}

- (RACCommand *)addContactCommand
{
    if(_addContactCommand==nil)
    {
        _addContactCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            RACSignal * signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                PPHTTPManager * manager = [PPHTTPManager manager];
                [manager POST:kPPUrlInviteFriend parameters:input success:^(AFHTTPRequestOperation *operation, id responseObject) {
                    [subscriber sendNext:responseObject];
                    [subscriber sendCompleted];
                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    [subscriber sendError:error];
                    [subscriber sendCompleted];
                }];
                return nil;
            }];
            return signal;
        }];
        
    }
    return _addContactCommand;
}

- (RACCommand *)modifyNickNameCommand
{
    
    if (_modifyNickNameCommand==nil) {
        _modifyNickNameCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            RACSignal * signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                PPHTTPManager * manager = [PPHTTPManager manager];
                [manager GET:kPPUrlUpdateNickName([PPTUserInfoEngine shareEngine].user_Info.user.userId) parameters:input success:^(AFHTTPRequestOperation *operation, id responseObject) {
                    [subscriber sendNext:responseObject];
                    [subscriber sendCompleted];
                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    [subscriber sendError:error];
                    [subscriber sendCompleted];
                }];
                return nil;
            }];
            return signal;
        }];
    }
    return _modifyNickNameCommand;
}
#pragma mark contactGroup
- (RACCommand *)createContactGroupCommand
{
    if(_createContactGroupCommand==nil)
    {
        _createContactGroupCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            RACSignal * signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                PPHTTPManager * manager = [PPHTTPManager manager];
                [manager GET:@"" parameters:@"" success:^(AFHTTPRequestOperation *operation, id responseObject) {
                    
                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    
                }];
                return nil;
            }];
            return signal;
        }];
    }
    return _createContactGroupCommand;
}

- (RACCommand *)addMembersContactGroupCommand
{
    if(_addMembersContactGroupCommand==nil)
    {
        _addMembersContactGroupCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            RACSignal * signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                
                return nil;
            }];
            return signal;
        }];
    }
    return _addMembersContactGroupCommand;
}

- (RACCommand *)uploadContactGroupAvatarImageCommand
{
    if(_uploadContactGroupAvatarImageCommand==nil)
    {
        _uploadContactGroupAvatarImageCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
             RACSignal * signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                 return nil;
             }];
            return signal;
        }];
    }
    return _uploadContactGroupAvatarImageCommand;
}
- (RACCommand *)modifyContactGroupNameCommand
{
    if(_modifyContactGroupNameCommand==nil)
    {
        _modifyContactGroupNameCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            RACSignal * signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                return nil;
            }];
            return signal;
        }];
    }
    return _modifyContactGroupNameCommand;
}

- (RACCommand *)kickMembersContactGroupCommand
{
    if(_kickMembersContactGroupCommand==nil)
    {
        _kickMembersContactGroupCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            RACSignal * signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                return nil;
            }];
            return signal;
        }];
    }
    return _kickMembersContactGroupCommand;
}

- (RACCommand *)contactGroupByGroupIdCommand
{
    if(_contactGroupByGroupIdCommand==nil)
    {
        _contactGroupByGroupIdCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            RACSignal * signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                return nil;
            }];
            return signal;
        }];
    }
    return _contactGroupByGroupIdCommand;
}

- (RACCommand *)groupMembersCommand
{
    if(_groupMembersCommand==nil)
    {
        _groupMembersCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            RACSignal * signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                return nil;
            }];
            return signal;
        }];
    }
    return _groupMembersCommand;
}

- (RACCommand *)leaveContactGroupCommand
{
    if(_leaveContactGroupCommand==nil)
    {
        _leaveContactGroupCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            RACSignal * signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                return nil;
            }];
            return signal;
        }];
    }
    return _leaveContactGroupCommand;
}

- (RACCommand *)joinInContactGroupCommand
{
    if(_joinInContactGroupCommand==nil)
    {
        _joinInContactGroupCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            RACSignal * signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                return nil;
            }];
            return signal;
        }];
    }
    return _joinInContactGroupCommand;
}

- (RACCommand *)dismissContactGroupCommand
{
    if(_dismissContactGroupCommand==nil)
    {
        _dismissContactGroupCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            RACSignal * signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                return nil;
            }];
            return signal;
        }];
    }
    return _dismissContactGroupCommand;
}

- (RACCommand *)contactGroupPublicServiceCommand
{
    if(_contactGroupPublicServiceCommand==nil)
    {
        _contactListCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            RACSignal * signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                return nil;
            }];
            return signal;
        }];
    }
    return _contactGroupPublicServiceCommand;
}





#pragma mark user

- (RACCommand *)resetPassWordCommand
{
    if(_resetPassWordCommand == nil)
    {
        _resetPassWordCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            RACSignal * signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                PPHTTPManager * manager = [PPHTTPManager manager];
                [manager GET:kPPResetPassWord parameters:input success:^(AFHTTPRequestOperation *operation, id responseObject) {
                    [subscriber sendNext:responseObject];
                    [subscriber sendCompleted];
                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    [subscriber sendError:error];
                    [subscriber sendCompleted];
                }];
                return nil;
            }];
            return signal;
        }];
    }
    return _resetPassWordCommand;
}

- (RACCommand *)updatePassWordCommand
{
    if(_updatePassWordCommand==nil)
    {
        _updatePassWordCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            RACSignal * signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                PPHTTPManager * manager = [PPHTTPManager manager];
                [manager GET:nil parameters:input success:^(AFHTTPRequestOperation *operation, id responseObject) {
                    [subscriber sendNext:responseObject];
                    [subscriber sendCompleted];
                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    [subscriber sendError:error];
                    [subscriber sendCompleted];
                }];
                return nil;
            }];
            return signal;
        }];
    }
    return _updatePassWordCommand;
}

- (RACCommand *)friendBlackListCommand
{
    if(_friendBlackListCommand==nil)
    {
        
        _friendBlackListCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            RACSignal * signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                return nil;
            }];
            return signal;
        }];
    }
    return _friendBlackListCommand;
}
- (RACCommand *)connectRCIMCommand
{
    if(!_connectRCIMCommand)
    {
        _connectRCIMCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            NSLog(@"input ==%@",input);
            RACSignal * signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                /*
                 {
                 "code": 200,
                 "result": {
                 "id": "jnKhfP960",
                 "token": "J/sWDPJrtOC9T7MuaZnpgq+YsUIoF3ojin3K277sfOnr8J7ydLsAKLTqeaYCOeAP/59uSO1/vWDyDgkMFKAXBKtdpZUyLdaH"
                 }
                 }*/
//                [[RCIMClient sharedRCIMClient]connectWithToken:input success:^(NSString *userId) {
//                    [subscriber sendNext:userId];
//                    [subscriber sendCompleted];
//                    
//                } error:^(RCConnectErrorCode status) {
//                    NSLog(@"dd");
//                } tokenIncorrect:^{
//                    NSLog(@"dd");
//                }];
                [[RCIMClient sharedRCIMClient]connectWithToken:input success:nil error:nil tokenIncorrect:nil];
                
                return [RACDisposable disposableWithBlock:^{
                    
                }];
                
            }];
            return signal;
        }];
    }
    return _connectRCIMCommand;
}

- (RACCommand *)loginCommand
{
    if(_loginCommand==nil)
    {
        _loginCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            RACSignal * signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                PPHTTPManager * manager = [PPHTTPManager manager];
                [manager POST:kPPUrlLoginUrl parameters:input success:^(AFHTTPRequestOperation *operation, id responseObject) {
                    NSError * error;
                    PPUserInfoTokenResponse * response = [MTLJSONAdapter modelOfClass:[PPUserInfoTokenResponse class] fromJSONDictionary:responseObject error:&error];
                    [subscriber sendNext:response];
                    [subscriber sendCompleted];
                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    [subscriber sendError:error];
                    [subscriber sendCompleted];
                }];
                return nil;
            }];
            return signal;
        }];
    }
    return _loginCommand;
}

- (RACCommand *)userInfoDetailCommand
{
    if(_userInfoDetailCommand==nil)
    {
        _userInfoDetailCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            RACSignal * signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                PPHTTPManager * manager = [PPHTTPManager manager];
                [manager GET:kPPUrlProfile(input) parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
                    NSError * error;
                    PPContactGroupListResponse * resoponse = [MTLJSONAdapter modelOfClass:[PPContactGroupListResponse class] fromJSONDictionary:responseObject error:&error];
                    [subscriber sendNext:resoponse];
                    [subscriber sendCompleted];
                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    [subscriber sendError:error];
                    [subscriber sendCompleted];
                }];
                return nil;
            }];
            return signal;
        }];
    }
    return _userInfoDetailCommand;
}

- (RACCommand *)contactGroupsCommand
{
    if(_contactGroupsCommand==nil)
    {
        _contactGroupsCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            RACSignal * signale = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                PPHTTPManager * manager = [PPHTTPManager manager];
                [manager GET:kPPUrlGetAllGroups parameters:input success:^(AFHTTPRequestOperation *operation, id responseObject) {
                    NSError * error;
                    PPContactGroupListResponse * resoponse = [MTLJSONAdapter modelOfClass:[PPContactGroupListResponse class] fromJSONDictionary:responseObject error:&error];
                    [subscriber sendNext:resoponse];
                    [subscriber sendCompleted];
                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    [subscriber sendError:error];
                    [subscriber sendCompleted];
                }];
                return nil;
            }];
            return signale;
        }];
    }
    return _contactGroupsCommand;
}

- (RACSignal *)getContactListCommandWithUserId:(NSString *)userId
{
    return [self.contactListCommand execute:@{}];
}
- (RACSignal *)getContactGroupsCommand
{
    return [self.contactGroupsCommand execute:nil];
}
//通过userId 获得个人信息的接口
- (RACSignal *)getUserInfoCommandByUserId:(NSString *)userId
{
    return [self.searchUserInfoCommand execute:userId];
}
- (RACSignal *)loginCommandWithUserName:(NSString *)account passWord:(NSString *)passWord region:(NSString *)region
{
    NSMutableDictionary * params = [NSMutableDictionary new];
    if(account)
    {
        [params setObject:account forKey:@"phone"];
    }
    if(passWord)
    {
        [params setObject:passWord forKey:@"password"];
    }
    if(region)
    {
        [params setObject:region forKey:@"region"];
    }
    return [self.loginCommand execute:params];
}
- (void)connectRCIM
{
    [[RCIMClient sharedRCIMClient]connectWithToken:[PPTUserInfoEngine shareEngine].token success:^(NSString *userId) {
    } error:^(RCConnectErrorCode status) {
        NSLog(@"dd");
    } tokenIncorrect:^{
        NSLog(@"dd");
    }];
//    [self.connectRCIMCommand execute:[PPTUserInfoEngine shareEngine].token];
//    
}
- (RACSignal *)getUserInfoDetailCommand:(NSString *)friendId
{
    return [self.userInfoDetailCommand execute:friendId];
}
//创建群组成员
- (RACSignal *)createContactGroupName:(NSString *)name members:(NSArray<NSString *> *)userIds
{
    return [self.createContactGroupCommand execute:nil];
    
}
//删除群组的成员
- (RACSignal *)deleteMemberFormContactGroup:(NSString *)groudId members:(NSArray<NSString *> *)userIds
{
    return  [self.kickMembersContactGroupCommand execute:nil];
}
//添加群组成员
- (RACSignal *)addMemberFormContactGroup:(NSString *)groudId members:(NSArray<NSString *> *)userIds
{
    return [self.addMembersContactGroupCommand execute:nil];
}
//修改群姓名
- (RACSignal *)updateContactGroupName:(NSString *)groupName withGroupId:(NSString *)groupId
{
    return [self.modifyContactGroupNameCommand execute:nil];
}
//退出群组
- (RACSignal *)leaveContactGroup:(NSString *)groupId
{
  return  [self.leaveContactGroupCommand execute:nil];
}
//解散群组
- (RACSignal *)dismissContactGroup:(NSString *)groupId
{
   return [self.dismissContactGroupCommand execute:nil];
}
//发布群公告
- (RACSignal *)submitContactGroupPublicService:(NSString *)groupId publicService:(NSString *)publicService
{
    return [self.contactGroupPublicServiceCommand execute:nil];
}
//修改群组的图片
- (RACSignal *)uploadContactGroupAvatarImage:(NSString *)groupId avatarImage:(UIImage *)avatarImage
{
    return [self.uploadContactGroupAvatarImageCommand execute:nil];
}
@end
