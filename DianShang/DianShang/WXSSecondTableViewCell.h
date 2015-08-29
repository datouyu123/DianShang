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

//添加代理，用于radiobutton的实现
@protocol WXSSecondTableViewCellDelegate <NSObject>

-(void)radioBtnClick:(UITableViewCell *)cell;

@end

@interface WXSSecondTableViewCell : SWTableViewCell

@property (weak,nonatomic) id <WXSSecondTableViewCellDelegate> wxsdelegate;

- (void)setGoods:(Post *)post;

@end
