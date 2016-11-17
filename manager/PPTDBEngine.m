//
//  PPTDBEngine.m
//  rongChatDemo1
//
//  Created by vd on 2016/11/6.
//  Copyright © 2016年 vd. All rights reserved.
//

#define USER_INFO_TABLENAME @"USER_INFO_TABLENAME"

#import "PPTDBEngine.h"
#import "PPFileManager.h"
#import <FMDB/FMDB.h>
#import "OT/OTFileManager.h"

@interface PPTDBEngine ()

@property (nonatomic,strong) FMDatabase * db;

@end

@implementation PPTDBEngine
// 数据库的管理类

+ (instancetype)shareManager
{
    static dispatch_once_t token;
    static PPTDBEngine * shareInstance;
    
    dispatch_once(&token, ^{
        shareInstance = [self new];
        [[NSNotificationCenter defaultCenter]addObserver:shareInstance selector:@selector(loginSucess:) name:kPPObserverLoginSucess object:nil];
        
    
    });
    return shareInstance;
}

- (void)loginSucess:(NSNotification *)noti
{
    NSString * userID = [SFHFKeychainUtils getPasswordForUsername:kPPUserInfoUserID andServiceName:kPPServiceName error:nil];
    
    NSString * dbPath = [[PPFileManager sharedManager]pathForDomain:PPFileDirDomain_User appendPathName:userID];
    //创建用户文件夹
    BOOL isDir;
    OTF_FileExistsAtPath(dbPath, &isDir);
    if (!isDir) {
        OTF_CreateDir(dbPath);
    }
    [self loadDataBase:userID];
    
}

- (void)loadDataBase:(NSString *)userID
{
    
    NSString * dbPath = [[PPFileManager sharedManager]pathForDomain:PPFileDirDomain_User appendPathName:userID];
    dbPath = [dbPath stringByAppendingPathComponent:@"user.db"];
    
    NSFileManager *fm = [[NSFileManager alloc]init];
    BOOL isNewUser = ![fm fileExistsAtPath:dbPath];
    
    self.db = [FMDatabase databaseWithPath:dbPath];
    if(![self.db open])
    {
        [fm removeItemAtPath:dbPath error:nil];
        self.db = [FMDatabase databaseWithPath:dbPath];
        [self createTables];
    }
    else if(isNewUser)
    {
        [self createTables];
    }
    [self.db close];
    
}
- (void)createTables
{
    if([self queryTable:USER_INFO_TABLENAME]==NO)
    {
        [self createUser_Info_TableName];
        
    }
}
- (BOOL)queryTable:(NSString *)tableName
{
    
    NSString * selectSql = [NSString stringWithFormat:@"select * from \'%@\';",tableName];
    
    FMResultSet * result = [self.db executeQuery:selectSql];
   return  result.next;
}

- (void)dropTableName:(NSString *)tableName
{
    NSString * dropSql = [NSString stringWithFormat: @"truncate table \'%@\'",tableName];
    
    [self.db executeQuery:dropSql];
}

- (void)saveUserInfo:(PPUserBase *)baseInfo
{
    
}

- (void)createUser_Info_TableName
{
    
    NSString * createUser_Info = [NSString stringWithFormat:@"create table  if not exists %@(indexId text  primary key not null,nickname text,displayName text,portraitUri text,updatedAt text,phone text,region text,isSelf bool)",USER_INFO_TABLENAME];
    
    [self.db executeQuery:createUser_Info];
    
}

- (void)saveFriendList:(NSArray <PPUserBaseInfo *> *)arr
{
    
}


@end
