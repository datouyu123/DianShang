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
    
    self.postID = (NSUInteger)[[attributes valueForKeyPath:@"itemid"] integerValue];
    self.goodType = [attributes valueForKeyPath:@"type"];
    self.detailCoverImages = [attributes valueForKeyPath:@"detailcoverimgs"];

    self.good = [[Good alloc] initWithAttributes: [NSDictionary dictionaryWithObjectsAndKeys:[attributes valueForKeyPath:@"url"],@"goods_url", [attributes valueForKeyPath:@"title"],@"goods_title",[attributes valueForKeyPath:@"coverimg"],@"goods_image_string",[attributes valueForKeyPath:@"itemprice"],@"goods_price",[attributes valueForKeyPath:@"tag"],@"goods_tag",nil]];
    
    return self;
}

#pragma mark -
//在下面的 GET 参数中，[[NSUserDefaults standardUserDefaults] stringForKey:@"loadAPI"] 是要加载接口，并且通过[[NSUserDefaults standardUserDefaults] stringForKey:@"loadType"]区分“上拉”、“下拉”刷新，以进行不同的操作

+ (NSURLSessionDataTask *)globalTimelinePostsWithBlock:(void (^)(NSArray *posts, NSError *error))block
{
    //afnetworking demo:@"stream/0/posts/stream/global"
    [[AFAppDotNetAPIClient sharedClient].requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    return [[AFAppDotNetAPIClient sharedClient] GET:@"" parameters:nil success:^(NSURLSessionDataTask * __unused task, id JSON)
    {
        if ([JSON isKindOfClass:[NSDictionary class]]) {
            NSLog(@"\n开始调用POST.M\n");
            
            NSLog(@"\n这是JSON%@\n", JSON);
            NSDictionary *postsFromResponse = [JSON valueForKeyPath:@"message"];
            
            
            NSLog(@"\n这是JSON二层%@\n", postsFromResponse);
            
            NSArray *postsFromResponse2 = [postsFromResponse valueForKeyPath:@"itemlist"];
            //NSArray *postsFromResponseLun = [postsFromResponse valueForKeyPath:@"toplist"];
            NSLog(@"\n这是JSON三层%@\n", postsFromResponse2);
            
            NSMutableArray *mutablePosts = [NSMutableArray arrayWithCapacity:[postsFromResponse2 count]];
            for (NSMutableDictionary *attributes in postsFromResponse2)
            {
                NSMutableDictionary * attr = [NSMutableDictionary dictionaryWithDictionary:attributes];
                [attr setValue:@"item" forKey:@"type"];
                Post *post = [[Post alloc] initWithAttributes:attr];
                [mutablePosts addObject:post];
            }
            if (block) {
                block([NSArray arrayWithArray:mutablePosts], nil);
            }

        }
        
    }
        failure:^(NSURLSessionDataTask *__unused task, NSError *error)
    {
        if (block) {
            block([NSArray array], error);
            NSLog(@"Error: %@", error);
            NSData *errorData = error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
            NSDictionary *serializedData = [NSJSONSerialization JSONObjectWithData: errorData options:kNilOptions error:nil];
            NSLog(@"%@",errorData);
            NSHTTPURLResponse* r = (NSHTTPURLResponse*)task.response;
            NSLog( @"success: %d", r.statusCode );
        }
    }];
}
@end
