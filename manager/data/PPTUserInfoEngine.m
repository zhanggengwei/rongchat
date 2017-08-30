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

@property (nonatomic,copy) NSString * token;
@property (nonatomic,copy) NSString * userId;
//群组数据
@property (nonatomic,strong) NSArray<PPTContactGroupModel *> *contactGroupList;
@property (nonatomic,strong) NSArray<RCUserInfoData *> * contactBlackList;
@property (nonatomic,strong) NSArray<RCUserInfoData *> * contactRequestList;
@property (nonatomic,strong) NSArray<RCUserInfoData *> * contactList;
@property (nonatomic,strong) RCUserInfoData * user_Info;
@property (nonatomic,strong) RACSignal * accountChangeSignal;
@property (nonatomic,assign) NSInteger promptCount;

@end

@implementation PPTUserInfoEngine
+ (instancetype)shareEngine
{
    static dispatch_once_t token;
    static PPTUserInfoEngine * instance = nil;
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

- (void)loadUserInfoWithUserId:(NSString *)userId
{
    [[PPDateEngine manager]requestGetUserInfoResponse:^(PPLoginOrRegisterHTTPResponse * aTaskResponse) {
        RCUserInfoData * info = [RCUserInfoData new];
        info.user = aTaskResponse.result;
        [[PPTUserInfoEngine shareEngine]saveUserInfo:info];
    } userID:userId];
    
}

- (void)loadData
{
    self.userId = [SFHFKeychainUtils getPasswordForUsername:kPPUserInfoUserID andServiceName:kPPServiceName error:nil];
    self.token = [SFHFKeychainUtils getPasswordForUsername:kPPLoginToken andServiceName:kPPServiceName error:nil];
    @weakify(self);
    [RACObserve(self,userId) subscribeNext:^(id x){
        @strongify(self);
        // 其他的一些设置
        if(x){
            [[PPTDBEngine shareManager]loadDataBase:self.userId];
            self.user_Info = [[PPTDBEngine shareManager]queryUser_Info];
            self.contactGroupList = [[PPTDBEngine shareManager]contactGroupLists];
            self.contactList = [[PPTDBEngine shareManager]queryFriendList];
            self.contactRequestList = [[[[PPTDBEngine shareManager]queryContactRequestList] arrayByAddingObjectsFromArray:self.contactList] sortedArrayUsingSelector:@selector(compare:)];
            self.promptCount = [[PPTDBEngine shareManager]queryUnreadFriendCount];
        }
    }];
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
        dispatch_group_t group = dispatch_group_create();
        [response.result enumerateObjectsUsingBlock:^(RCUserInfoData * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [data addObject:obj];
            dispatch_group_enter(group);
            HanyuPinyinOutputFormat * outFormat = [HanyuPinyinOutputFormat new];
            outFormat.caseType = CaseTypeLowercase;
            outFormat.toneType =ToneTypeWithoutTone;
            outFormat.vCharType = VCharTypeWithUUnicode;
            [PinyinHelper toHanyuPinyinStringWithNSString:obj.user.name withHanyuPinyinOutputFormat:outFormat withNSString:@"" outputBlock:^(NSString *pinYin) {
                obj.user.nickNameWord = pinYin;
                char ch = [[[pinYin substringToIndex:1]uppercaseString]characterAtIndex:0];
                if(ch<'A'||ch>'Z')
                {
                    ch = '#';
                }
                obj.user.indexChar = [NSString stringWithFormat:@"%c",ch];
                dispatch_group_leave(group);
            }];
        }];
        dispatch_group_notify(group, dispatch_get_main_queue(), ^{
            [[PPTDBEngine shareManager]saveContactList:data];
            NSPredicate * predicate = [NSPredicate predicateWithFormat:@"self.status == %d",RCIMContactCustom];
            NSPredicate * requestPredicate = [NSPredicate predicateWithFormat:@"self.status == %d",RCIMContactRequestFriend];
            self.contactList = [data filteredArrayUsingPredicate:predicate];
            self.contactRequestList = [data filteredArrayUsingPredicate:requestPredicate];
            
        });
    }];
   
    [[[PPDateEngine manager]getContactGroupsCommand]subscribeNext:^(PPContactGroupListResponse * response) {
        [[PPTDBEngine shareManager]addOrUpdateContactGroupLists:response.result];
        self.contactGroupList = response.result;
    } error:^(NSError * _Nullable error) {
        NSLog(@"error==%@",error);
    } completed:^{
        NSLog(@"finish==");
    }];
    [[[PPDateEngine manager]getUserInfoCommandByUserId:self.userId ]subscribeNext:^(PPUserBaseInfoResponse * response) {
        RCUserInfoData * data =[RCUserInfoData new];
        data.user = response.result;
        [[PPTDBEngine shareManager]saveUserInfo:data];
        self.user_Info = data;
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

- (BOOL)addContactNotificationMessages:(NSArray<RCIMInviteMessage *>*)messages
{
    NSLog(@"message ==%@",messages);
    [messages enumerateObjectsUsingBlock:^(RCIMInviteMessage * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [[PPTUserInfoEngine shareEngine]loadUserInfoWithUserId:obj.sourceUserId];
    }];
    self.promptCount+=messages.count;
    return [[PPTDBEngine shareManager]addContactNotificationMessages:messages];
}
- (void)clearPromptCount
{
    self.promptCount = 0;
}
@end
