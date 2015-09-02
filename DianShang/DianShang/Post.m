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
    if (self) {
        self.postID = [[NSString alloc] initWithString:[attributes valueForKeyPath:@"itemid"]];
        self.goodType = [[NSString alloc] initWithString:[attributes valueForKeyPath:@"type"]];
        self.detailCoverImages = [[NSArray alloc] initWithArray:[attributes valueForKeyPath:@"detailcoverimgs"]];
        self.addToCartNum = [[NSString alloc] init];
        self.addToCartNum = @"0";
        self.cartSelectedState = [[NSString alloc] init];
        self.cartSelectedState = @"0";
        self.good = [[Good alloc] initWithAttributes: [NSDictionary dictionaryWithObjectsAndKeys:[attributes valueForKeyPath:@"url"],@"goods_url", [attributes valueForKeyPath:@"title"],@"goods_title",[attributes valueForKeyPath:@"coverimg"],@"goods_image_string",[attributes valueForKeyPath:@"itemprice"],@"goods_price",[attributes valueForKeyPath:@"tag"],@"goods_tag",nil]];
    }
    
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
            NSLog(@"%@",errorData);
            NSHTTPURLResponse* r = (NSHTTPURLResponse*)task.response;
            NSLog( @"success: %ld", (long)r.statusCode );
        }
    }];
}

// 将字典或者数组转化为JSON串
- (NSData *)toJSONData:(id)theData{
    
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:theData
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    
    if ([jsonData length] > 0 && error == nil){
        return jsonData;
    }else{
        return nil;
    }
}

//将detailCoverImages数组转换成JSONString,方便存入sqlite
- (NSString *)getJSONStringFromDetailCoverImagesArray
{
    NSData *jsonData = [self toJSONData:self.detailCoverImages];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData
                                                 encoding:NSUTF8StringEncoding];
    return jsonString;
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

@end
