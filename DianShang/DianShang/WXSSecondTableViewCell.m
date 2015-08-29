//
//  WXSSecondTableViewCell.m
//  DianShang
//
//  Created by 张伟颖 on 15/8/25.
//  Copyright © 2015年 XMUSoftware. All rights reserved.
//  购物车cell

#import "WXSSecondTableViewCell.h"
#import "UIimageView+AFNetworking.h"
#import "DLRadioButton.h"
#define iOS8 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)

@interface WXSSecondTableViewCell ()
{
    UILabel *nameLabel;
    UILabel *priceLabel;
    UILabel *numberLabel;
    UIButton *radioButton;
    BOOL selectState;//选中状态
}

@end

@implementation WXSSecondTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        radioButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 10, 30, 30)];
        [radioButton setImage:[UIImage imageNamed:@"checkbox_normal"] forState:UIControlStateNormal];
        [radioButton setImage:[UIImage imageNamed:@"checkbox_selected"] forState:UIControlStateSelected];
        [radioButton addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:radioButton];
        
        self.imageView.frame = CGRectMake(50, 5, 90, 90);
        nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(160, 5, IPHONE_W - 160 - 10, 40)];
        nameLabel.numberOfLines = 0;
        nameLabel.font = [UIFont systemFontOfSize:14.0f];
        [self.contentView addSubview:nameLabel];
        
        priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(160, 50, IPHONE_W - 160 - 10, 15)];
        priceLabel.numberOfLines = 1;
        priceLabel.font = [UIFont systemFontOfSize:14.0f];
        priceLabel.textColor = [UIColor colorWithRed:254.0/255.0 green:64.0/255.0 blue:47.0/255.0 alpha:1.0];

        [self.contentView addSubview:priceLabel];
        
        numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(160, 70, IPHONE_W - 160 - 10, 15)];
        numberLabel.numberOfLines = 1;
        numberLabel.font = [UIFont systemFontOfSize:14.0f];
        [self.contentView addSubview:numberLabel];
        
    }
    return self;
}

-(void)click:(id)sender
{
    //调用tableview中代理方法，将model层状态更新，再通过reloaddata刷新
    [self.wxsdelegate radioBtnClick:self];
}

- (void)setGoods:(Post *)post
{
    [self.imageView setImageWithURL:post.good.coverImageURL placeholderImage:[UIImage imageNamed:@"profile-image-placeholder"]];
    //商品名
    nameLabel.text = post.good.goodTitle;
    //单价
    priceLabel.text = [NSString stringWithFormat:@"¥%@",post.good.goodPrice];
    //加入购物车数量
    numberLabel.text = [NSString stringWithFormat:@"数量: %@", post.addToCartNum];
    //选中状态
    if([post.cartSelectedState isEqualToString:@"1"])
    {
        selectState = YES;
        radioButton.selected = YES;
    }
    else
    {
        selectState = NO;
        radioButton.selected = NO;
    }
    
    //[self setNeedsLayout];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    radioButton.frame = CGRectMake(10, 10, 30, 30);
    self.imageView.frame = CGRectMake(50, 5, 90, 90);
    nameLabel.frame = CGRectMake(160, 5, IPHONE_W - 160 - 10, 40);
    priceLabel.frame = CGRectMake(160, 50, IPHONE_W - 160 - 10, 15);
    numberLabel.frame = CGRectMake(160, 70, IPHONE_W - 160 - 10, 15);
}

//- (void)drawRect:(CGRect)rect
//{
//    [super drawRect:rect];
//    if (iOS8){
//        [self layoutIfNeeded];
//    }
//    self.imageView.frame = CGRectMake(5, 5, 90, 90);
//    self.nameLabel.frame = CGRectMake(110, 5, IPHONE_W-120-10, 40);
//    self.numberLabel.frame = CGRectMake(110, 60, IPHONE_W-120-10, 20);
//
//}

@end
