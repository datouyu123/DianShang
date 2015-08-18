//
//  WXSCommodityDetailsPagePopupViewFirstCell.h
//  DianShang
//
//  Created by 张伟颖 on 15/8/16.
//  Copyright © 2015年 XMUSoftware. All rights reserved.
//  详情页弹出视图第一行

#import <UIKit/UIKit.h>
#import "Post.h"
#import "Good.h"
#import "CNPPopupController.h"

@interface WXSCommodityDetailsPagePopupViewFirstCell : UITableViewCell

@property (nonatomic, strong)CNPPopupButton *closeButton;
- (void)setGoods:(Post *)post;

@end
