//
//  MainGoodsListCollectionViewCell.m
//  DianShang
//
//  Created by 张伟颖 on 15/7/25.
//  Copyright © 2015年 XMUSoftware. All rights reserved.
//

#import "MainGoodsListCollectionViewCell.h"
#import "Post.h"
#import "Good.h"
#import "UIimageView+AFNetworking.h"

@implementation MainGoodsListCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.title = [[UILabel alloc] initWithFrame:CGRectMake(0, 163, 163, 50)];
        //self.title.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
        self.title.textAlignment = NSTextAlignmentLeft;
        self.title.numberOfLines = 2;
        self.title.font = [UIFont boldSystemFontOfSize:13.0];
        self.title.textColor = [UIColor colorWithRed:148.0/255.0 green:148.0/255.0 blue:148.0/255.0 alpha:1.0];
        [self.contentView addSubview:self.title];
        
        self.price = [[UILabel alloc] initWithFrame:CGRectMake(0, 213, 163, 30)];
        self.price.textAlignment = NSTextAlignmentLeft;
        self.price.font = [UIFont boldSystemFontOfSize:13.0];
        self.price.textColor = [UIColor colorWithRed:254.0/255.0 green:64.0/255.0 blue:47.0/255.0 alpha:1.0];
        self.price.text = @"11111";
        self.price.numberOfLines = 1;
        [self.contentView addSubview:self.price];
        
        self.coverImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 163, 163)];
        [self.contentView addSubview:self.coverImageView];
        
    }
    return self;
}

- (void)setGoods:(Post *)post {
    
    //商品标题
    self.title.text = post.good.goodTitle;
    //商品价格
    self.price.text = post.good.goodPrice;
    //商品图片
    [self.coverImageView setImageWithURL:post.good.coverImageURL placeholderImage:[UIImage imageNamed:@"profile-image-placeholder.jpg"]];

}

#pragma mark - UIView

- (void)layoutSubviews {
    [super layoutSubviews];
    
}


@end
