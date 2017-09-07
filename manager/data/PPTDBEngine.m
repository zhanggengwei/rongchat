//
//  PPTDBEngine.m
//  rongChatDemo1
//
//  Created by vd on 2016/11/6.
//  Copyright © 2016年 vd. All rights reserved.
//
// 成员信息表 好友信息，群成员信息
#define USER_INFO_TABLENAME @"USER_INFO_TABLENAME"

#define USER_INFO_BASE_TABLENAME @"USER_INFO_BASE_TABLENAME"

//群聊表
#define CONTACT_GRAOUP_TABLENAME @"CONTACT_GRAOUP_TABLENAME"
//群聊成员表
#define CONTACT_GRAOUP_MEMBER_TABLENAME @"CONTACT_GRAOUP_MEMBER_TABLENAME"
//好友表
#define USER_INFO_FRIENDLIST_TABLENAME @"USER_INFO_FRIENDLIST_TABLENAME"
//好友添加好友表
#define INVITE_USERINO_TABLE @"INVITE_USERINO_TABLE"


#import "PPTDBEngine.h"
#import "PPFileManager.h"
#import <FMDB/FMDB.h>
#import "OTFileManager.h"
#import <ReactiveObjC/ReactiveObjC.h>
#import "RCIMObjPinYinHelper.h"

@interface PPTDBEngine ()
@property (nonatomic,strong) FMDatabaseQueue * dataBaseQueue;
@property (nonatomic,strong) NSString * userId;
@end

@implementation PPTDBEngine
// 数据库的管理类

+ (instancetype)shareManager
{
    static dispatch_once_t token;
    static PPTDBEngine * shareInstance;
    dispatch_once(&token, ^{
        shareInstance = [self new];
    });
    return shareInstance;
}

- (void)loadDataBase:(NSString *)userID
{
    self.userId = userID;
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
    NSString * createUserInfoBaseSql = [NSString stringWithFormat:@"create table if not exists %@(userId text primary key not null,displayName text,updatedAt timestamp not null default current_timestamp,message varchar(100),FOREIGN KEY(userId) REFERENCES %@(userId))",USER_INFO_BASE_TABLENAME,USER_INFO_TABLENAME];
    NSString * createUserInfoSql = [NSString stringWithFormat:@"create table if not exists %@(userId text primary key not null,name text,portraitUri text,phone text,region text,nickNameWord varchar(100),indexChar varchar(1))",USER_INFO_TABLENAME];
    
    NSString * createContactGroupTableSql = [NSString stringWithFormat:@"create table if not exists %@ (name varchar(100) not null,bulletin text,creatorId varchar(100)not null,portraitUri varchar(100),indexId varchar(100) not null,maxMemberCount INT,memberCount INT,primary key(indexId))",CONTACT_GRAOUP_TABLENAME];
    NSString * createContactGroupMemberSql = [NSString stringWithFormat:@"create table if not exists %@ (indexId varchar (100)not null,userId varchar(100) not null,primary key(indexId,userId))",CONTACT_GRAOUP_MEMBER_TABLENAME];
    
    NSString * createFriendListSql = [NSString stringWithFormat:@"create table if not exists %@ (userId text not null,isBlack BOOL default 0,status INT default 0,primary key(userId))",USER_INFO_FRIENDLIST_TABLENAME];
    
    NSString * createInviteMessageSql = [NSString stringWithFormat:@"create table if not exists %@ (sourceUserId varchar(100) not null,targetUserId varchar(100) not null,message varchar(100),status INT,read BOOL,primary key(sourceUserId,targetUserId))",INVITE_USERINO_TABLE];
    [self.dataBaseQueue inTransaction:^(FMDatabase * _Nonnull db, BOOL * _Nonnull rollback) {
        [db executeUpdate:createUserInfoSql];
        [db executeUpdate:createUserInfoBaseSql];
        [db executeUpdate:createContactGroupTableSql];
        [db executeUpdate:createFriendListSql];
        [db executeUpdate:createContactGroupMemberSql];
        [db executeUpdate:createInviteMessageSql];
    }];
}
- (BOOL)saveUserInfo:(RCUserInfoData *)baseInfo
{
    return [self saveContactList:@[baseInfo]];
}
- (RCUserInfoData *)getUserInfo:(FMResultSet *)results
{
    
    RCUserInfoData * info = [RCUserInfoData new];
    info.user = [RCUserInfoBaseData new];
    info.user.name = [results stringForColumn:@"name"];
    info.user.userId = [results stringForColumn:@"userId"];
    info.displayName = [results stringForColumn:@"displayName"];
    info.user.phone = [results stringForColumn:@"phone"];
    info.user.region = [results stringForColumn:@"region"];
    info.user.portraitUri = [results stringForColumn:@"portraitUri"];
    info.user.nickNameWord = results[@"nickNameWord"];
    info.user.indexChar = results[@"indexChar"];
    info.status = [results intForColumn:@"status"];
    info.message = results[@"message"];
    info.updatedAt = results[@"updatedAt"];
    return info;
}

