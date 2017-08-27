//
//  PPTDBEngine.m
//  rongChatDemo1
//
//  Created by vd on 2016/11/6.
//  Copyright © 2016年 vd. All rights reserved.
//
// 成员信息表 好友信息，群成员信息
#define USER_INFO_TABLENAME @"USER_INFO_TABLENAME"
#define CONTACT_GRAOUP_TABLENAME @"CONTACT_GRAOUP_TABLENAME"
//好友信息表
#define USER_INFO_FRIENDLIST_TABLENAME @"USER_INFO_FRIENDLIST_TABLENAME"


#import "PPTDBEngine.h"
#import "PPFileManager.h"
#import <FMDB/FMDB.h>
#import "OTFileManager.h"
#import <ReactiveObjC/ReactiveObjC.h>
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
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"test.sqlite"];
    
    // 2、创建队列
    self.dataBaseQueue = [FMDatabaseQueue databaseQueueWithPath:path];
    NSString * dbPath = [[PPFileManager sharedManager]pathForDomain:PPFileDirDomain_User appendPathName:userID];
    dbPath = [dbPath stringByAppendingPathComponent:@"user.sqlite"];
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
    NSString * createUserInfoSql = [NSString stringWithFormat:@"create table if not exists %@(userId text primary key not null,name text,displayName text,portraitUri text,updatedAt text,phone text,region text,message varchar(100),status INT)",USER_INFO_TABLENAME];
    //isContact 是否是好友信息
    NSString * createContactGroupTableSql = [NSString stringWithFormat:@"create table if not exists %@ (name varchar(100),url varchar(100),groupId varchar(100) not null,userId varchar(100),primary key(groupid,userId))",CONTACT_GRAOUP_TABLENAME];
    NSString * createFriendListSql = [NSString stringWithFormat:@"create table if not exists %@ (userId text not null,isBlack BOOL,primary key(userId))",USER_INFO_FRIENDLIST_TABLENAME];
    [self.dataBaseQueue inTransaction:^(FMDatabase * _Nonnull db, BOOL * _Nonnull rollback) {
        [db executeUpdate:createUserInfoSql];
        [db executeUpdate:createContactGroupTableSql];
        [db executeUpdate:createFriendListSql];
    }];
}
- (BOOL)saveUserInfo:(PPUserBaseInfo *)baseInfo
{
    return [self saveContactList:@[baseInfo]];
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
- (BOOL)addOrUpdateContactGroup:(RCContactGroup *)contactGroup
{
  return [self addOrUpdateContactGroupLists:@[contactGroup]];
}
//保存用户的好友列表
- (BOOL)saveContactList:(NSArray<PPUserBaseInfo *> *)contactList
{
    __block BOOL sucessed = NO;
    [_dataBaseQueue inTransaction:^(FMDatabase * _Nonnull db, BOOL * _Nonnull rollback) {
        [contactList enumerateObjectsUsingBlock:^(PPUserBaseInfo * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSString * insertSql = [NSString stringWithFormat: @"insert into %@(phone,message,region,name,displayName,updatedAt,status,userId) values (\'%@\',\'%@\',\'%@\',\'%@\',\'%@\',\'%@\',%ld,\'%@\')",USER_INFO_TABLENAME,obj.phone,obj.message,obj.region,obj.name,obj.displayName,obj.updatedAt,obj.status,obj.userId];
            [db executeUpdate:insertSql];
            [db executeUpdate:[NSString stringWithFormat:@"insert into \'%@\' (userId) values (\'%@\')",USER_INFO_FRIENDLIST_TABLENAME,obj.userId]];
            
            sucessed = !rollback;
        }];
    }];
    return sucessed;
}
- (BOOL)addOrUpdateContactGroupLists:(NSArray<RCContactGroup *>*)contactGroupLists
{
    __block BOOL sucessed;
    [contactGroupLists enumerateObjectsUsingBlock:^(RCContactGroup * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        //删除数据
        NSString * deleteSql = [NSString stringWithFormat:@"delete * from %@ where groupId = %@",CONTACT_GRAOUP_TABLENAME,obj.groupId];
        NSString * deleteMemberSql = [NSString stringWithFormat:@"delete * from %@ where groupId = %@",CONTACT_GRAOUP_TABLENAME,obj.groupId];
        [self.dataBaseQueue inTransaction:^(FMDatabase * _Nonnull db, BOOL * _Nonnull rollback) {
            [db executeUpdate:deleteSql];
            [db executeUpdate:deleteMemberSql];
            [obj.members enumerateObjectsUsingBlock:^(PPUserBaseInfo * _Nonnull info, NSUInteger idx, BOOL * _Nonnull stop) {
               NSString * insertSql = [NSString stringWithFormat:@"insert into %@ (name,groupId,portraitUri,userId) values (\'%@\',\'%@\',\'%@\',\'%@\')",CONTACT_GRAOUP_TABLENAME,obj.name,obj.groupId,obj.portraitUri,info.userId];
                   [db executeUpdate:insertSql];
            }];
            [self saveContactList:obj.members];
            sucessed = !rollback;
        }];
    }];
    return sucessed;
}


@end
