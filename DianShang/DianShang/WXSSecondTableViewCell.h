//
//  WXSSecondTableViewCell.h
//  DianShang
//
//  Created by 张伟颖 on 15/8/25.
//  Copyright © 2015年 XMUSoftware. All rights reserved.
//  购物车cell

#import <UIKit/UIKit.h>
#import "SWTableViewCell.h"
#import "Post.h"
#import "Good.h"

@interface WXSSecondTableViewCell : SWTableViewCell

- (void)setGoods:(Post *)post;

@end
