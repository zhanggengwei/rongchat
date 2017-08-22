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
@property (nonatomic,strong) RACCommand * contactListCommand;
@property (nonatomic,strong) RACCommand * searchUserInfoCommand;
@property (nonatomic,strong) RACCommand * addContactCommand;
@property (nonatomic,strong) RACCommand * modifyNickNameCommand;
@property (nonatomic,strong) RACCommand * resetPassWordCommand;
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
            dispatch_async(dispatch_get_main_queue(), ^{
                
                NSString * dbPath = [[PPFileManager sharedManager]pathForDomain:PPFileDirDomain_User appendPathName:userID];
                //创建用户文件夹
                BOOL isDir;
                OTF_FileExistsAtPath(dbPath, &isDir);
                if (!isDir) {
                    OTF_CreateDir(dbPath);
                }
                [self loginSucessUserID:userID phone:phone passWord:passWord loginToken:token];
                PPHTTPResponse * response = [PPHTTPResponse new];
                response.code = @200;
                response.message = @"登录成功";
                [self _completeWithResponse:response block:aResponseBlock];
                [[NSNotificationCenter defaultCenter]postNotificationName:kPPObserverLoginSucess object:nil];
                
            });
            [[PPDateEngine manager]requestGetUserInfoResponse:^(PPLoginOrRegisterHTTPResponse * aTaskResponse) {
                if(aTaskResponse.code.integerValue == kPPResponseSucessCode)
                {
                    PPUserBaseInfo * info = [PPUserBaseInfo new];
                    info.user = aTaskResponse.result;
                    [[PPTUserInfoEngine shareEngine]saveUserInfo:info];
                }
            } userID:userID];
            [self loginSucessAfterLoginRCIMResponse:^(PPHTTPResponse * aTaskResponse) {
                
                
            } loginToken:token UserID:userID phone:phone passWord:passWord];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        PPHTTPResponse *response = [PPHTTPResponse responseWithError:error];
        [self _completeWithResponse:response block:aResponseBlock];
        
    }];
    
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
    
    
    [manager POST:kPPUrlUpdateNickName([PPTUserInfoEngine shareEngine].user_Info.user.indexId) parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        PPHTTPResponse * resonse = [MTLJSONAdapter modelOfClass:[PPHTTPResponse class] fromJSONDictionary:responseObject error:nil];
        
        PPUserBaseInfo * user_info=[PPTUserInfoEngine shareEngine].user_Info;
        user_info.user.nickname = nickName;
        [[PPTUserInfoEngine shareEngine]saveUserInfo:user_info];
        
        [self _completeWithResponse:resonse block:aResponseBlock];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        PPHTTPResponse * response = [PPHTTPResponse responseWithError:error];
        [self _completeWithResponse:response block:aResponseBlock];
        
        
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
    
}
//登录成功之后进行数据的存储
- (void)loginSucessUserID:(NSString *)userID phone:(NSString *)phone passWord:(NSString *)passWord loginToken:(NSString *)token
{
    NSError * error;
    [SFHFKeychainUtils storeUsername:kPPLoginName andPassword:phone forServiceName:kPPServiceName updateExisting:YES error:&error];
    [SFHFKeychainUtils storeUsername:kPPLoginPassWord andPassword:passWord forServiceName:kPPServiceName updateExisting:YES error:&error];
    [SFHFKeychainUtils storeUsername:kPPLoginToken andPassword:token forServiceName:kPPServiceName updateExisting:YES error:&error];
    
    [SFHFKeychainUtils storeUsername:kPPUserInfoUserID andPassword:userID forServiceName:kPPServiceName updateExisting:YES error:&error];
}



//登录成功之后登录融云的即时通讯
- (void)loginSucessAfterLoginRCIMResponse:(PPResponseBlock())aResponseBlock loginToken:(NSString *)token UserID:(NSString *)userID phone:(NSString *)phone passWord:(NSString *)passWord
{
    [[PPChatTools shareManager]connectWithToken:token sucessBlock:^(NSString *content) {
        
    } failBlock:^(RCConnectErrorCode code) {
        NSLog(@"code == %ld",code);
        PPHTTPResponse * response = [PPHTTPResponse responseWithError:[NSError errorWithDomain:@"" code:code userInfo:nil]];
        [self _completeWithResponse:response block:aResponseBlock];
    } tokenIncorrectBlock:^{
        PPHTTPResponse * response = [PPHTTPResponse responseWithError:[NSError errorWithDomain:@"" code:904 userInfo:nil]];
        response.message = @"token错误";
        [self _completeWithResponse:response block:aResponseBlock];
    }];
}

- (RACCommand *)contactListCommand
{
    if(_contactListCommand==nil)
    {
        _contactListCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            RACSignal * signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                AFHTTPSessionManager * manager = [AFHTTPSessionManager new];
                [manager GET:kPPGetAllFriendsList parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
                    [subscriber sendNext:responseObject];
                    [subscriber sendCompleted];
                } failure:^(NSURLSessionDataTask *task, NSError *error) {
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
               [manager GET:kPPUrlUpdateNickName([PPTUserInfoEngine shareEngine].user_Info.user.indexId) parameters:input success:^(AFHTTPRequestOperation *operation, id responseObject) {
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

@end
