//
//  UICollectionViewFlowLayout+helper.m
//  DianShang
//
//  Created by 张伟颖 on 15/7/16.
//  Copyright (c) 2015年 XMUSoftware. All rights reserved.
//

#import "UICollectionViewFlowLayout+helper.h"

@implementation UICollectionViewFlowLayout (helper)
- (BOOL)indexPathLastInSection:(NSIndexPath *)indexPath {
    NSInteger lastItem = [self.collectionView.dataSource collectionView:self.collectionView numberOfItemsInSection:indexPath.section] -1;
    return  lastItem == indexPath.row;
}

- (BOOL)indexPathInLastLine:(NSIndexPath *)indexPath {
    NSInteger lastItemRow = [self.collectionView.dataSource collectionView:self.collectionView numberOfItemsInSection:indexPath.section] -1;
    NSIndexPath *lastItem = [NSIndexPath indexPathForItem:lastItemRow inSection:indexPath.section];
    UICollectionViewLayoutAttributes *lastItemAttributes = [self layoutAttributesForItemAtIndexPath:lastItem];
    UICollectionViewLayoutAttributes *thisItemAttributes = [self layoutAttributesForItemAtIndexPath:indexPath];
    
    return lastItemAttributes.frame.origin.y == thisItemAttributes.frame.origin.y;
}

- (BOOL)indexPathLastInLine:(NSIndexPath *)indexPath {
    NSIndexPath *nextIndexPath = [NSIndexPath indexPathForItem:indexPath.row+1 inSection:indexPath.section];
    
    UICollectionViewLayoutAttributes *cellAttributes = [self layoutAttributesForItemAtIndexPath:indexPath];
    UICollectionViewLayoutAttributes *nextCellAttributes = [self layoutAttributesForItemAtIndexPath:nextIndexPath];
    
    return !(cellAttributes.frame.origin.y == nextCellAttributes.frame.origin.y);
}
@end
