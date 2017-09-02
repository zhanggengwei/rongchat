//
//  PPTUserInfoEngine.m
//  rongChatDemo1
//
//  Created by vd on 2016/11/14.
//  Copyright © 2016年 vd. All rights reserved.
//

#import "PPTUserInfoEngine.h"
#import "PPFileManager.h"
#import "OTFileManager.h"
#import "NSDate+RCIMDateTools.h"


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

- (void)loadUserInfoWithInviteMessage:(RCIMInviteMessage *)message
{
    [[[PPDateEngine manager]getUserInfoCommandByUserId:message.sourceUserId]subscribeNext:^(PPUserBaseInfoResponse * response) {
        if(response.code.integerValue== 200)
        {
            RCUserInfoData * data =[RCUserInfoData new];
            NSString * updateAt = [message.date lcck_formattedDateWithFormat:@"yyyy-MM-dd HH:mm:ss"];
            data.message = message.message;
            data.updatedAt = updateAt;
            data.status = message.status;
            data.user = response.result;
            if (data.status==RCIMContactCustom) {
                self.contactList = [self.contactList arrayByAddingObject:data];
            }else{
                self.contactRequestList = [self.contactRequestList arrayByAddingObject:data];
            }
            [[PPTDBEngine shareManager]saveUserInfo:data];
        }
    } error:^(NSError * _Nullable error) {
        
    }];
    
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
            
            NSArray<RCUserInfoData *> * data = [[PPTDBEngine shareManager]queryFriendList];
            self.user_Info = [data filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"self.user.userId = %@",self.userId]].firstObject;
            self.contactGroupList = [[PPTDBEngine shareManager]contactGroupLists];
            self.contactList = [data filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"self.status = %d",RCIMContactCustom]];
            self.contactRequestList = [[data filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"self.status = %d",RCIMContactRequestFriend]]sortedArrayUsingSelector:@selector(compare:)];
            self.promptCount = [[PPTDBEngine shareManager]queryUnreadFriendCount];
        }
    }];
}

//保存自己的个人信息
- (BOOL)saveUserInfo:(RCUserInfoData *)baseInfo
{
    self.user_Info = baseInfo;
    self.userId = baseInfo.user.userId;
    BOOL ret = [[PPTDBEngine shareManager]saveUserInfo:baseInfo];
    return ret;
}

- (BOOL)appendFrinedUserInfo:(RCUserInfoData *)baseInfo
{
    BOOL ret = [[PPTDBEngine shareManager]saveUserInfo:baseInfo];
    self.contactRequestList = [self.contactRequestList arrayByAddingObject:baseInfo];
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
            self.contactRequestList = [[data filteredArrayUsingPredicate:requestPredicate]sortedArrayUsingSelector:@selector(compare:)];
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
    [messages enumerateObjectsUsingBlock:^(RCIMInviteMessage * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [[PPTUserInfoEngine shareEngine]loadUserInfoWithInviteMessage:obj];
    }];
    self.promptCount+=messages.count;
    return [[PPTDBEngine shareManager]addContactNotificationMessages:messages];
}
- (void)clearPromptCount
{
    
    self.promptCount = 0;
}
- (void)queryUserInfoWithUserId:(NSString *)uid resultCallback:(RCIMUserInfoResultBlock)block
{
    
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"self.user.userId = %@",uid];
    RCUserInfoData * userData = [self.contactList filteredArrayUsingPredicate:predicate].firstObject;
    if(!userData)
    {
        userData = [self.contactRequestList filteredArrayUsingPredicate:predicate].firstObject;
    }
    if(!userData)
    {
        userData = [self.contactBlackList filteredArrayUsingPredicate:predicate].firstObject;
    }
    if(userData==nil)
    {
        [[[PPDateEngine manager]getUserInfoCommandByUserId:self.userId ]subscribeNext:^(PPUserBaseInfoResponse * response) {
            RCUserInfoData * data =[RCUserInfoData new];
            data.user = response.result;
            if(block)
            {
                block(data);
            }
        } error:^(NSError * _Nullable error) {
            
        }];
    }else
    {
        if(block)
        {
            block(userData);
        }
    }
}
@end
