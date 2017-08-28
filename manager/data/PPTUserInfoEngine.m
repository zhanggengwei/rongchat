//
//  PPTUserInfoEngine.m
//  rongChatDemo1
//
//  Created by vd on 2016/11/14.
//  Copyright © 2016年 vd. All rights reserved.
//

#import "PPTUserInfoEngine.h"
#import "RCConversationCacheObj.h"
#import "PPFileManager.h"
#import "OTFileManager.h"

@interface PPTUserInfoEngine ()

@property (nonatomic,strong) RCUserInfoData * user_Info;
@property (nonatomic,strong) NSArray * contactList;
@property (nonatomic,copy) NSString * userId;
@property (nonatomic,strong) RACSignal * accountChangeSignal;
@property (nonatomic,copy) NSString * token;
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
        RCUserInfoData * info = [RCUserInfoData new];
        info.user = aTaskResponse.result;
        [[PPTUserInfoEngine shareEngine]saveUserInfo:info];
    } userID:[SFHFKeychainUtils getPasswordForUsername:kPPUserInfoUserID andServiceName:kPPServiceName error:nil]];
}

- (void)loadData
{
    self.userId = [SFHFKeychainUtils getPasswordForUsername:kPPUserInfoUserID andServiceName:kPPServiceName error:nil];
    self.token = [SFHFKeychainUtils getPasswordForUsername:kPPLoginToken andServiceName:kPPServiceName error:nil];
    [RACObserve(self,userId) subscribeNext:^(id x){
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
- (BOOL)saveUserInfo:(RCUserInfoData *)baseInfo
{
    self.user_Info = baseInfo;
    BOOL ret = [[PPTDBEngine shareManager]saveUserInfo:baseInfo];
    self.userId = baseInfo.user.userId;
    return ret;
}

- (BOOL)saveUserFriendList:(NSArray<RCUserInfoData *> *)baseInfoArr
{
    __block NSArray * arr = [NSArray new];
    [baseInfoArr enumerateObjectsUsingBlock:^(RCUserInfoData * obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        NSString * name = obj.user.name;
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
- (void)loginSucessed:(PPUserInfoTokenResponse *)response
{
    PPTokenDef * tokenDef = response.result;
    NSString * dbPath = [[PPFileManager sharedManager]pathForDomain:PPFileDirDomain_User appendPathName:tokenDef.indexId];
    //创建用户文件夹
    BOOL isDir;
    OTF_FileExistsAtPath(dbPath, &isDir);
    if (!isDir) {
        OTF_CreateDir(dbPath);
    }
    self.token = tokenDef.token;
    self.userId = tokenDef.indexId;
    [[PPDateEngine manager]connectRCIM];
    [self saveCustomMessage];
    [[[PPDateEngine manager] getContactListCommandWithUserId:nil] subscribeNext:^(PPUserFriendListResponse *response) {
        NSMutableArray * data = [NSMutableArray new];
        [response.result enumerateObjectsUsingBlock:^(RCUserInfoData * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [data addObject:obj];
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
        RCUserInfoData * data =[RCUserInfoData new];
        data.user = response.result;
        [[PPTDBEngine shareManager]saveUserInfo:data];
    } error:^(NSError * _Nullable error) {
        
    }];
    
    
}
- (void)logoutSucessed
{
    [[PPTDBEngine shareManager]clearAccount];
    [[RCIMClient sharedRCIMClient]logout];
    [SFHFKeychainUtils deleteItemForUsername:kPPLoginToken andServiceName:kPPServiceName error:nil];
    [SFHFKeychainUtils deleteItemForUsername:kPPUserInfoUserID andServiceName:kPPServiceName error:nil];
    _userId = nil;
    _user_Info = nil;
}
//登录成功之后进行数据的存储
- (void)saveCustomMessage
{
    NSError * error;
    [SFHFKeychainUtils storeUsername:kPPLoginToken andPassword:self.token forServiceName:kPPServiceName updateExisting:YES error:&error];
    [SFHFKeychainUtils storeUsername:kPPUserInfoUserID andPassword:self.userId forServiceName:kPPServiceName updateExisting:YES error:&error];
}

@end
