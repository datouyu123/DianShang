//
//  MainHeaderView.m
//  DianShang
//
//  Created by 张伟颖 on 15/7/16.
//  Copyright (c) 2015年 XMUSoftware. All rights reserved.
//

#import "MainHeaderView.h"

@implementation MainHeaderView
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0, 0, frame.size.width, frame.size.height)];
        self.nameLabel.textAlignment = NSTextAlignmentLeft;
        self.nameLabel.font = [UIFont boldSystemFontOfSize:17.0];
        self.nameLabel.backgroundColor = [UIColor clearColor];
        self.nameLabel.textColor = [UIColor colorWithRed:67.0/255.0 green:67.0/255.0 blue:67.0/255.0 alpha:1.0];
        [self addSubview: self.nameLabel];
        
    }
    return self;
}
@end
