//
//  PPTDBEngine.m
//  rongChatDemo1
//
//  Created by vd on 2016/11/6.
//  Copyright © 2016年 vd. All rights reserved.
//

#define USER_INFO_TABLENAME @"USER_INFO_TABLENAME"
#define CONTACT_GRAOUP_MEMBER_TABLENAME @"CONTACT_GRAOUP_MEMBER_TABLENAME"
#define CONTACT_GRAOUP_TABLENAME @"CONTACT_GRAOUP_TABLENAME"
#define USER_BASE_TABLENAME @"USER_BASE_TABLENAME"
#import "PPTDBEngine.h"
#import "PPFileManager.h"
#import <FMDB/FMDB.h>
#import "OTFileManager.h"

@interface PPTDBEngine ()
@property (nonatomic,strong) FMDatabaseQueue * dataBaseQueue;
@end

@implementation PPTDBEngine
// 数据库的管理类

+ (instancetype)shareManager
{
    static dispatch_once_t token;
    static PPTDBEngine * shareInstance;
    dispatch_once(&token, ^{
        shareInstance = [self new];
        [[NSNotificationCenter defaultCenter]addObserver:shareInstance selector:@selector(logoutSucess:) name:kPPObserverLogoutSucess object:nil];
        
    });
    return shareInstance;
}
- (instancetype)init
{
    if((self = [super init]))
    {
    }
    return self;
}
- (void)logoutSucess:(NSNotification *)noti
{
  
}

- (void)loadDataBase:(NSString *)userID
{
    NSString * dbPath = [[PPFileManager sharedManager]pathForDomain:PPFileDirDomain_User appendPathName:userID];
    dbPath = [dbPath stringByAppendingPathComponent:@"user.db"];
    
    NSFileManager *fm = [[NSFileManager alloc]init];
    BOOL isNewUser = ![fm fileExistsAtPath:dbPath];
    self.dataBaseQueue = [FMDatabaseQueue databaseQueueWithPath:dbPath];
    if(isNewUser)
    {
        [self createTables];
    }
}
- (void)createTables
{
    NSString * createUserInfoSql = [NSString stringWithFormat:@"create table if not exists %@(userId text primary key not null,name text,displayName text,portraitUri text,updatedAt text,phone text,region text,message varchar(100),isBlack BOOL,status INT)",USER_INFO_TABLENAME];
    NSString * createContactGroupTableSql = [NSString stringWithFormat:@"create table if not exists %@ (name varchar(100),url varchar(100),groupId varchar(100) not null,primary key(groupid))",CONTACT_GRAOUP_TABLENAME];
    NSString * createContactGroupMemberTableSql = [NSString stringWithFormat:@"create table if not exists %@(name varchar(100),userId varchar(100) not null,groupId varchar(100) not null,portraitUri varchar(100),primary key(userId,groupId))",CONTACT_GRAOUP_MEMBER_TABLENAME];
    NSString * createBaseSql = [NSString stringWithFormat:@"create table if not exists %@(displayName varchar(100),message varchar(100),status int,updatedAt varchar(100),userId varchar(30),primary key(userId))",USER_BASE_TABLENAME];
    [self.dataBaseQueue inTransaction:^(FMDatabase * _Nonnull db, BOOL * _Nonnull rollback) {
        [db executeUpdate:createBaseSql];
        [db executeUpdate:createUserInfoSql];
        [db executeUpdate:createContactGroupTableSql];
        [db executeUpdate:createContactGroupMemberTableSql];
    }];
}
- (BOOL)saveUserInfo:(PPUserBaseInfo *)baseInfo
{

    NSString * updateSql = [NSString stringWithFormat:@"update %@ set displayName = %@,message = %@,status = %ld,updatedAt = %@ where userId = %@",USER_BASE_TABLENAME,baseInfo.displayName,baseInfo.message,baseInfo.status,baseInfo.updatedAt, baseInfo.userId];
    NSString * insertSql = @"insert into %@ (phone,region,userId,isBlack,name,portraitUri) values(%@,%@,%@,%@,%@)";
    return NO;
}


