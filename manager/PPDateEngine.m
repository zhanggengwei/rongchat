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



#define ContentType @"application/json"
#define kPPUrlHttp @"http://api.sealtalk.im/"
#define kPPUrlLoginUrl [NSString stringWithFormat:@"%@user/login",kPPUrlHttp]
#define kPPUrlRegisiter [NSString stringWithFormat:@"%@user/regisiter",kPPUrlHttp]

//detail
//friendship/%@/profile
#define kPPUrlProfile(friendId) [NSString stringWithFormat:@"%@friendship/%@/profile",kPPUrlHttp,friendId]

#define kPPSendVirtifyCode [NSString stringWithFormat:@"%@user/send_code",kPPUrlHttp]

//friendship/all

#define kPPGetAllFriendsList [NSString stringWithFormat:@"%@friendship/all",kPPUrlHttp]
//user/change_password
#define kPPUpdatePassWord [NSString stringWithFormat:@"%@user/change_password",kPPUrlHttp]
//user/reset_password
#define kPPResetPassWord [NSString stringWithFormat:@"%@user/reset_password",kPPUrlHttp]

#define kPPUrlUserInfo(userId) [NSString stringWithFormat:@"%@user/%@",kPPUrlHttp,userId]

//设置备注
#define kPPUrlSetDispalyName [NSString stringWithFormat:@"%@friendship/set_display_name",kPPUrlHttp]

// 获取版本的信息 ///misc/client_version

#define kPPUrlGetVersions [NSString stringWithFormat:@"%@misc/client_version",kPPUrlHttp]
//update_profile
#define kPPUrlUpdateNickName [NSString stringWithFormat:@"%@update_profile",kPPUrlHttp]
// 获取image token user/get_image_token

#define kPPUrlUploadImageToken [NSString stringWithFormat:@"%@user/get_image_token",kPPUrlHttp]
//user/blacklist
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

#define KppUrlsetAvatuaUrl [NSString stringWithFormat:@"%@user/set_portrait_uri",kPPUrlHttp]

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
- (void)loginWithWithResponse:(PPResponseBlock())aResponseBlock Phone:(NSString *)phone passWord:(NSString *)passWord region:(NSString *)region
{

    PPHTTPManager *manager = [PPHTTPManager manager];
    NSDictionary * dict = @{
                            @"region" : region,
                            @"phone" : phone,
                            @"password" : passWord};
    [manager POST:kPPUrlLoginUrl parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSError * error;
        PPUserInfoTokenResponse * response = [MTLJSONAdapter modelOfClass:[PPUserInfoTokenResponse class] fromJSONDictionary:responseObject error:&error];
        NSString * token = ((PPTokenDef *)(response.result)).token;
        NSString * userID = ((PPTokenDef *)(response.result)).indexId;
        [self _completeWithResponse:response block:aResponseBlock];
        if(response.code.integerValue == kPPResponseSucessCode)
        {
        [[PPChatTools shareManager]connectWithToken:token sucessBlock:^(NSString *content) {
            NSError * error;
            [SFHFKeychainUtils storeUsername:kPPLoginName andPassword:phone forServiceName:kPPServiceName updateExisting:YES error:&error];
            [SFHFKeychainUtils storeUsername:kPPLoginPassWord andPassword:passWord forServiceName:kPPServiceName updateExisting:YES error:&error];
            [SFHFKeychainUtils storeUsername:kPPLoginToekn andPassword:token forServiceName:kPPServiceName updateExisting:YES error:&error];
            
            [SFHFKeychainUtils storeUsername:kPPUserInfoUserID andPassword:userID forServiceName:kPPServiceName updateExisting:YES error:&error];
            [[PPDateEngine manager]requestGetUserInfoResponse:^(PPLoginOrRegisterHTTPResponse * aTaskResponse) {
                if(aTaskResponse.code.integerValue == kPPResponseSucessCode)
                {
                    PPUserBaseInfo * info = [PPUserBaseInfo new];
                    info.user = aTaskResponse.result;
                    [[PPTUserInfoEngine shareEngine]saveUserInfo:info];
                    
                    [[NSNotificationCenter defaultCenter]postNotificationName:kPPObserverLoginSucess object:nil];
                }
                
            } userID:userID];
        
            
        } failBlock:^(RCConnectErrorCode code) {
            NSLog(@"code == %ld",code);
            
            
        } tokenIncorrectBlock:^{
            
            NSLog(@"token error");
        }];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        PPHTTPResponse *response = [PPHTTPResponse responseWithError:error];
        [self _completeWithResponse:response block:aResponseBlock];
        
    }];
    
}
/*
 
 + (void)getUserInfo:(NSString *)userId
 success:(void (^)(id response))success
 failure:(void (^)(NSError *err))failure {
 [AFHttpTool requestWihtMethod:RequestMethodTypeGet
 url:[NSString stringWithFormat:@"user/%@", userId]
 params:nil
 success:success
 failure:failure];
 */

