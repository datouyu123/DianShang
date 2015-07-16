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
        self.button = [[UIButton alloc]initWithFrame:CGRectMake(0.0, 0.0, frame.size.width, frame.size.height)];
        
        // 设置圆角半径
        self.button.layer.masksToBounds = YES;
        self.button.layer.cornerRadius = 50.0f;
        //self.button.imageView.image = [UIImage imageNamed:@"content.jpg"];
        [self.contentView addSubview:self.button];
        self.label = [[UILabel alloc] initWithFrame:CGRectMake(frame.size.width/2-5.0f, frame.size.height+1.0f, 20,20)];
        self.label.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
        self.label.textAlignment = NSTextAlignmentLeft;
        self.label.font = [UIFont boldSystemFontOfSize:15.0];
        //self.label.text = @"1111";
        //self.label.backgroundColor = [UIColor whiteColor];
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
