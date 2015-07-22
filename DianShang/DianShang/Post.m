//
//  Post.m
//  DianShang
//
//  Created by 张伟颖 on 15/7/22.
//  Copyright © 2015年 XMUSoftware. All rights reserved.
//

#import "Post.h"
#import "Good.h"
#import "AFAppDotNetAPIClient.h"


@implementation Post

- (instancetype)initWithAttributes:(NSDictionary *)attributes {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    self.postID = (NSUInteger)[[attributes valueForKeyPath:@"tid"] integerValue];
    self.postType = [attributes valueForKeyPath:@"type"];
    
    self.good = [[Good alloc] initWithAttributes:[attributes valueForKeyPath:@"good"]];
    
    return self;
}

#pragma mark -
//在下面的 GET 参数中，[[NSUserDefaults standardUserDefaults] stringForKey:@"loadAPI"] 是要加载接口，并且通过[[NSUserDefaults standardUserDefaults] stringForKey:@"loadType"]区分“上拉”、“下拉”刷新，以进行不同的操作

+ (NSURLSessionDataTask *)globalTimelinePostsWithBlock:(void (^)(NSArray *posts, NSError *error))block
{
    return [[AFAppDotNetAPIClient sharedClient] GET:[[NSUserDefaults standardUserDefaults] stringForKey:@"loadAPI"] parameters:nil success:^(NSURLSessionDataTask * __unused task, id JSON)
    {
        
    }
        failure:^(NSURLSessionDataTask *__unused task, NSError *error)
    {
        
    }];
}
@end