- (void)requestGetUserInfoResponse:(PPResponseBlock())aResponseBlock userID:(NSString *)userId
{
    NSLog(@"userId ==%@",userId);
    
    PPHTTPManager * manager = [PPHTTPManager manager];
    [manager GET:kPPUrlUserInfo(userId) parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"responseObject =%@",responseObject);
        NSError * error;
        PPLoginOrRegisterHTTPResponse * response = [MTLJSONAdapter modelOfClass:[PPLoginOrRegisterHTTPResponse class] fromJSONDictionary:responseObject error:&error];
        [self _completeWithResponse:response block:aResponseBlock];
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        PPHTTPResponse * response = [PPHTTPResponse responseWithError:error];
        [self _completeWithResponse:response
                              block:aResponseBlock];
        
        
    }];
    
}

- (void)regisiterWithResponse:(PPResponseBlock())aResponseBlock  userName:(NSString *)userName verficationToken:(NSString *)token passWord:(NSString *)passWord

{
    
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
    NSDictionary *params = @{ @"region" : region, @"phone" : phoneNumber};
    
    [manager POST:kPPSendVirtifyCode parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
    
}

- (void)getFriendListResponse:(PPResponseBlock())aResponseBlock
{
    PPHTTPManager * manager = [PPHTTPManager manager];
    [manager GET:kPPGetAllFriendsList parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSError * error;
        PPUserFriendListResponse * response = [MTLJSONAdapter modelOfClass:[PPUserFriendListResponse class] fromJSONDictionary:responseObject error:&error];
        
        
        NSLog(@"%@",responseObject);

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
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
                             @"password" : passWord,
                             @"verification_token" : token
                             };
    
    [manager POST:kPPResetPassWord parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}
- (void)requestUpdateNickNameResponse:(PPResponseBlock())aResponseBlock nickName:(NSString *)nickName
{
    PPHTTPManager * manager = [PPHTTPManager manager];
    NSDictionary * dict = @{ @"username" : nickName};
    
    
    [manager POST:kPPUrlUpdateNickName parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
}

- (void)requestUploadImageToken:(PPResponseBlock())aResponseBlock
{
    PPHTTPManager * manager = [PPHTTPManager manager];
    
    [manager GET:kPPUrlUploadImageToken parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
    {
        NSError * error;
        PPUploadImageTokenResponse * response = [MTLJSONAdapter modelOfClass:[PPUploadImageTokenResponse class] fromJSONDictionary:responseObject error:&error];
        [self _completeWithResponse:response block:aResponseBlock];
        
        NSLog(@"responseObject == %@",responseObject);
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
    
    [manager POST:kPPUrlInviteFriend parameters:kPPUrlInviteFriend success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
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
            PPUserBaseInfo * baseInfo = [PPTUserInfoEngine shareEngine].user_Info;
            baseInfo.user.portraitUri = headUrl;
            [[PPTUserInfoEngine shareEngine]saveUserInfo:baseInfo];
            
        }
        [self _completeWithResponse:response block:aResponseBlock];
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error == %@",error);
        PPHTTPResponse * response = [PPHTTPResponse responseWithError:error];
        [self _completeWithResponse:response block:aResponseBlock];
    }];
    
}//user/set_portrait_uri

@end
