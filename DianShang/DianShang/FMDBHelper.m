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
    NSLog(@"%@",paths);
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
        else if ([dbName isEqualToString:SHOPPING_CART_TABLENAME]) {
            NSString *sqlCreateTable =  [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS '%@' ('%@' INTEGER PRIMARY KEY AUTOINCREMENT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT)" ,SHOPPING_CART_TABLENAME ,GOODS_TID ,GOODS_POSTID ,GOODS_ORDERID ,GOODS_POSTURL ,GOODS_TAG ,GOODS_TITLE ,GOODS_COVERIMG ,GOODS_PRICE, GOODS_TYPE, CART_NUMBER, GOODS_DETAILCOVERIMAGES, CART_SELECTED_STATE];
            
            if (! [db executeUpdate:sqlCreateTable] ) {
                NSLog(@"error when creating SHOPPING_CART_TABLENAME table");
            }
            else {
                NSLog(@"success to creating SHOPPING_CART_TABLENAME table");
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

/**
 *  插入一条数据到SHOPPING_CART_TABLE
 */
- (BOOL) insertIntoSHOPPING_CART_TABLE:(NSString *)tID postID:(NSString *)postID orderID:(NSString *)orderID postURL:(NSString *)postURL tag:(NSString *)tag title:(NSString *)title postCoverImg:(NSString *)postCoverImg price:(NSString *) price type:(NSString *) type number:(NSString *)number detailCoverImages:(NSString *)detailCoverImages cartSelectedState:(NSString *)cartSelectedState
{
    if ([db open]) {
        NSString *insertSql=[NSString stringWithFormat:@"INSERT INTO '%@' ('%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@') VALUES ('%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@')",SHOPPING_CART_TABLENAME, GOODS_POSTID, GOODS_ORDERID, GOODS_POSTURL, GOODS_TAG, GOODS_TITLE, GOODS_COVERIMG,GOODS_PRICE,GOODS_TYPE, CART_NUMBER, GOODS_DETAILCOVERIMAGES, CART_SELECTED_STATE, postID, orderID, postURL, tag, title, postCoverImg, price, type, number, detailCoverImages, cartSelectedState];
        
        if ([db executeUpdate:insertSql]) {
            NSLog(@"success to insert a data");
            [db close];
            return true;
        }
        
        NSLog(@"sucess to open db but fail to insert a data");
        [db close];
        return false;
        
    }
    NSLog(@"fail to open db in insertIntoSHOPPING_CART_TABLENAME");
    return false;

}

//根据postid删除一条记录
- (BOOL) deleteFromSHOPPING_CART_TABLE:(NSString *)postID
{
    if ([db open]) {
        NSString *deleteSql = [NSString stringWithFormat:
                               @"delete from %@ where %@ = %@",
                               SHOPPING_CART_TABLENAME, GOODS_POSTID, postID];
        if ([db executeUpdate:deleteSql]) {
            NSLog(@"success to DELETE a data");
            [db close];
            return true;
        }
        NSLog(@"sucess to open db but fail to DELETE a data");
        [db close];
        return false;
    }
    NSLog(@"fail to open db in deleteFromSHOPPING_CART_TABLE");
    return false;
}

//下面是 数组 的插入操作

-(BOOL) insertIntoGOODS_TABLEWithArray:(NSMutableArray *) mutablePosts{
    for (Post *post in mutablePosts) {
        if (post != nil) {
            NSLog(@"插入-postID: %@, URL:%@, title:%@, coverimg:%@, type:%@", [NSString stringWithFormat:@"%lu",(unsigned long)post.postID], post.good.goodURL, post.good.goodTitle, post.good.coverImageURL, post.goodType);
            BOOL flag = [self insertIntoGOODS_TABLE:@"0" postID:[NSString stringWithFormat:@"%lu",(unsigned long)post.postID ] orderID:@"1" postURL:post.good.goodURL tag:@"电商" title:post.good.goodTitle postCoverImg:post.good.goodCoverImgString price:@"10" type:post.goodType];
            if (!flag) {
                return false;
            }
        }
    }
    return true;
}

-(BOOL) insertIntoSHOPPING_CART_TABLEWithArray:(NSMutableArray *) mutablePosts
{
    for (Post *post in mutablePosts) {
        if (post != nil) {
            NSLog(@"插入-postID: %@, URL:%@, title:%@, coverimg:%@, type:%@ ,detailimages:%@", post.postID, post.good.goodURL, post.good.goodTitle, post.good.coverImageURL, post.goodType, [post getJSONStringFromDetailCoverImagesArray]);
            BOOL flag =
            [self insertIntoSHOPPING_CART_TABLE:@"0" postID:post.postID orderID:@"1" postURL:post.good.goodURL tag:@"购物车" title:post.good.goodTitle postCoverImg:post.good.goodCoverImgString price:post.good.goodPrice type:post.goodType number:post.addToCartNum detailCoverImages:[post getJSONStringFromDetailCoverImagesArray] cartSelectedState:post.cartSelectedState];
            if (!flag) {
                return false;
            }
        }
    }
    return true;
}

/**
 *  表查询 GOODS_TABLE
 */
-(NSMutableArray *) selectFromGOODS_TABLE:(NSString*)type
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

// 将JSON串转化为字典或者数组
- (id)toArrayOrNSDictionary:(NSData *)jsonData{
    NSError *error = nil;
    id jsonObject = [NSJSONSerialization JSONObjectWithData:jsonData
                                                    options:NSJSONReadingAllowFragments
                                                      error:&error];
    
    if (jsonObject != nil && error == nil){
        return jsonObject;
    }else{
        // 解析错误
        return nil;
    }
}

// 将JSON串转化为

- (NSMutableArray *) selectFromSHOPPING_CART_TABLE
{
    if ([db open]) {
        NSMutableArray *mutableGoods = [NSMutableArray arrayWithCapacity:50];
        NSString *selectSql = [NSString stringWithFormat:@"SELECT * FROM %@", SHOPPING_CART_TABLENAME];
        
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
            NSString *number = [rs stringForColumn:CART_NUMBER];
            NSString *detailcoverimgs = [rs stringForColumn:GOODS_DETAILCOVERIMAGES];
            NSData *detailcoverimgsNSData = [detailcoverimgs dataUsingEncoding:NSASCIIStringEncoding];
            NSArray *detailCoverImages = [self toArrayOrNSDictionary:detailcoverimgsNSData];
            NSString *cartSelectedState = [rs stringForColumn:CART_SELECTED_STATE];
            
            NSLog(@"id=%d, postId=%@, orderId=%@, postURL=%@, tag=%@, title=%@, postCoverImg=%@, price=%@ type=%@",id, postId, orderId ,postURL, tag, title, postCoverImg, price, type);
            
            Post *p = [[Post alloc] initWithAttributes: [NSDictionary dictionaryWithObjectsAndKeys:postId,@"itemid",title,@"title",postCoverImg,@"coverimg",price,@"itemprice",tag,@"tag",postURL,@"url", detailCoverImages, @"detailcoverimgs", type,@"type", nil] ];
            p.addToCartNum = number;
            p.cartSelectedState = cartSelectedState;
            [mutableGoods addObject:p];
        }
        [db close];
        return mutableGoods;
    }
    NSLog(@"fail to open db in selectFromSHOPPING_CART_TABLENAME");
    return nil;
}

//表是否存在该postId数据,若存在,返回该条记录,不存在或者打开数据库失败,返回nil
- (Post *)selectFromSHOPPING_CART_TABLEbyPostId:(NSString *)postId
{
    if ([db open]) {
        NSString *selectSql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@=%@", SHOPPING_CART_TABLENAME, GOODS_POSTID, postId];
        
        FMResultSet *rs = [db executeQuery:selectSql];
        while ([rs next]) {
            NSLog(@"is in SHOPPING_CART_TABLE");
            int id = [rs intForColumn:GOODS_TID];
            NSString *postId = [rs stringForColumn:GOODS_POSTID];
            NSString *orderId = [rs stringForColumn:GOODS_ORDERID];
            NSString *postURL = [rs stringForColumn:GOODS_POSTURL];
            NSString *tag = [rs stringForColumn:GOODS_TAG];
            NSString *title = [rs stringForColumn:GOODS_TITLE];
            NSString *postCoverImg = [rs stringForColumn:GOODS_COVERIMG];
            NSString *price = [rs stringForColumn:GOODS_PRICE];
            NSString *type = [rs stringForColumn:GOODS_TYPE];
            NSString *number = [rs stringForColumn:CART_NUMBER];
            NSString *detailcoverimgs = [rs stringForColumn:GOODS_DETAILCOVERIMAGES];
            NSData *detailcoverimgsNSData = [detailcoverimgs dataUsingEncoding:NSASCIIStringEncoding];
            NSArray *detailCoverImages = [self toArrayOrNSDictionary:detailcoverimgsNSData];
            NSString *cartSelectedState = [rs stringForColumn:CART_SELECTED_STATE];
            
            NSLog(@"id=%d, postId=%@, orderId=%@, postURL=%@, tag=%@, title=%@, postCoverImg=%@, price=%@ type=%@",id, postId, orderId ,postURL, tag, title, postCoverImg, price, type);
            
            Post *p = [[Post alloc] initWithAttributes: [NSDictionary dictionaryWithObjectsAndKeys:postId,@"itemid",title,@"title",postCoverImg,@"coverimg",price,@"itemprice",tag,@"tag",postURL,@"url",detailCoverImages, @"detailcoverimgs",type,@"type", nil] ];
            p.addToCartNum = number;
            p.cartSelectedState = cartSelectedState;
            [db close];
            return p;
        }
        [db close];
        NSLog(@"is not in SHOPPING_CART_TABLE");
        return nil;
    }
    NSLog(@"fail to open db in isInSHOPPING_CART_TABLE:");
    return nil;
}

//通过postId修改一条数据的购物车数量
- (BOOL)updateSHOPPING_CART_TABLESetNumber:(NSString *)postID number:(NSString *)number
{
    if ([db open]) {
        NSString *updateSql = [NSString stringWithFormat:
                               @"UPDATE %@ SET %@ = %@ WHERE %@ = %@",
                               SHOPPING_CART_TABLENAME, CART_NUMBER, number, GOODS_POSTID, postID];
        BOOL res = [db executeUpdate:updateSql];
        if (!res) {
            NSLog(@"error when update SHOPPING_CART_TABLE");
            [db close];
            return false;
        } else {
            NSLog(@"success to update SHOPPING_CART_TABLE");
            [db close];
            return true;
        }
        
    }
    NSLog(@"fail to open db in updateSHOPPING_CART_TABLESetNumber:");
    return false;
}

//通过postId修改一条数据的购物车状态
- (BOOL)updateSHOPPING_CART_TABLESetCartSelectedState:(NSString *)postID cartSelectedState:(NSString *)cartSelectedState
{
    if ([db open]) {
        NSString *updateSql = [NSString stringWithFormat:
                               @"UPDATE %@ SET %@ = %@ WHERE %@ = %@",
                               SHOPPING_CART_TABLENAME, CART_SELECTED_STATE, cartSelectedState, GOODS_POSTID, postID];
        BOOL res = [db executeUpdate:updateSql];
        if (!res) {
            NSLog(@"error when update SHOPPING_CART_TABLE");
            [db close];
            return false;
        } else {
            NSLog(@"success to update SHOPPING_CART_TABLE");
            [db close];
            return true;
        }
        
    }
    NSLog(@"fail to open db in updateSHOPPING_CART_TABLESetNumber:");
    return false;
}

//修改所有数据购物车状态
- (BOOL)updateSHOPPING_CART_TABLESetCartSelectedState:(NSString *)cartSelectedState
{
    if ([db open]) {
        NSString *updateSql = [NSString stringWithFormat:
                               @"UPDATE %@ SET %@ = %@",
                               SHOPPING_CART_TABLENAME, CART_SELECTED_STATE, cartSelectedState];
        BOOL res = [db executeUpdate:updateSql];
        if (!res) {
            NSLog(@"error when update SHOPPING_CART_TABLE");
            [db close];
            return false;
        } else {
            NSLog(@"success to update SHOPPING_CART_TABLE");
            [db close];
            return true;
        }
        
    }
    NSLog(@"fail to open db in updateSHOPPING_CART_TABLESetNumber:");
    return false;

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
        else if ([dbName isEqualToString:SHOPPING_CART_TABLENAME]) {
            NSString *sqlDeleteTable = [NSString stringWithFormat:@"DELETE FROM %@", SHOPPING_CART_TABLENAME];
            
            if (![db executeUpdate:sqlDeleteTable]) {
                NSLog(@"fail to delete SHOPPING_CART_TABLENAME");
            }
            else
                NSLog(@"success to delete SHOPPING_CART_TABLENAME");
        }
        [db close];
        return true;
    }
    NSLog(@"fail to open db in emptyDatebaseByName");
    return false;
}
@end


