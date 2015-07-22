//
//  Good.h
//  DianShang
//
//  Created by 张伟颖 on 15/7/22.
//  Copyright © 2015年 XMUSoftware. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Good : NSObject

//@property (readonly, nonatomic, copy) NSString *goodURL;
@property (readonly, nonatomic, copy) NSString *goodTitle;
@property (readonly, nonatomic, copy) NSString *goodPrice;
@property (readonly, nonatomic, unsafe_unretained) NSURL *coverImageURL;

#ifdef __MAC_OS_X_VERSION_MIN_REQUIRED
@property (nonatomic, strong) NSImage *coverImage;
#endif

- (instancetype)initWithAttributes:(NSDictionary *)attributes;

@end