- (PPUserBaseInfo *)queryUser_Info
{
    NSString * userID = [SFHFKeychainUtils getPasswordForUsername:kPPUserInfoUserID andServiceName:kPPServiceName error:nil];
    return [self queryUser_InfoWithIndexId:userID];
}
- (PPUserBaseInfo *)queryUser_InfoWithIndexId:(NSString *)indexId
{
    return nil;
}

- (NSArray *)queryFriendList
{
    NSMutableArray * contactlist = [NSMutableArray new];
    return contactlist;
}

- (BOOL)updateUserInfo:(PPUserBaseInfo *)info
{
    
    return NO;
}
- (NSArray *)contactGroupLists
{
    NSMutableArray * contactGroups = [NSMutableArray new];
    NSString * sql = [NSString stringWithFormat: @"select * from %@",CONTACT_GRAOUP_TABLENAME];
    [self.dataBaseQueue inTransaction:^(FMDatabase * _Nonnull db, BOOL * _Nonnull rollback) {
        FMResultSet * results = [db executeQuery:sql];
        while (results.next) {
            RCContactGroup * contactGroup = [RCContactGroup new];
            contactGroup.groupId = [results stringForColumn:@"groupId"];
            contactGroup.name = [results stringForColumn:@"name"];
            contactGroup.portraitUri = results[@"portraitUri"];
            [contactGroups addObject:contactGroup];
        }
    }];
    return contactGroups;
    
}
- (void)addOrUpdateContactGroup:(RCContactGroup *)contactGroup
{
    //删除数据
    NSString * deleteSql = [NSString stringWithFormat:@"delete * from %@ where groupId = %@",CONTACT_GRAOUP_TABLENAME,contactGroup.groupId];
    NSString * deleteMemberSql = [NSString stringWithFormat:@"delete from %@ where groupId = %@",CONTACT_GRAOUP_MEMBER_TABLENAME,contactGroup.groupId];
    NSString * insertSql = [NSString stringWithFormat:@"insert into %@ (name,groupId,portraitUri) values (%@,%@,%@)",CONTACT_GRAOUP_TABLENAME,contactGroup.name,contactGroup.groupId,contactGroup.portraitUri];
    [self.dataBaseQueue inTransaction:^(FMDatabase * _Nonnull db, BOOL * _Nonnull rollback) {
        [db executeUpdate:deleteSql];
        [db executeUpdate:deleteMemberSql];
        [db executeUpdate:insertSql];
        [contactGroup.members enumerateObjectsUsingBlock:^(RCContactGroupMember * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSString * inserMembesSql = @"insert into %@ (groupId,name,)";
        }];
        
    }];
}
//保存用户的好友列表
- (BOOL)saveContactList:(NSArray <PPUserBaseInfo *> *)contactList
{
    __block BOOL sucessed = NO;
    [_dataBaseQueue inTransaction:^(FMDatabase * _Nonnull db, BOOL * _Nonnull rollback) {
        [contactList enumerateObjectsUsingBlock:^(PPUserBaseInfo * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSString * insertSql = [NSString stringWithFormat: @"insert into %@(phone,message,region,name,displayName,updatedAt,isBlack,status,userId) values (\'%@\',\'%@\',\'%@\',\'%@\',\'%@\',\'%@\',%ld,%ld,\'%@\')",USER_INFO_TABLENAME,obj.phone,obj.message,obj.region,obj.name,obj.displayName,obj.updatedAt,obj.isBlack,obj.status,obj.userId];
            [db executeUpdate:insertSql];
            sucessed = !rollback;
        }];
    }];
    return sucessed;
}
- (void)addOrUpdateContactGroupLists:(NSArray<RCContactGroup *>*)contactGroupLists
{
    
}
@end
