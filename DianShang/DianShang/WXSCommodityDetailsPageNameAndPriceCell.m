//
//  WXSCommodityDetailsPageNameAndPriceCell.m
//  DianShang
//
//  Created by 张伟颖 on 15/8/10.
//  Copyright © 2015年 XMUSoftware. All rights reserved.
//

#import "WXSCommodityDetailsPageNameAndPriceCell.h"
#import "Post.h"
#import "Good.h"

@interface WXSCommodityDetailsPageNameAndPriceCell ()
{
    UILabel *title;
    UILabel *price;
}

@end

@implementation WXSCommodityDetailsPageNameAndPriceCell

- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        title = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, IPHONE_W-10, 60)];
        title.textAlignment = NSTextAlignmentLeft;
        title.numberOfLines = 2;
        title.font = [UIFont boldSystemFontOfSize:16.0];
        title.textColor = [UIColor colorWithRed:148.0/255.0 green:148.0/255.0 blue:148.0/255.0 alpha:1.0];
        title.text = @"";
        [self.contentView addSubview:title];
        
        price = [[UILabel alloc] initWithFrame:CGRectMake(10, 65, IPHONE_W-10, 20)];
        price.textAlignment = NSTextAlignmentLeft;
        price.font = [UIFont boldSystemFontOfSize:18.0];
        price.textColor = [UIColor colorWithRed:254.0/255.0 green:64.0/255.0 blue:47.0/255.0 alpha:1.0];
        price.text = @"";
        price.numberOfLines = 1;
        [self.contentView addSubview:price];

    }
    return self;
    
}

- (void)setGoods:(Post *)post
{
    title.text = post.good.goodTitle;
    price.text = post.good.goodPrice;
}

@end
