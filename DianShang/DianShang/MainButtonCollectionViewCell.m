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
        self.button = [[UIButton alloc]initWithFrame:CGRectMake(0.0, 0.0, 50,50)];
        
        // 设置圆角半径
        self.button.layer.masksToBounds = YES;
        self.button.layer.cornerRadius = 4;
        [self.contentView addSubview:self.button];
        self.label = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, frame.size.width, frame.size.height)];
        self.label.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
        self.label.textAlignment = NSTextAlignmentCenter;
        self.label.font = [UIFont boldSystemFontOfSize:50.0];
        //self.label.text = @"1111";
        self.label.backgroundColor = [UIColor whiteColor];
        self.label.textColor = [UIColor blackColor];
        [self.contentView addSubview:self.label];
    }
    return self;
}

@end
