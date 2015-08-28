//
//  WXSCommodityDetailsPageScrollImages.m
//  DianShang
//
//  Created by 张伟颖 on 15/8/11.
//  Copyright © 2015年 XMUSoftware. All rights reserved.
//

#import "WXSCommodityDetailsPageScrollImagesCell.h"
#import "ASScroll.h"
#import "UIimageView+AFNetworking.h"
#import "Post.h"
/**
 *  因为滚动图总会向下偏移到下一个cell一点，找不到好的方法，所以暂时把坐标向上移动10
 */
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
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        asScroll = [[ASScroll alloc] initWithFrame:CGRectMake(0.0, 0.0, IPHONE_W, IPHONE_W-10)];
        NSLog(@"%f",IPHONE_W);
        [self.contentView addSubview:asScroll];
    }
    return self;
}

- (void)setGoods:(Post *)post
{
    NSMutableArray * imagesArray = [[NSMutableArray alloc] init];
    for (NSString *string in post.detailCoverImages) {
        UIImageView *scrollImageView = [[UIImageView alloc] initWithFrame:self.bounds];
        [scrollImageView setImageWithURL:[NSURL URLWithString:string] placeholderImage:[UIImage imageNamed:@"profile-image-placeholder.jpg"]];
        [imagesArray addObject:scrollImageView];
    }
    [asScroll setArrOfImages:imagesArray];
    
}

@end
