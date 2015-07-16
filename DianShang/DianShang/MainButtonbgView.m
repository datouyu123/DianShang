//
//  MainButtonbgView.m
//  DianShang
//
//  Created by 张伟颖 on 15/7/15.
//  Copyright (c) 2015年 XMUSoftware. All rights reserved.
//

#import "MainButtonbgView.h"
#include "MainButtonCVLayoutAttributes.h"

@implementation MainButtonbgView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
    }
    return self;
}

- (void)applyLayoutAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes {
    [super applyLayoutAttributes:layoutAttributes];
    
    MainButtonCVLayoutAttributes *mLayoutAttributes = (MainButtonCVLayoutAttributes *)layoutAttributes;
    self.backgroundColor = mLayoutAttributes.color;
}

@end
