//
//  PPTUserInfoEngine.m
//  rongChatDemo1
//
//  Created by vd on 2016/11/14.
//  Copyright © 2016年 vd. All rights reserved.
//

#import "PPTUserInfoEngine.h"

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

- (void)loadData
{
    
    [[PPTDBEngine shareManager] loadDataBase:[SFHFKeychainUtils getPasswordForUsername:kPPUserInfoUserID andServiceName:kPPServiceName error:nil]];
    self.user_Info = [[PPTDBEngine shareManager]queryUser_Info];
    self.contactList = [[PPTDBEngine shareManager]queryFriendList];
    
    [self asynFriendList];
    
}

- (BOOL)saveUserInfo:(PPUserBaseInfo *)baseInfo
{
    self.user_Info = baseInfo;
    BOOL ret = [[PPTDBEngine shareManager]saveUserInfo:baseInfo];
    return ret;
}

- (BOOL)saveUserFriendList:(NSArray<PPUserBaseInfo *> *)baseInfoArr
{
    self.contactList = baseInfoArr;
    [[PPTDBEngine shareManager]saveContactList:baseInfoArr];
    
    return YES;
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

@end
