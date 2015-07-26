//
//  FMDBHelper.h
//  DianShang
//
//  Created by 张伟颖 on 15/7/20.
//  Copyright © 2015年 XMUSoftware. All rights reserved.
//

#import "FMDatabase.h"

//数据库
#define DBNAME @"yaopostinfo.sqlite"

//数据表

//商品简介表（一级页面）
#define GOODS_TABLENAME @"GOODS_TABLE"

//商品简介表属性
#define GOODS_TID @"goods_tid" //自增id
#define GOODS_POSTID @"goods_postid" //商品id
#define GOODS_ORDERID @"goods_orderid" //商品显示顺序id
#define GOODS_POSTURL @"goods_posturl" //商品详情页链接
#define GOODS_TAG @"gooods_tag" //商品标签（分类名称）
#define GOODS_TITLE @"goods_title" //商品标题
#define GOODS_COVERIMG @"goods_coverimg" //商品封面图片
#define GOODS_PRICE @"goods_price" //商品价格
#define GOODS_TYPE @"goods_type" //种类（轮播还是商品）

/**
 *  本地数据库操作
 */
@interface FMDBHelper : FMDatabase
{
    FMDatabase *db;
    NSString *database_path;
}

// 单实例化数据库
+ (instancetype)sharedFMDBHelper;
//创建数据库
- (FMDBHelper *)createAFMDatabase;
//初始化数据库路径
- (void)initDocPath;
//新建表
- (void)createTableByName:(NSString *) dbName;
//表查询
- (NSMutableArray *) selectFromGOODS_TABLE:(NSString *) type;
//清空表
-(BOOL) emptyDatabaseByName:(NSString *)dbName;
//插入一条数据
- (BOOL) insertIntoGOODS_TABLE:(NSString *)tID postID:(NSString *)postID orderID:(NSString *)orderID postURL:(NSString *)postURL tag:(NSString *)tag title:(NSString *)title postCoverImg:(NSString *)postCoverImg price:(NSString *) price type:(NSString *) type;
//插入数组
-(BOOL) insertIntoGOODS_TABLEWithArray:(NSMutableArray *) mutablePosts;

@end
