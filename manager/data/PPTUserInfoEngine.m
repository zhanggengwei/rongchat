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
        self.userId = [SFHFKeychainUtils getPasswordForUsername:kPPUserInfoUserID andServiceName:kPPServiceName error:nil];
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
    [RACObserve(self, userId) subscribeNext:^(id x) {
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

- (BOOL)saveUserInfo:(PPUserBaseInfo *)baseInfo
{
    self.user_Info = baseInfo;
    BOOL ret = [[PPTDBEngine shareManager]saveUserInfo:baseInfo];
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
@end
