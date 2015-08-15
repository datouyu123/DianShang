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

@interface MainGoodsListCollectionViewCell ()
{
    UIImageView *coverImageView;
    UILabel *title;
    UILabel *price;
}
@end
@implementation MainGoodsListCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        title = [[UILabel alloc] initWithFrame:CGRectMake(0, 163, 163, 40)];
        //title.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
        title.textAlignment = NSTextAlignmentLeft;
        title.numberOfLines = 2;
        title.font = [UIFont boldSystemFontOfSize:13.0];
        title.textColor = [UIColor colorWithRed:148.0/255.0 green:148.0/255.0 blue:148.0/255.0 alpha:1.0];
        [self.contentView addSubview:title];
        
        price = [[UILabel alloc] initWithFrame:CGRectMake(0, 203, 163, 20)];
        price.textAlignment = NSTextAlignmentLeft;
        price.font = [UIFont boldSystemFontOfSize:13.0];
        price.textColor = [UIColor colorWithRed:254.0/255.0 green:64.0/255.0 blue:47.0/255.0 alpha:1.0];
        price.text = @"11111";
        price.numberOfLines = 1;
        [self.contentView addSubview:price];
        
        coverImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 163, 163)];
        [self.contentView addSubview:coverImageView];
        
    }
    return self;
}

- (void)setGoods:(Post *)post {
    
    //商品标题
    title.text = post.good.goodTitle;
    //商品价格
    price.text = post.good.goodPrice;
    //商品图片
    [coverImageView setImageWithURL:post.good.coverImageURL placeholderImage:[UIImage imageNamed:@"profile-image-placeholder.jpg"]];

}

#pragma mark - UIView

- (void)layoutSubviews {
    [super layoutSubviews];
    
}


@end
