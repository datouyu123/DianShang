//
//  MainGoodsListCollectionViewCell.h
//  DianShang
//
//  Created by 张伟颖 on 15/7/25.
//  Copyright © 2015年 XMUSoftware. All rights reserved.
//
//  首页第三个section商品列表cell

#import <UIKit/UIKit.h>
@class Post;
@interface MainGoodsListCollectionViewCell : UICollectionViewCell

@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UILabel *label;

/*!
 *  下面两条记录用于添加AFNetworking
 */
@property (nonatomic, strong) Post *post;
@end
