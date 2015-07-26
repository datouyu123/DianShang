//
//  MainButtonCollectionViewCell.m
//  DianShang
//
//  Created by 张伟颖 on 15/7/14.
//  Copyright (c) 2015年 XMUSoftware. All rights reserved.
//

#import "MainButtonCollectionViewCell.h"

@implementation MainButtonCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.label = [[UILabel alloc] initWithFrame:CGRectMake(frame.size.width/2-5.0f, frame.size.height+1.0f, 20,20)];
        self.label.numberOfLines = 2;
        self.label.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
        self.label.textAlignment = NSTextAlignmentLeft;
        self.label.font = [UIFont boldSystemFontOfSize:15.0];
        self.label.textColor = [UIColor colorWithRed:148.0/255.0 green:148.0/255.0 blue:148.0/255.0 alpha:1.0];
        [self.contentView addSubview:self.label];
        self.imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"bear_button.png"]];
        self.imageView.frame = CGRectMake(0, 0, 50.0f, 50.0f);
        self.imageView.layer.masksToBounds = YES;
        self.imageView.layer.cornerRadius = 25.0f;
        [self.contentView addSubview:self.imageView];

    }
    return self;
}

@end
