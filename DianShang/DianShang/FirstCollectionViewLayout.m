//
//  FirstCollectionViewLayout.m
//  DianShang
//
//  Created by 张伟颖 on 15/7/13.
//  Copyright (c) 2015年 XMUSoftware. All rights reserved.
//

#import "FirstCollectionViewLayout.h"

@implementation FirstCollectionViewLayout

#define ACTIVE_DISTANCE 200
#define ZOOM_FACTOR 0.3

-(id)init
{
    self = [super init];
    if (self) {
        //self.itemSize = CGSizeMake(375, 200);
        self.scrollDirection = UICollectionViewScrollDirectionVertical;
        //self.sectionInset = UIEdgeInsetsMake(0.0, 0.0, 20.0, 0.0);
        //self.minimumLineSpacing = 50.0;
        
    }
    return self;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)oldBounds
{
    return YES;
}

-(NSArray*)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSArray* array = [super layoutAttributesForElementsInRect:rect];
    CGRect visibleRect;
    visibleRect.origin = self.collectionView.contentOffset;
    visibleRect.size = self.collectionView.bounds.size;
    
    for (UICollectionViewLayoutAttributes* attributes in array) {
        if (CGRectIntersectsRect(attributes.frame, rect)) {
           //CGFloat distance = CGRectGetMidX(visibleRect) - attributes.center.x;
            //CGFloat normalizedDistance = distance / ACTIVE_DISTANCE;
            /*if (ABS(distance) < ACTIVE_DISTANCE) {
                CGFloat zoom = 1 + ZOOM_FACTOR*(1 - ABS(normalizedDistance));
                attributes.transform3D = CATransform3DMakeScale(zoom, zoom, 1.0);
                attributes.zIndex = 1;
             
            }*/
        }
    }
    return array;
}



@end
