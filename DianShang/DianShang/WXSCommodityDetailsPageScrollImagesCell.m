//
//  WXSCommodityDetailsPageScrollImages.m
//  DianShang
//
//  Created by 张伟颖 on 15/8/11.
//  Copyright © 2015年 XMUSoftware. All rights reserved.
//

#import "WXSCommodityDetailsPageScrollImagesCell.h"
#import "ASScroll.h"
#import "Post.h"
#import "Good.h"
#import "UIimageView+AFNetworking.h"

@interface WXSCommodityDetailsPageScrollImagesCell ()
{
    ASScroll *asScroll;
}

@end

@implementation WXSCommodityDetailsPageScrollImagesCell

- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        asScroll = [[ASScroll alloc] initWithFrame:CGRectMake(0.0, 0.0, IPHONE_W, IPHONE_W)];
        [self.contentView addSubview:asScroll];
    }
    return self;
}

- (void)setGoods:(Post *)post
{
    NSMutableArray * imagesArray = [[NSMutableArray alloc] init];
    for (NSString *string in post.detailCoverImages) {
        UIImageView *scrollImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        [scrollImageView setImageWithURL:[NSURL URLWithString:string] placeholderImage:[UIImage imageNamed:@"profile-image-placeholder.jpg"]];
        [scrollImageView setContentScaleFactor:[[UIScreen mainScreen] scale]];
        scrollImageView.contentMode =  UIViewContentModeScaleAspectFill;
        scrollImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        scrollImageView.clipsToBounds  = YES;
        [imagesArray addObject:scrollImageView];
    }
    [asScroll setArrOfImages:imagesArray];
    
}

@end
