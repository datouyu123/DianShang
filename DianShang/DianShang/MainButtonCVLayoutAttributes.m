//
//  MainButtonCVLayoutAttributes.m
//  DianShang
//
//  Created by 张伟颖 on 15/7/15.
//  Copyright (c) 2015年 XMUSoftware. All rights reserved.
//

#import "MainButtonCVLayoutAttributes.h"

@implementation MainButtonCVLayoutAttributes
+ (UICollectionViewLayoutAttributes *)layoutAttributesForDecorationViewOfKind:(NSString *)decorationViewKind
    withIndexPath:(NSIndexPath *)indexPath {
    
    MainButtonCVLayoutAttributes *layoutAttributes = [super layoutAttributesForDecorationViewOfKind:decorationViewKind
                                                                                          withIndexPath:indexPath];
    if (indexPath.section == 1) {
        layoutAttributes.color = [UIColor whiteColor];
    } else {
        layoutAttributes.color = [UIColor clearColor];
    }
    return layoutAttributes;
}

- (id)copyWithZone:(NSZone *)zone {
    MainButtonCVLayoutAttributes *newAttributes = [super copyWithZone:zone];
    newAttributes.color = [self.color copyWithZone:zone];
    return newAttributes;
}


@end
