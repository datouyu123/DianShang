//
//  Good.h
//  DianShang
//
//  Created by 张伟颖 on 15/7/22.
//  Copyright © 2015年 XMUSoftware. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Good : NSObject

@property (nonatomic, copy) NSString *goodURL;
@property (nonatomic, copy) NSString *goodTitle;
@property (nonatomic, copy) NSString *goodPrice;
@property (nonatomic, copy) NSString *goodTag;
@property (nonatomic, copy) NSString *goodCoverImgString;
@property (nonatomic, unsafe_unretained) NSURL *coverImageURL;


#ifdef __MAC_OS_X_VERSION_MIN_REQUIRED
@property (nonatomic, strong) NSImage *coverImage;
#endif

- (instancetype)initWithAttributes:(NSDictionary *)attributes;

@end