- (NSArray *)queryFriendList
{
    NSMutableArray * indexIds = [NSMutableArray new];
    NSMutableArray * contactList = [NSMutableArray new];
    NSString * searchSql = [NSString stringWithFormat:@"select * from \'%@\'",USER_INFO_FRIENDLIST_TABLENAME];
    [self.dataBaseQueue inTransaction:^(FMDatabase * _Nonnull db, BOOL * _Nonnull rollback) {
       
        FMResultSet * sets = [db executeQuery:searchSql];
        while (sets.next) {
            NSString * userId = [sets stringForColumn:@"userId"];
            [indexIds addObject:userId];
        }
        if(indexIds)
        {
            NSString * sql = [NSString stringWithFormat:@"select * from \'%@\'where userId in (\'%@\')",USER_INFO_TABLENAME,[indexIds componentsJoinedByString:@"','"]];
            FMResultSet * results = [db executeQuery:sql];
            while (results.next) {
                RCUserInfoData * info = [self getUserInfo:results];
                [contactList addObject:info];
            }
        }
        
    }];
    return contactList;
}
- (BOOL)updateUserInfo:(RCUserInfoData *)info
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
            PPTContactGroupModel * contactGroup = [PPTContactGroupModel new];
            contactGroup.group= [RCContactGroupData new];
            contactGroup.group.indexId = [results stringForColumn:@"indexId"];
            contactGroup.group.name = [results stringForColumn:@"name"];
            contactGroup.group.portraitUri = results[@"portraitUri"];
            contactGroup.group.creatorId = results[@"creatorId"];
            contactGroup.group.maxMemberCount = [results[@"maxMemberCount"] integerValue];
            contactGroup.group.memberCount = [results[@"memberCount"] integerValue];
            [contactGroups addObject:contactGroup];
        }
       
    }];
    return contactGroups;
    
}
- (BOOL)addOrUpdateContactGroup:(PPTContactGroupModel *)contactGroup
{
  return [self addOrUpdateContactGroupLists:@[contactGroup]];
}
//保存用户的好友列表
- (BOOL)saveContactList:(NSArray<RCUserInfoData *> *)contactList
{
    __block BOOL sucessed = NO;
    [_dataBaseQueue inTransaction:^(FMDatabase * _Nonnull db, BOOL * _Nonnull rollback) {
        [contactList enumerateObjectsUsingBlock:^(RCUserInfoData * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSString * deleteSql1  =[self deleteCustomUserInfoWithUser:obj.user.userId];
            NSString * deleteSql2 = [self deleteCustomUserBaseInfoWithUser:obj.user.userId];
            [db executeUpdate:deleteSql1];
            [db executeUpdate:deleteSql2];
            
            [[RCIMObjPinYinHelper converNameToPinyin:obj.user.name]subscribeNext:^(NSString * indexChar) {
                obj.user.indexChar = indexChar;
                [db executeUpdate:
                 @"insert into USER_INFO_BASE_TABLENAME (userId,displayName,updatedAt,message) values(?,?,?,?)",obj.user.userId,obj.displayName,obj.updatedAt,obj.message];
                NSString * insertSql = [NSString stringWithFormat: @"insert into %@(phone,region,name,userId,nickNameWord,indexChar,portraitUri) values (\'%@\',\'%@\',\'%@\',\'%@\',\'%@\',\'%@\',\'%@\')",USER_INFO_TABLENAME,obj.user.phone,obj.user.region,obj.user.name,obj.user.userId,obj.user.nickNameWord,obj.user.indexChar,obj.user.portraitUri];
                [db executeUpdate:insertSql];
                [db executeUpdate:[NSString stringWithFormat:@"insert into \'%@\' (userId,status) values (\'%@\',%ld)",USER_INFO_FRIENDLIST_TABLENAME,obj.user.userId,obj.status]];
                sucessed = !rollback;
                
            }];
        }];
    }];
    return sucessed;
}
- (BOOL)addOrUpdateContactGroupLists:(NSArray<PPTContactGroupModel *>*)contactGroupLists
{
    __block BOOL sucessed;
    [contactGroupLists enumerateObjectsUsingBlock:^(PPTContactGroupModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.dataBaseQueue inTransaction:^(FMDatabase * _Nonnull db, BOOL * _Nonnull rollback) {
            [self deleteContactGroupWithGroupId:obj.group.indexId dataBase:db];
            NSString * insertSql = [NSString stringWithFormat:@"insert into \'%@\'(name,creatorId,portraitUri,indexId,maxMemberCount,memberCount,bulletin) values(\'%@\',\'%@\',\'%@\',\'%@\',%ld,%ld,\'%@\')",CONTACT_GRAOUP_TABLENAME,obj.group.name,obj.group.creatorId,obj.group.portraitUri,obj.group.indexId,obj.group.maxMemberCount,obj.group.memberCount,obj.group.bulletin];
            [db executeUpdate:insertSql];
            sucessed = !rollback;
        }];
    }];
    return sucessed;
}




