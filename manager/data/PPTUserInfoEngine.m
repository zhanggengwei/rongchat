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

- (void)loadUserInfo
{
    [[PPDateEngine manager]requestGetUserInfoResponse:^(PPLoginOrRegisterHTTPResponse * aTaskResponse) {
        
        PPUserBaseInfo * info = [PPUserBaseInfo new];
        info.user = aTaskResponse.result;
        [[PPTUserInfoEngine shareEngine]saveUserInfo:info];
    } userID:[SFHFKeychainUtils getPasswordForUsername:kPPUserInfoUserID andServiceName:kPPServiceName error:nil]];
}

- (void)loadData
{
    [[PPTDBEngine shareManager] loadDataBase:[SFHFKeychainUtils getPasswordForUsername:kPPUserInfoUserID andServiceName:kPPServiceName error:nil]];
    self.user_Info = [[PPTDBEngine shareManager]queryUser_Info];
//    self.contactList = [[PPTDBEngine shareManager]queryFriendList];
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
@end
