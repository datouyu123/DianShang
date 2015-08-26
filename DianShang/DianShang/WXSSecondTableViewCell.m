//
//  WXSSecondTableViewCell.m
//  DianShang
//
//  Created by 张伟颖 on 15/8/25.
//  Copyright © 2015年 XMUSoftware. All rights reserved.
//  购物车cell

#import "WXSSecondTableViewCell.h"
#import "UIimageView+AFNetworking.h"

#define iOS8 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)

@interface WXSSecondTableViewCell ()

@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *numberLabel;

@end

@implementation WXSSecondTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.imageView.frame = CGRectMake(5, 5, 90, 90);
        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(110, 5, IPHONE_W-120-10, 40)];
        self.nameLabel.numberOfLines = 0;
        self.nameLabel.font = [UIFont systemFontOfSize:14.0f];
        [self.contentView addSubview:self.nameLabel];
        
        self.numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(110, 60, IPHONE_W-120-10, 20)];
        self.numberLabel.numberOfLines = 1;
        self.numberLabel.font = [UIFont systemFontOfSize:14.0f];
        [self.contentView addSubview:self.numberLabel];
        
    }
    return self;
}

- (void)setGoods:(Post *)post
{
    [self.imageView setImageWithURL:post.good.coverImageURL placeholderImage:[UIImage imageNamed:@"profile-image-placeholder"]];
    //商品名
    self.nameLabel.text = post.good.goodTitle;
    //加入购物车数量
    self.numberLabel.text = [NSString stringWithFormat:@"数量: %@", post.addToCartNum];
  
    //
    [self setNeedsLayout];
    NSLog(@"cell.name=%@,cell.number=%@",self.nameLabel.text,self.numberLabel.text);
    NSLog(@"namelabel.width=%f,namelabel.height=%f",self.nameLabel.frame.size.width,self.nameLabel.frame.size.height);
    NSLog(@"numberlabel.width=%f,numberlabel.height=%f",self.numberLabel.frame.size.width,self.numberLabel.frame.size.height);
    NSLog(@"namelabel.x=%f,namelabel.y=%f",self.nameLabel.frame.origin.x,self.nameLabel.frame.origin.y);
    NSLog(@"numberlabel.x=%f,numberlabel.y=%f",self.numberLabel.frame.origin.x,self.numberLabel.frame.origin.y);
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.imageView.frame = CGRectMake(5, 5, 90, 90);
    self.nameLabel.frame = CGRectMake(110, 5, IPHONE_W-120-10, 40);
    self.numberLabel.frame = CGRectMake(110, 60, IPHONE_W-120-10, 20);
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
