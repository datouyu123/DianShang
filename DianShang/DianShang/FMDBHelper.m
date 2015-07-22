//
//  FMDBHelper.m
//  DianShang
//
//  Created by 张伟颖 on 15/7/20.
//  Copyright © 2015年 XMUSoftware. All rights reserved.
//

#import "FMDBHelper.h"

@implementation FMDBHelper

/**
 *  单实例化数据库
 *
 *  @return <#return value description#>
 */
+ (instancetype)sharedFMDBHelper
{
    static FMDBHelper *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[FMDBHelper alloc] createAFMDatabase];
        [_sharedClient initDocPath];
        
        NSLog(@"单实例化数据库，如log出现2次这句话，则运行出现错误！\n");
    });
    return _sharedClient;
}

/**
 *   创建数据库
 *
 *  @return <#return value description#>
 */
- (FMDBHelper *)createAFMDatabase
{
    db = [FMDatabase databaseWithPath:database_path];
    
    return self;
    
}

/**
 *  初始化数据库路径
 *
 *  @return <#return value description#>
 */
- (void)initDocPath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documents = [paths objectAtIndex:0];
    database_path = [documents stringByAppendingPathComponent:DBNAME];
    
    db = [FMDatabase databaseWithPath:database_path];
}

/**
 *  新建表
 *
 *  @param dbName <#dbName description#>
 */
- (void)createTableByName:(NSString *) dbName
{
    if ([db open]) {
        if ([dbName isEqualToString:GOODS_TABLENAME]) {
            NSString *sqlCreateTable =  [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS '%@' ('%@' INTEGER PRIMARY KEY AUTOINCREMENT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT)" ,GOODS_TABLENAME ,GOODS_TID ,GOODS_POSTID ,GOODS_ORDERID ,GOODS_POSTURL ,GOODS_TAG ,GOODS_TITLE ,GOODS_COVERIMG ,GOODS_PRICE];
            
            if (! [db executeUpdate:sqlCreateTable] ) {
                NSLog(@"error when creating GOODS_TABLENAME table");
            }
            else {
                NSLog(@"success to creating GOODS_TABLENAME table");
            }
        }
        
    }
    [db close];
}

/**
 *  插入一条数据到GOODS_TABLE
 */
- (BOOL) insertIntoGOODS_TABLE:(NSString *) tID:(NSString *) postID:(NSString *) orderID:(NSString *) postURL:(NSString *) tag:(NSString *) title:(NSString *) postCoverImg:(NSString *) price
{
    if ([db open]) {
        NSString *insertSql= [NSString stringWithFormat:
                              @"INSERT INTO '%@' ('%@', '%@', '%@', '%@', '%@', '%@', '%@') VALUES ('%@', '%@', '%@', '%@', '%@', '%@', '%@')",
                              GOODS_TABLENAME, GOODS_POSTID, GOODS_ORDERID, GOODS_POSTURL, GOODS_TAG, GOODS_TITLE, GOODS_COVERIMG,GOODS_PRICE, postID, orderID, postURL, tag, title, postCoverImg, price];
        if ([db executeUpdate:insertSql]) {
            NSLog(@"success to insert a data");
            return true;
        }
        
        NSLog(@"sucess to open db but fail to insert a data");
        [db close];
        return false;

    }
    NSLog(@"fail to open db");
    return false;
}

/**
 *  表查询
 */
-(NSMutableArray *) selectFromGOODS_TABLE
{
    if ([db open]) {

        NSMutableArray *mutableGoods = [NSMutableArray arrayWithCapacity:50];
        NSString *selectSql = [NSString stringWithFormat:@"SELECT *FROM %@", GOODS_TABLENAME];
        
        FMResultSet *rs = [db executeQuery:selectSql];
        while ([rs next]) {
            int id = [rs intForColumn:GOODS_TID];
            NSString *postId = [rs stringForColumn:GOODS_POSTID];
            NSString *orderId = [rs stringForColumn:GOODS_ORDERID];
            NSString *postURL = [rs stringForColumn:GOODS_POSTURL];
            NSString *tag = [rs stringForColumn:GOODS_TAG];
            NSString *title = [rs stringForColumn:GOODS_TITLE];
            NSString *postCoverImg = [rs stringForColumn:GOODS_COVERIMG];
            NSString *price = [rs stringForColumn:GOODS_PRICE];
            
            NSLog(@"id=%d, postId=%@, orderId=%@, postURL=%@, tag=%@, title=%@, postCoverImg=%@, prive=%@",id, postId, orderId ,postURL, tag, title, postCoverImg, price);
        }
        [db close];
        return mutableGoods;
    }
    NSLog(@"fail to open db");
    return nil;
}
@end


