//
//  FMDBHelper.m
//  DianShang
//
//  Created by 张伟颖 on 15/7/20.
//  Copyright © 2015年 XMUSoftware. All rights reserved.
//

#import "FMDBHelper.h"
#import "Post.h"
#import "Good.h"

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
- (void)createTableByName:(NSString *)dbName
{
    if ([db open]) {
        if ([dbName isEqualToString:GOODS_TABLENAME]) {
            NSString *sqlCreateTable =  [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS '%@' ('%@' INTEGER PRIMARY KEY AUTOINCREMENT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT)" ,GOODS_TABLENAME ,GOODS_TID ,GOODS_POSTID ,GOODS_ORDERID ,GOODS_POSTURL ,GOODS_TAG ,GOODS_TITLE ,GOODS_COVERIMG ,GOODS_PRICE, GOODS_TYPE];
            
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
- (BOOL) insertIntoGOODS_TABLE:(NSString *)tID postID:(NSString *)postID orderID:(NSString *)orderID postURL:(NSString *)postURL tag:(NSString *)tag title:(NSString *)title postCoverImg:(NSString *)postCoverImg price:(NSString *) price type:(NSString *) type
{
    if ([db open]) {
        NSString *insertSql=[NSString stringWithFormat:@"INSERT INTO '%@' ('%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@') VALUES ('%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@')",GOODS_TABLENAME, GOODS_POSTID, GOODS_ORDERID, GOODS_POSTURL, GOODS_TAG, GOODS_TITLE, GOODS_COVERIMG,GOODS_PRICE,GOODS_TYPE, postID, orderID, postURL, tag, title, postCoverImg, price, type];
        
        if ([db executeUpdate:insertSql]) {
            NSLog(@"success to insert a data");
            return true;
        }
        
        NSLog(@"sucess to open db but fail to insert a data");
        [db close];
        return false;

    }
    NSLog(@"fail to open db in insertIntoGOODS_TABLE");
    return false;
}

//下面是 数组 的插入操作

-(BOOL) insertIntoGOODS_TABLEWithArray:(NSMutableArray *) mutablePosts{
    
    for (Post *post in mutablePosts) {
        
        if (post != nil) {
            
            NSLog(@"插入-postID: %@, URL:%@, title:%@, coverimg:%@, type:%@", [NSString stringWithFormat:@"%lu",(unsigned long)post.postID], post.good.goodURL, post.good.goodTitle, post.good.coverImageURL, post.goodType);
            
            
            [self insertIntoGOODS_TABLE:@"0" postID:[NSString stringWithFormat:@"%lu",(unsigned long)post.postID ] orderID:@"1" postURL:post.good.goodURL tag:@"电商" title:post.good.goodTitle postCoverImg:post.good.goodCoverImgString price:@"10" type:post.goodType];
        }
        
        
    }
    
    return true;
    
}

/**
 *  表查询 GOODS_TABLE
 */
-(NSMutableArray *) selectFromGOODS_TABLE: (NSString*)type
{
    if ([db open]) {

        NSMutableArray *mutableGoods = [NSMutableArray arrayWithCapacity:50];
        NSString *selectSql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@=%@", GOODS_TABLENAME, GOODS_TYPE, type];
        
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
            NSString *type = [rs stringForColumn:GOODS_TYPE];
            
            NSLog(@"id=%d, postId=%@, orderId=%@, postURL=%@, tag=%@, title=%@, postCoverImg=%@, price=%@ type=%@",id, postId, orderId ,postURL, tag, title, postCoverImg, price, type);
            
            Post *p = [[Post alloc] initWithAttributes: [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d", id] ,@"tid",title,@"title",postCoverImg,@"coverimg",price,@"price",tag,@"tag",postURL,@"url",type,@"type", nil] ];
            [mutableGoods addObject:p];

        }
        [db close];
        return mutableGoods;
    }
    NSLog(@"fail to open db in selectFromGOODS_TABLE");
    return nil;
}

/**
 *  清空数据库
 */

-(BOOL) emptyDatabaseByName:(NSString *)dbName
{
    if ([db open]) {
        if ([dbName isEqualToString:GOODS_TABLENAME]) {
            NSString *sqlDeleteTable = [NSString stringWithFormat:@"DELETE FROM %@", GOODS_TABLENAME];
            
            if (![db executeUpdate:sqlDeleteTable]) {
                NSLog(@"fail to delete GOODS_TABLE");
            }
            else
                NSLog(@"success to delete GOODS_TABLE");
        }
        [db close];
        return true;
    }
    NSLog(@"fail to open db in emptyDatebaseByName");
    return false;
}
@end