- (void)clearAccount
{
    [self.dataBaseQueue inTransaction:^(FMDatabase * _Nonnull db, BOOL * _Nonnull rollback) {
        [db executeUpdate:@"DELETE FROM USER_INFO_TABLENAME"];
        [db executeUpdate:@"DELETE FROM CONTACT_GRAOUP_TABLENAME"];
        [db executeUpdate:@"DELETE FROM CONTACT_GRAOUP_MEMBER_TABLENAME"];
        [db executeUpdate:@"DELETE FROM  USER_INFO_FRIENDLIST_TABLENAME"];
        [db executeUpdate:@"DELETE FROM  INVITE_USERINO_TABLE"];
        [db executeQuery:@"DELETE FROM  USER_INFO_BASE_TABLENAME"];
        
    }];
}
- (BOOL)addContactNotificationMessages:(NSArray<RCIMInviteMessage *>*)messages
{
    __block BOOL sucessed;
    [self.dataBaseQueue inTransaction:^(FMDatabase * _Nonnull db, BOOL * _Nonnull rollback) {
        [messages enumerateObjectsUsingBlock:^(RCIMInviteMessage * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//            NSString * deleteSql =
            [db executeUpdate:[NSString stringWithFormat: @"delete from \'%@\' where sourceUserId = \'%@\' and targetUserId = \'%@\'",INVITE_USERINO_TABLE,obj.sourceUserId,obj.targetUserId]];
            [db executeUpdate:[NSString stringWithFormat: @"insert into \'%@\' (sourceUserId,targetUserId,message,status,read) values(\'%@\',\'%@\',\'%@\',%ld,%d)",INVITE_USERINO_TABLE,obj.sourceUserId,obj.targetUserId,obj.message,obj.status,obj.read]];
            
        }];
        sucessed = !rollback;
    }];
    return sucessed;
}
- (NSInteger)queryUnreadFriendCount
{
    __block NSInteger count = 0;
    [self.dataBaseQueue inTransaction:^(FMDatabase * _Nonnull db, BOOL * _Nonnull rollback) {
        count =[db intForQuery:[NSString stringWithFormat:@"select count(*) from \'%@\'",INVITE_USERINO_TABLE]];
    }];
    return count;
}

#pragma makr 保存群组数据

