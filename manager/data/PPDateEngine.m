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
@property (nonatomic,strong) RACCommand * uploadFileCommand;//文件上传
@property (nonatomic,strong) RACCommand * setAvatarUrlCommand;


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

#pragma mark lazy User

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

- (RACCommand *)getVrificationCodeCommand
{
    if(_getVrificationCodeCommand==nil)
    {
        _getVrificationCodeCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            RACSignal * signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                PPHTTPManager * manager = [PPHTTPManager manager];
                [manager POST:kPPSendVirtifyCode parameters:input success:^(AFHTTPRequestOperation *operation, id responseObject) {
                    
                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    
                }];
                return nil;
            }];
            return signal;
        }];
    }
    return _getVrificationCodeCommand;
}

- (RACCommand *)verfifyCodeCommand
{
    if(_verfifyCodeCommand==nil)
    {
        _verfifyCodeCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            RACSignal * signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                PPHTTPManager * manager = [PPHTTPManager manager];
                [manager POST:kPPVertifyPhoneIsValid parameters:input success:^(AFHTTPRequestOperation *operation, id responseObject) {
                    
                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    
                }];
                return nil;
            }];
            return signal;
        }];
    }
    return _verfifyCodeCommand;
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

- (RACCommand *)uploadImageToken
{
    if(_uploadImageToken==nil)
    {
        _uploadImageToken = [[RACCommand alloc]initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            RACSignal * signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                PPHTTPManager * manager = [PPHTTPManager manager];
                [manager GET:kPPUrlUploadImageToken parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
                
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
    return _uploadImageToken;
}

- (RACCommand *)uploadFileCommand
{
    RACCommand * command = [[RACCommand alloc]initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        
        RACSignal * signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            PPHTTPManager * manager = [PPHTTPManager manager];
            //获取系统当前的时间戳
            NSDate *dat = [NSDate dateWithTimeIntervalSinceNow:0];
            NSTimeInterval now = [dat timeIntervalSince1970] * 1000;
            NSString *timeString = [NSString stringWithFormat:@"%f", now];
            NSString *key = [NSString stringWithFormat:@"%@%@",[PPTUserInfoEngine shareEngine].userId, timeString];
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
            NSMutableDictionary * params = [NSMutableDictionary new];
            [params setObject:input[@"token"] forKey:@"token"];
            [params setObject:key forKey:@"key"];
            NSMutableDictionary *ret = [NSMutableDictionary dictionary];
            [params addEntriesFromDictionary:ret];
            [manager POST:@"https://up.qbox.me" parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                [formData appendPartWithFileData:[input objectForKey:@"image"]
                                            name:@"file"
                                        fileName:key
                                        mimeType:@"application/octet-stream"];
                
            } success:^(AFHTTPRequestOperation *operation, id responseObject) {
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
    return command;
}

- (RACCommand *)setAvatarUrlCommand
{
    if(_setAvatarUrlCommand==nil)
    {
        _setAvatarUrlCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
           return  [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                PPHTTPManager * manager = [PPHTTPManager manager];
                [manager POST:KppUrlSetAvatuaUrl parameters:input success:^(AFHTTPRequestOperation *operation, id responseObject) {
                    [subscriber sendNext:responseObject];
                    [subscriber sendCompleted];
                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    [subscriber sendError:error];
                    [subscriber sendCompleted];
                }];
               return nil;
               
            }];
        }];
    }
    return _setAvatarUrlCommand;
}


#pragma mark lazy contactGroup
- (RACCommand *)createContactGroupCommand
{
    if(_createContactGroupCommand==nil)
    {
        _createContactGroupCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            RACSignal * signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                PPHTTPManager * manager = [PPHTTPManager manager];
                RCContactGroupData * data = input;
                NSMutableDictionary * params = [NSMutableDictionary new];
                NSMutableArray * uids = [NSMutableArray new];
                NSMutableArray * names = [NSMutableArray new];
                [uids addObject:[PPTUserInfoEngine shareEngine].userId];
                for (RCUserInfoData * model in data.memberList) {
                    [uids addObject:model.user.userId];
                    [names addObject:model.user.name];
                }
                if(uids)
                {
                    [params setObject:uids forKey:@"memberIds"];
                }
                if(names)
                {
                    data.name = [names componentsJoinedByString:@","];
                    [params setObject:data.name forKey:@"name"];
                }
                [manager POST:kPPUrlCreateGroup parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
                    NSError * error;
                    NSLog(@"operation==%@",operation);
                    PPContactGroupSingleResponse * response = [MTLJSONAdapter modelOfClass:[PPContactGroupSingleResponse class] fromJSONDictionary:responseObject error:&error];
                    if(response.code.integerValue == kPPResponseSucessCode)
                    {
                        data.indexId = ((RCContactGroupData *)response.result).indexId;
                        PPTContactGroupModel * model = [PPTContactGroupModel new];
                        model.role = 1;
                        model.group = data;
//                        [[PPTUserInfoEngine shareEngine]addOrUpdateContactGroup:model
//                         ];
                    }
                    NSLog(@"response == %@",response);
                    
                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    NSLog(@"operation==%@",operation);
                    
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
                PPHTTPManager * manager = [PPHTTPManager manager];
                [manager POST:kPPUrlKickGroup parameters:input success:^(AFHTTPRequestOperation *operation, id responseObject) {
                    
                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    
                }];
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
                PPHTTPManager * manager = [PPHTTPManager manager];
                [manager POST:kPPUrlRenameGroupName parameters:input success:^(AFHTTPRequestOperation *operation, id responseObject) {
                    
                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    
                }];
                
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
                PPHTTPManager * manager = [PPHTTPManager manager];
                [manager POST:kPPUrlKickGroup parameters:input success:^(AFHTTPRequestOperation *operation, id responseObject) {
                    
                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    
                }];
                
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
                PPHTTPManager * manager = [PPHTTPManager manager];
                [manager GET:kPPUrlGetGroupId(input) parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
                    NSLog(@"operation == %@",operation);
                    NSError * error = nil;
                    PPContactGroupSingleResponse * response = [MTLJSONAdapter modelOfClass:[PPContactGroupSingleResponse class] fromJSONDictionary:responseObject error:&error];
                    [subscriber sendNext:response.result];
                    [subscriber sendCompleted];
                    

                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    NSLog(@"operation == %@",operation);
                }];
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
                PPHTTPManager * manager = [PPHTTPManager manager];
                [manager GET:kPPUrlGetGroupMember(input) parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
                    NSError * error = nil;
                    PPContactGroupMemberListResponse * response = [MTLJSONAdapter modelOfClass:[PPContactGroupMemberListResponse class] fromJSONDictionary:responseObject error:&error];
                    [subscriber sendNext:response];
                    [subscriber sendCompleted];
                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    NSLog(@"error == %@",error);
                }];
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
                
                PPHTTPManager * manager = [PPHTTPManager manager];
                [manager POST:kPPUrlQuitGroup parameters:input success:^(AFHTTPRequestOperation *operation, id responseObject) {
                    
                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    
                }];
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
                PPHTTPManager * manager = [PPHTTPManager manager];
                [manager POST:kPPUrlDismissGroup parameters:input success:^(AFHTTPRequestOperation *operation, id responseObject) {
                    
                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    
                }];
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
#pragma mark user
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
        NSLog(@"userId==%@",userId);
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
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        PPHTTPManager * manager = [PPHTTPManager manager];
        [manager POST:kPPUrlProfile(friendId) parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
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
    
}

- (RACSignal *)sendSmsCode:(NSString *)phone region:(NSString *)region
{
    return [self.getVrificationCodeCommand execute:nil];
}

#pragma mark contactGroup

//创建群组成员
- (RACSignal *)createContactGroupName:(NSString *)name members:(NSArray<RCUserInfoData *> *)users
{
    
    RCContactGroupData * data = [RCContactGroupData new];
    data.creatorId = [PPTUserInfoEngine shareEngine].userId;
    data.name = name;
    data.memberCount = users.count;
    data.maxMemberCount = 500;
    data.memberList = users;
    
    return [self.createContactGroupCommand execute:data];
    
}
//删除群组的成员
- (RACSignal *)deleteMemberFormContactGroup:(NSString *)groudId members:(NSArray<NSString *> *)userIds
{
    
    NSMutableDictionary * parms = [NSMutableDictionary new];
    if([groudId isValid])
    {
        [parms setObject:groudId forKey:@"groupId"];
    }
    if(userIds)
    {
        [parms setObject:userIds forKey:@"memberIds"];
    }
    return  [self.kickMembersContactGroupCommand execute:parms];
}
//添加群组成员
- (RACSignal *)addMemberFormContactGroup:(NSString *)groupId members:(NSArray<NSString *> *)userIds
{
    NSMutableDictionary * params = [NSMutableDictionary new];
    if([groupId isValid])
    {
        [params setObject:groupId forKey:@"groupId"];
    }
    if(userIds)
    {
        [params setObject:userIds forKey:@"memberIds"];
    }
    return [self.addMembersContactGroupCommand execute:params];
}
//修改群姓名
- (RACSignal *)updateContactGroupName:(NSString *)groupName withGroupId:(NSString *)groupId
{
    NSMutableDictionary * params = [NSMutableDictionary new];
    if([groupId isValid])
    {
        [params setObject:groupId forKey:@"groupId"];
    }
    if([groupName isValid])
    {
        [params setObject:groupName forKey:@"name"];
    }
    return [self.modifyContactGroupNameCommand execute:params];
}
//退出群组
- (RACSignal *)leaveContactGroup:(NSString *)groupId
{
    
    NSDictionary *params = nil;
    if([groupId isValid])
    {
       params = @{ @"groupId" : groupId };
    }
    return  [self.leaveContactGroupCommand execute:params];
}
//解散群组
- (RACSignal *)dismissContactGroup:(NSString *)groupId
{
    NSDictionary *params = nil;
    if([groupId isValid])
    {
        params = @{ @"groupId" : groupId };
    }
   return [self.dismissContactGroupCommand execute:params];
}
//发布群公告
- (RACSignal *)submitContactGroupPublicService:(NSString *)groupId publicService:(NSString *)publicService
{
    
    return [self.contactGroupPublicServiceCommand execute:nil];
}
//修改群组的图片
- (RACSignal *)uploadContactGroupAvatarImage:(NSString *)groupId avatarImage:(UIImage *)avatarImage
{
    
    [[self getUploadImageToken]subscribeNext:^(NSString *   token) {
        
    }];
    return [self.uploadContactGroupAvatarImageCommand execute:nil];
   
}
- (RACSignal *)getContactGroupByGroupId:(NSString *)groupId
{
    RACSignal * signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        PPHTTPManager * manager = [PPHTTPManager manager];
        [manager GET:kPPUrlGetGroupId(groupId) parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"operation == %@",operation);
            NSError * error = nil;
            PPContactGroupSingleResponse * response = [MTLJSONAdapter modelOfClass:[PPContactGroupSingleResponse class] fromJSONDictionary:responseObject error:&error];
            [subscriber sendNext:response.result];
            [subscriber sendCompleted];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"operation == %@",operation);
        }];
        return nil;
    }];
    return signal;
}
- (RACSignal *)getContactGroupMembersByGroupId:(NSString *)groupId
{
    return [self.groupMembersCommand execute:groupId];
}

