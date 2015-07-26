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
#import "UIImageView+AFNetworking.h"

@implementation MainGoodsListCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.label = [[UILabel alloc] initWithFrame:CGRectMake(0, 163, 163, 50)];
        self.label.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
        self.label.textAlignment = NSTextAlignmentLeft;
        self.label.font = [UIFont boldSystemFontOfSize:15.0];
        self.label.textColor = [UIColor colorWithRed:148.0/255.0 green:148.0/255.0 blue:148.0/255.0 alpha:1.0];
        //self.label.text = @"111111111";
        [self.contentView addSubview:self.label];
        self.imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 163, 163)];
        [self.contentView addSubview:self.imageView];
        
    }
    return self;
}

- (void)setPost:(Post *)post {
    _post = post;
    
    //商品标题
    self.label.text = _post.good.goodTitle;
    
    //商品图片
    [self.imageView setImageWithURL:_post.good.coverImageURL placeholderImage:[UIImage imageNamed:@"profile-image-placeholder.jpg"]];

}

#pragma mark - UIView

- (void)layoutSubviews {
    [super layoutSubviews];
    
}


@end