- (BOOL)saveCustomContactGroupList:(NSArray< PPTContactGroupModel *>*)lists
{
    __block BOOL sucessed = NO;
    [self.dataBaseQueue inTransaction:^(FMDatabase * _Nonnull db, BOOL * _Nonnull rollback) {
        [lists enumerateObjectsUsingBlock:^(PPTContactGroupModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [self deleteContactGroup:obj];
            NSString * insertSql = [NSString stringWithFormat:@"insert into \'%@\'(name,creatorId,portraitUri,indexId,maxMemberCount,memberCount,bulletin) values(\'%@\',\'%@\',\'%@\',\'%@\',%ld,%ld,\'%@\')",CONTACT_GRAOUP_TABLENAME,obj.group.name,obj.group.creatorId,obj.group.portraitUri,obj.group.indexId,obj.group.maxMemberCount,obj.group.memberCount,obj.group.bulletin];
            [db executeUpdate:insertSql];
        }];
        sucessed = !rollback;
    }];
    return sucessed;
}
#pragma mark 删除群组数据
- (BOOL)deleteContactGroup:(PPTContactGroupModel *)model
{
    NSString * deleteSql = [NSString stringWithFormat:@"delete  from \'%@\' where indexId = \'%@\'",CONTACT_GRAOUP_TABLENAME,model.group.indexId];
    NSString * deleteMemberSql = [NSString stringWithFormat:@"delete  from \'%@\' where indexId = \'%@\'",CONTACT_GRAOUP_MEMBER_TABLENAME,model.group.indexId];
    __block BOOL sucessed;
    [self.dataBaseQueue inTransaction:^(FMDatabase * _Nonnull db, BOOL * _Nonnull rollback) {
        [db executeUpdate:deleteSql];
        [db executeUpdate:deleteMemberSql];
        sucessed = !rollback;
    }];
    return sucessed;
}

- (BOOL)saveCustomContactGroupMembers:(NSArray<RCUserInfoData *> *)userInfoList withGroupId:(NSString *)groupId
{
    __block BOOL sucessed = NO;
    [self.dataBaseQueue inTransaction:^(FMDatabase * _Nonnull db, BOOL * _Nonnull rollback) {
        [db executeUpdateWithFormat:@"DELETE FROM \'%@\' WHERE indexId = \'%@\'",CONTACT_GRAOUP_TABLENAME,groupId] ;
        [userInfoList enumerateObjectsUsingBlock:^(RCUserInfoData * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
        {
            [self saveCustomUserInfoList:@[obj]];
            [db executeUpdateWithFormat:@"insert into \'%@\'(indexId,userId) values(\'%@\',\'%@\')",CONTACT_GRAOUP_MEMBER_TABLENAME,groupId,obj.user.userId] ;
        }];
    }];
    return sucessed;
}


#pragma mark 将个人信息存储到 USER_INFO_TABLENAME
- (BOOL)saveCustomUserInfoList:(NSArray<RCUserInfoData *> *)list
{
    __block BOOL sucessed = false;
    [self.dataBaseQueue inTransaction:^(FMDatabase * _Nonnull db, BOOL * _Nonnull rollback) {
        [list enumerateObjectsUsingBlock:^(RCUserInfoData * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [self deleteCustomUserInfo:obj];
            NSString * insertSql = [NSString stringWithFormat: @"insert into %@(phone,message,region,name,displayName,updatedAt,userId,nickNameWord,indexChar,portraitUri) values (\'%@\',\'%@\',\'%@\',\'%@\',\'%@\',\'%@\',\'%@\',\'%@\',\'%@\',\'%@\')",USER_INFO_TABLENAME,obj.user.phone,obj.message,obj.user.region,obj.user.name,obj.displayName,obj.updatedAt,obj.user.userId,obj.user.nickNameWord,obj.user.indexChar,obj.user.portraitUri];
            [db executeUpdate:insertSql];
        }];
    }];
    return sucessed;
}

- (NSString *)deleteCustomUserInfo:(RCUserInfoData *)data
{
    return  [NSString stringWithFormat:@"DELETE FROM \'%@\' WHERE userId = \'%@\'",USER_INFO_TABLENAME,data.user.userId];
}
- (NSString *)deleteCustomUserInfoWithUser:(NSString *)userId
{
   return  [NSString stringWithFormat:@"DELETE FROM \'%@\' where userId = \'%@\'",USER_INFO_TABLENAME,userId];
}

- (NSString *)deleteCustomUserBaseInfoWithUser:(NSString *)userId
{
     return [NSString stringWithFormat:@"DELETE FROM \'%@\' where userId = \'%@\'",USER_INFO_BASE_TABLENAME,userId];
}

- (void)deleteContactGroupWithGroupId:(NSString *)groupId dataBase:(FMDatabase *)db
{
    NSString * deleteSql = [NSString stringWithFormat:@"delete  from \'%@\' where indexId = \'%@\'",CONTACT_GRAOUP_TABLENAME,groupId];
    NSString * deleteMemberSql = [NSString stringWithFormat:@"delete  from \'%@\' where indexId = \'%@\'",CONTACT_GRAOUP_MEMBER_TABLENAME,groupId];
    [db executeUpdate:deleteSql];
    [db executeUpdate:deleteMemberSql];
    
}


@end
