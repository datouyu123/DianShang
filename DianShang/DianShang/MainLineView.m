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
        [self setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"Apple-Wood"]]];
        self.layer.shadowOpacity = 0.5;
        self.layer.shadowOffset = CGSizeMake(0,5);
    }
    return self;
}

- (void)layoutSubviews
{
    CGRect shadowBounds = CGRectMake(0, -5, self.bounds.size.width, self.bounds.size.height + 5);
    self.layer.shadowPath = [UIBezierPath bezierPathWithRect:shadowBounds].CGPath;
}
@end
