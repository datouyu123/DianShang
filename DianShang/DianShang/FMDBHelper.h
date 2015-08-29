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
//购物车表
#define SHOPPING_CART_TABLENAME @"SHOPPING_CART_TABLE"

//商品简介表属性(购物车表也暂时用这个)
#define GOODS_TID @"goods_tid" //自增id
#define GOODS_POSTID @"goods_postid" //商品id
#define GOODS_ORDERID @"goods_orderid" //商品显示顺序id
#define GOODS_POSTURL @"goods_posturl" //商品详情页链接
#define GOODS_TAG @"goods_tag" //商品标签（分类名称）
#define GOODS_TITLE @"goods_title" //商品标题
#define GOODS_COVERIMG @"goods_coverimg" //商品封面图片
#define GOODS_PRICE @"goods_price" //商品价格
#define GOODS_TYPE @"goods_type" //种类（轮播还是商品）
#define GOODS_DETAILCOVERIMAGES @"goods_detailcoverimgs" //详情页滚动图
#define CART_NUMBER @"cart_number" //购物车数量
#define CART_SELECTED_STATE @"cart_selected_state" //购物车中是否被选中状态（1代表选中，0代表未选中或者未加入购物车）

/**
 *  本地数据库操作
 */

@class Post;

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
- (NSMutableArray *)selectFromGOODS_TABLE:(NSString *)type;
- (NSMutableArray *)selectFromSHOPPING_CART_TABLE;
//表是否存在该postId数据,若存在,返回该条记录,不存在或者打开数据库失败,返回nil
- (Post *)selectFromSHOPPING_CART_TABLEbyPostId:(NSString *)postId;
//清空表
-(BOOL)emptyDatabaseByName:(NSString *)dbName;
//插入一条数据
- (BOOL) insertIntoGOODS_TABLE:(NSString *)tID postID:(NSString *)postID orderID:(NSString *)orderID postURL:(NSString *)postURL tag:(NSString *)tag title:(NSString *)title postCoverImg:(NSString *)postCoverImg price:(NSString *) price type:(NSString *) type;
- (BOOL)insertIntoSHOPPING_CART_TABLE:(NSString *)tID postID:(NSString *)postID orderID:(NSString *)orderID postURL:(NSString *)postURL tag:(NSString *)tag title:(NSString *)title postCoverImg:(NSString *)postCoverImg price:(NSString *) price type:(NSString *) type number:(NSString *)number detailCoverImages:(NSString *)detailCoverImages cartSelectedState:(NSString *)cartSelectedState;
//删除一条数据
- (BOOL)deleteFromSHOPPING_CART_TABLE:(NSString *)postID;
//插入数组
- (BOOL)insertIntoGOODS_TABLEWithArray:(NSMutableArray *) mutablePosts;
- (BOOL)insertIntoSHOPPING_CART_TABLEWithArray:(NSMutableArray *) mutablePosts;
//通过postId修改一条数据的购物车数量
- (BOOL)updateSHOPPING_CART_TABLESetNumber:(NSString *)postID number:(NSString *)number;
//通过postId修改一条数据的购物车状态
- (BOOL)updateSHOPPING_CART_TABLESetCartSelectedState:(NSString *)postID cartSelectedState:(NSString *)cartSelectedState;

@end
