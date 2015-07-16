//
//  MainLineView.m
//  DianShang
//
//  Created by 张伟颖 on 15/7/16.
//  Copyright (c) 2015年 XMUSoftware. All rights reserved.
//


#import "MainLineView.h"
#import <QuartzCore/QuartzCore.h>

@implementation MainLineView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"mainLine_background.png"]]];
        
    }
    return self;
}

- (void)layoutSubviews
{
    //CGRect shadowBounds = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
    //self.layer.shadowPath = [UIBezierPath bezierPathWithRect:shadowBounds].CGPath;
}
@end