- (RACSignal *)getUploadImageToken
{
    return [self.uploadImageToken execute:nil];
}
- (RACSignal *)uploadAvatarImage:(UIImage *)avatarImage
{
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
         [[self.uploadImageToken execute:nil]subscribeNext:^(id  _Nullable x) {
          NSError * error;
          PPUploadFileResponse * response = [MTLJSONAdapter modelOfClass:[PPUploadFileResponse class] fromJSONDictionary:x error:&error];
             if(response.code.integerValue== kPPResponseSucessCode)
             {
                 PPUploadFileData * model = response.result;
                 if (model.upload_url.length > 0 && ![model.upload_url hasPrefix:@"http"]) {
                     model.upload_url = [NSString stringWithFormat:@"http://%@",model.upload_url];
                 }
                 //图片上传操作
                 [[self.uploadFileCommand execute:@{@"token":model.token,@"image":UIImageJPEGRepresentation(avatarImage, 0.4)}]subscribeNext:^(id  _Nullable x) {
                     NSString * key = [x objectForKey:@"key"];
                     NSString * avatarUrl = [NSString stringWithFormat:@"http://%@/%@",model.domain,key];
                     [[self.setAvatarUrlCommand execute:@{@"portraitUri":avatarUrl}]subscribeNext:^(id  _Nullable x) {
                         NSMutableDictionary * dict = [NSMutableDictionary dictionaryWithDictionary:x];
                         [dict setObject:avatarUrl forKey:@"result"];
                         [subscriber sendNext:dict];
                         [subscriber sendCompleted];
                     } error:^(NSError * _Nullable error) {
                         [subscriber sendError:error];
                         [subscriber sendCompleted];
                     }];
                 } error:^(NSError * _Nullable error) {
                     NSLog(@"error =%@",error);
                     [subscriber sendError:error];
                     [subscriber sendCompleted];
                 }];
             }
             else
             {
                 [subscriber sendError:error];
                 [subscriber sendCompleted];
             }
         }error:^(NSError * _Nullable error) {
             [subscriber sendError:error];
             [subscriber sendCompleted];
             
         } completed:^{
             
         }];
         return nil;
    }];
}
@end
