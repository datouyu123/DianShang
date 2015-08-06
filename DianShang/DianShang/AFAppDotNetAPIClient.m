//
//  AFAppDotNetAPIClient.m
//  DianShang
//
//  Created by 张伟颖 on 15/7/22.
//  Copyright © 2015年 XMUSoftware. All rights reserved.
//

#import "AFAppDotNetAPIClient.h"

static NSString * const AFAppDotNetAPIBaseURLString = @"http://1.weixiaoshangcheng.sinaapp.com/e-commerce.php";
//测试接口：http://120.24.168.8/iosapi/e-commerce.php?
//afnetworking demo:@"https://api.app.net/stream/0/posts/stream/global"
//另一个测试接口：@"http://www.raywenderlich.com/demos/weather_sample/weather.php?format=json"

@implementation AFAppDotNetAPIClient

+ (instancetype)sharedClient {
    static AFAppDotNetAPIClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[AFAppDotNetAPIClient alloc] initWithBaseURL:[NSURL URLWithString:AFAppDotNetAPIBaseURLString]];
        _sharedClient.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
        
    });

    return _sharedClient;
}
- (instancetype)initWithBaseURL:(NSURL *)url
{
    self = [super initWithBaseURL:url];
    
    if (self) {
        self.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
        
        self.requestSerializer = [AFJSONRequestSerializer serializer];
        [self.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    }
    
    return self;
}

@end
