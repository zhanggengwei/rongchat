//
//  PPTUserInfoEngine.m
//  rongChatDemo1
//
//  Created by vd on 2016/11/14.
//  Copyright © 2016年 vd. All rights reserved.
//

#import "PPTUserInfoEngine.h"
#import "RCConversationCacheObj.h"

@interface PPTUserInfoEngine ()

@property (nonatomic,strong) PPUserBaseInfo * user_Info;
@property (nonatomic,strong) NSArray * contactList;
@property (nonatomic,copy) NSString * userId;
@property (nonatomic,strong) RACSignal * accountChangeSignal;
@end

@implementation PPTUserInfoEngine
+ (instancetype)shareEngine
{
    static dispatch_once_t token;
    static PPTUserInfoEngine * instance;
    dispatch_once(&token, ^{
        instance = [[self alloc]init];
        [instance loadData];
    });
    return instance;
}

- (instancetype)init
{
    if(self = [super init])
    {
        
    }
    return self;
}

- (void)loadUserInfo
{
    [[PPDateEngine manager]requestGetUserInfoResponse:^(PPLoginOrRegisterHTTPResponse * aTaskResponse) {
        PPUserBaseInfo * info = [PPUserBaseInfo new];
        info = aTaskResponse.result;
        [[PPTUserInfoEngine shareEngine]saveUserInfo:info];
    } userID:[SFHFKeychainUtils getPasswordForUsername:kPPUserInfoUserID andServiceName:kPPServiceName error:nil]];
}

- (void)loadData
{
    self.userId = [SFHFKeychainUtils getPasswordForUsername:kPPUserInfoUserID andServiceName:kPPServiceName error:nil];
    [RACObserve(self, userId) subscribeNext:^(id x){
        // 其他的一些设置
        if(x){
           [[PPTDBEngine shareManager]loadDataBase:x];
        }
    }];
    self.user_Info = [[PPTDBEngine shareManager]queryUser_Info];
}

- (NSArray *)contactList
{
    return [[PPTDBEngine shareManager]queryFriendList];
}
//保存自己的个人信息
- (BOOL)saveUserInfo:(PPUserBaseInfo *)baseInfo
{
    self.user_Info = baseInfo;
    BOOL ret = [[PPTDBEngine shareManager]saveUserInfo:baseInfo];
    self.userId = baseInfo.userId;
    return ret;
}

- (BOOL)saveUserFriendList:(NSArray<PPUserBaseInfo *> *)baseInfoArr
{
    __block NSArray * arr = [NSArray new];
    [baseInfoArr enumerateObjectsUsingBlock:^(PPUserBaseInfo * obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        NSString * name = obj.name;
        if([obj.displayName isEqualToString:@""])
        {
            name = obj.displayName;
        }
        arr = [arr arrayByAddingObject:obj];
    }];
    self.contactList = arr;
    return [[PPTDBEngine shareManager]saveContactList:baseInfoArr];
}
- (void)asynFriendList
{
    
    [[PPDateEngine manager]getFriendListResponse:^(PPUserFriendListResponse * aTaskResponse) {
        if(aTaskResponse.code.integerValue == kPPResponseSucessCode)
        {
            [self saveUserFriendList:aTaskResponse.result];
        }
        NSLog(@"aTaskResponse == %@",aTaskResponse);
    }];
}
- (RCUserInfo *)quertyUserInfoByUserId:(NSString *)userId
{
    return nil;
}
//登录成功后调用这个方法 进行个人数据信息的保存 请求
- (void)loginSucessed
{
    // 个人数据库文件的建立
    //登录成功后进行个人数据信息的请求
    //好友列表信息的请求
    //聊天会话的请求
    //黑名单数据的网络请求
    self.userId = [SFHFKeychainUtils getPasswordForUsername:kPPUserInfoUserID andServiceName:kPPServiceName error:nil];
    [[[PPDateEngine manager] getContactListCommandWithUserId:nil] subscribeNext:^(PPUserFriendListResponse *response) {
        NSMutableArray * data = [NSMutableArray new];
        [response.result enumerateObjectsUsingBlock:^(RCUserInfoData * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            PPUserBaseInfo * info = [PPUserBaseInfo new];
            info.message = obj.message;
            info.phone = obj.user.phone;
            info.region = obj.user.region;
            info.name = obj.user.name;
            info.portraitUri = obj.user.portraitUri;
            info.userId = obj.user.userId;
            NSLog(@"userid == %@",info.userId);
            info.displayName = obj.displayName;
            info.status = obj.status;
            info.updatedAt = obj.updatedAt;
            [data addObject:info];
        }];
        [[PPTDBEngine shareManager]saveContactList:data];
        
    }];
    [[[PPDateEngine manager]getContactGroupsCommand]subscribeNext:^(PPContactGroupListResponse * response) {
        [[PPTDBEngine shareManager]addOrUpdateContactGroupLists:response.result];
    } error:^(NSError * _Nullable error) {
        NSLog(@"error==%@",error);
    } completed:^{
        NSLog(@"finish==");
    }];
    [[[PPDateEngine manager]getUserInfoCommandByUserId:self.userId ]subscribeNext:^(PPUserBaseInfoResponse * response) {
        RCUserInfoBaseData * data = response.result;
        PPUserBaseInfo * info = [PPUserBaseInfo new];
        info.name = data.name;
        info.userId = data.userId;
        info.portraitUri = data.portraitUri;
        [[PPTDBEngine shareManager]saveUserInfo:info];
    } error:^(NSError * _Nullable error) {
        
    }];
    
    
}
- (void)logoutSucessed
{
    [[PPTDBEngine shareManager]clearAccount];
    _userId = nil;
    _user_Info = nil;
}


@end
