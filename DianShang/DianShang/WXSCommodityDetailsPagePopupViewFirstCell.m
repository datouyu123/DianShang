//
//  WXSCommodityDetailsPagePopupViewFirstCell.m
//  DianShang
//
//  Created by 张伟颖 on 15/8/16.
//  Copyright © 2015年 XMUSoftware. All rights reserved.
//  商品详情页弹出视图第一行自定义显示图片和价格以及关闭按钮cell

#import "WXSCommodityDetailsPagePopupViewFirstCell.h"
#import "UIimageView+AFNetworking.h"
#import "Post.h"
#import "Good.h"

@interface WXSCommodityDetailsPagePopupViewFirstCell ()
{
    
}

@end

@implementation WXSCommodityDetailsPagePopupViewFirstCell

- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        //self.textLabel.adjustsFontSizeToFitWidth = NO;
        self.textLabel.numberOfLines = 1;
        self.textLabel.font = [UIFont systemFontOfSize:16.0f];
        self.textLabel.textColor = [UIColor colorWithRed:254.0/255.0 green:64.0/255.0 blue:47.0/255.0 alpha:1.0];
        self.imageView.frame = CGRectMake(5, 5, 90, 90);
        
        self.closeButton = [[CNPPopupButton alloc] initWithFrame:CGRectMake(IPHONE_W-40, 10, 30, 30)];
        [self.closeButton setBackgroundImage:[UIImage imageNamed:@"close_icon"] forState:UIControlStateNormal];
        
        [self.contentView addSubview:self.closeButton];
    }
    return self;
}

- (void)setGoods:(Post *)post
{
    //单价
    self.textLabel.text = post.good.goodPrice;
    //
    [self.imageView setImageWithURL:post.good.coverImageURL placeholderImage:[UIImage imageNamed:@"profile-image-placeholder"]];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.imageView.frame = CGRectMake(5, 5, 90, 90);
    self.closeButton.frame = CGRectMake(IPHONE_W-40, 10, 30, 30);
}

@end
