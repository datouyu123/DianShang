//
//  Post.h
//  DianShang
//
//  Created by 张伟颖 on 15/7/22.
//  Copyright © 2015年 XMUSoftware. All rights reserved.
//  首页商品和购物车商品同用这个实体，以后考虑分开处理

#import <Foundation/Foundation.h>

@class Good;

@interface Post : NSObject

@property (nonatomic, copy) NSString *postID;
@property (nonatomic, copy) NSString *goodType;
@property (nonatomic, strong) NSArray *detailCoverImages;//详情页滚动图片集
@property (nonatomic, copy) NSString *addToCartNum; //加入购物车数量
@property (nonatomic, copy) NSString *cartSelectedState; //在购物车中是否被选中状态，1代表选中，0代表未选中（未加入购物车）
@property (nonatomic, strong) Good *good;

- (instancetype)initWithAttributes:(NSDictionary *)attributes;
//将detailCoverImages数组转换成JSONString,方便存入sqlite
- (NSString *)getJSONStringFromDetailCoverImagesArray;

+ (NSURLSessionDataTask *)globalTimelinePostsWithBlock:(void (^)(NSArray *posts, NSError *error))block;

@end
