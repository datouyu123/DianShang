//
//  Good.m
//  DianShang
//
//  Created by 张伟颖 on 15/7/22.
//  Copyright © 2015年 XMUSoftware. All rights reserved.
//

#import "Good.h"
#import "AFHTTPRequestOperation.h"
#import "MJExtension.h"

NSString * const kUserCoverImageDidLoadNotification = @"com.alamofire.user.profile-image.loaded";

@interface Good ()

#ifdef __MAC_OS_X_VERSION_MIN_REQUIRED
@property (readwrite, nonatomic, strong) AFHTTPRequestOperation *coverImageRequestOperation;
#endif


@end
@implementation Good
// NSCoding实现
MJExtensionCodingImplementation

- (instancetype)initWithAttributes:(NSDictionary *)attributes {
    self = [super init];
    if (self) {
        self.goodURL = [[NSString alloc] init];
        self.goodURL = [attributes valueForKeyPath:@"goods_url"];
        self.goodTitle = [[NSString alloc] init];
        self.goodTitle = [attributes valueForKeyPath:@"goods_title"];
        self.goodPrice = [[NSString alloc] init];
        self.goodPrice = [attributes valueForKeyPath:@"goods_price"];
        self.goodTag = [[NSString alloc] init];
        self.goodTag = [attributes valueForKeyPath:@"goods_tag"];
        self.goodCoverImgString = [[NSString alloc] init];
        self.goodCoverImgString = [attributes valueForKeyPath:@"goods_image_string"];
    }
    
    return self;
}

- (NSURL *)coverImageURL {
    return [NSURL URLWithString:self.goodCoverImgString];
}

#pragma mark -

#ifdef __MAC_OS_X_VERSION_MIN_REQUIRED

+ (NSOperationQueue *)sharedCoverImageRequestOperationQueue {
    static NSOperationQueue *_sharedCoverImageRequestOperationQueue = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedCoverImageRequestOperationQueue = [[NSOperationQueue alloc] init];
        [_sharedCoverImageRequestOperationQueue setMaxConcurrentOperationCount:8];
    });
    
    return _sharedCoverImageRequestOperationQueue;
}

- (NSImage *)coverImage {
    if (!_coverImage && !_coverImageRequestOperation) {
        NSMutableURLRequest *mutableRequest = [NSMutableURLRequest requestWithURL:self.coverImageURL];
        [mutableRequest setValue:@"image/*" forHTTPHeaderField:@"Accept"];
        AFHTTPRequestOperation *imageRequestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:mutableRequest];
        imageRequestOperation.responseSerializer = [AFImageResponseSerializer serializer];
        [imageRequestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, NSImage *responseImage) {
            self.coverImage = responseImage;
            
            _coverImageRequestOperation = nil;
            
            [[NSNotificationCenter defaultCenter] postNotificationName:kUserCoverImageDidLoadNotification object:self userInfo:nil];
        } failure:nil];
        
        [imageRequestOperation setCacheResponseBlock:^NSCachedURLResponse *(NSURLConnection *connection, NSCachedURLResponse *cachedResponse) {
            return [[NSCachedURLResponse alloc] initWithResponse:cachedResponse.response data:cachedResponse.data userInfo:cachedResponse.userInfo storagePolicy:NSURLCacheStorageAllowed];
        }];
        
        _coverImageRequestOperation = imageRequestOperation;
        
        [[[self class] sharedCoverImageRequestOperationQueue] addOperation:_coverImageRequestOperation];
    }
    
    return _coverImage;
}

#endif

@end
