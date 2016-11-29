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
     [self createUser_Info_TableName];
        
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
    [self.db executeUpdate:dropSql];
//    [self.db  executeUpdate:dropSql];
    
}

- (BOOL)saveUserInfo:(PPUserBaseInfo *)baseInfo
{
    [self loadDataBase:baseInfo.user.indexId];
    if(baseInfo == nil)
    {
        return NO;
    }
    if ([_db open])
    {
        NSString *sql;
        
        BOOL ret = NO;
        @try
        {
            if ([self ifHaveRecordWithTable:USER_INFO_TABLENAME])
            {
                sql =  [NSString stringWithFormat:@"DELETE  FROM %@ where indexId = \'%@\'",USER_INFO_TABLENAME,baseInfo.user.indexId];
                ret = [_db executeUpdate:sql];
            
                if (NO == ret)
                {
                    [_db close];
                    return NO;
                }
            }
            sql = [NSString stringWithFormat:@"INSERT INTO %@ (indexId, nickname, displayName, portraitUri, updatedAt, phone, region, isSelf) VALUES (?, ?, ?, ?, ?, ?, ?, ?);",USER_INFO_TABLENAME];
            ret = [_db executeUpdate:sql,baseInfo.user.indexId, baseInfo.user.nickname,baseInfo.displayName, baseInfo.user.portraitUri,baseInfo.updatedAt, baseInfo.user.phone, baseInfo.user.region, [NSNumber numberWithBool:baseInfo.status]];
            
            if (NO == ret)
            {
                [_db close];
                return NO;
            }
        }
        @catch (NSException *exception)
        {
           
        }
        @finally
        {
            [_db close];
            
            return YES;
        }
    }
    return NO;
}

- (void)createUser_Info_TableName
{
    
    NSString * createUser_Info = [NSString stringWithFormat:@"create table  if not exists %@(indexId text  primary key not null,nickname text,displayName text,portraitUri text,updatedAt text,phone text,region text,isSelf bool)",USER_INFO_TABLENAME];
    

    BOOL createSucesss = [self.db executeUpdate:createUser_Info];
    if (createSucesss)
    {
        NSLog(@"创建成功");
    }else
    {
        NSLog(@"创建失败");
    }
    
    
    
}

- (void)saveFriendList:(NSArray <PPUserBaseInfo *> *)arr
{
    
}

#pragma mark - util method
- (BOOL)ifHaveRecordWithTable:(NSString *)table
{
    FMResultSet *resultSet = [_db executeQuery:[NSString stringWithFormat:@"select * from \'%@\';", table]];
    
    if ([resultSet next])
    {
        return YES;
    }
    return NO;
}

- (PPUserBaseInfo *)queryUser_Info
{
    NSString * userID = [SFHFKeychainUtils getPasswordForUsername:kPPUserInfoUserID andServiceName:kPPServiceName error:nil];
    [self loadDataBase:userID];
    
    
    PPUserBaseInfo * user_Info = [PPUserBaseInfo new];
    if([self.db open])
    {
        NSString * searchSql = [NSString stringWithFormat: @"select * from %@ where indexId= \'%@\'",USER_INFO_TABLENAME,userID];
        
        FMResultSet * result = [self.db executeQuery:searchSql];
        if(result == nil||(!result.next))
        {
            return nil;
        }
        NSString * indexID = [result stringForColumn:@"indexId"];
        NSString * nickName = [result stringForColumn:@"nickname"];
        NSString * displayName = [result stringForColumn:@"displayName"];
        NSString * portraitUrl = [result stringForColumn:@"portraitUri"];
        NSString * updatedAt = [result stringForColumn:@"updatedAt"];
        NSString * phone = [result stringForColumn:@"phone"];
        NSString * region = [result stringForColumn:@"region"];
        
        user_Info.displayName = displayName;
        user_Info.updatedAt = updatedAt;
        user_Info.user = [PPUserBase new];
        user_Info.user.nickname = nickName;
        user_Info.user.indexId = indexID;
        user_Info.user.phone = phone;
        user_Info.user.region = region;
        user_Info.user.portraitUri = portraitUrl;
    }
    
    return user_Info;
    
}


@end
