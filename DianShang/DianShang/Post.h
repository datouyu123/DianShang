//
//  Post.h
//  DianShang
//
//  Created by 张伟颖 on 15/7/22.
//  Copyright © 2015年 XMUSoftware. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Good;

@interface Post : NSObject

@property (nonatomic, assign) NSUInteger postID;
@property (nonatomic, strong) NSString *goodType; //

@property (nonatomic, strong) Good *good;

- (instancetype)initWithAttributes:(NSDictionary *)attributes;

+ (NSURLSessionDataTask *)globalTimelinePostsWithBlock:(void (^)(NSArray *posts, NSError *error))block;

@end
