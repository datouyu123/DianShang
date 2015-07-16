//
//  FirstCollectionViewLayout.m
//  DianShang
//
//  Created by 张伟颖 on 15/7/13.
//  Copyright (c) 2015年 XMUSoftware. All rights reserved.
//

#import "FirstCollectionViewLayout.h"
#import "MainButtonbgView.h"
#import "MainLineView.h"
#import "MainButtonCVLayoutAttributes.h"
#import "UICollectionViewFlowLayout+helper.h"

@implementation FirstCollectionViewLayout

static NSString *mDecorationReuseIdentifier = @"section_background";


/*-(id)init
{
    self = [super init];
    if (self) {
        //self.itemSize = CGSizeMake(375, 200);
        self.scrollDirection = UICollectionViewScrollDirectionVertical;
        //self.sectionInset = UIEdgeInsetsMake(0.0, 0.0, 20.0, 0.0);
        //self.minimumLineSpacing = 50.0;
        [self registerClass:[MainButtonbgView class] forDecorationViewOfKind:
         mDecorationReuseIdentifier];

    }
    return self;
}
*/
/*+ (Class)layoutAttributesClass
{
    return [MainButtonCVLayoutAttributes class];
}*/

- (void)prepareLayout {
    [super prepareLayout];
    
    self.scrollDirection = UICollectionViewScrollDirectionVertical;
    [self registerClass:[MainLineView class] forDecorationViewOfKind:@"Vertical"];
    [self registerClass:[MainLineView class] forDecorationViewOfKind:@"Horizontal"];

}

- (UICollectionViewLayoutAttributes *)layoutAttributesForDecorationViewOfKind:(NSString *)decorationViewKind atIndexPath:(NSIndexPath *)indexPath {
    
    // Prepare some variables.
    NSIndexPath *nextIndexPath = [NSIndexPath indexPathForItem:indexPath.row+1 inSection:indexPath.section];
    
    UICollectionViewLayoutAttributes *cellAttributes = [self layoutAttributesForItemAtIndexPath:indexPath];
    UICollectionViewLayoutAttributes *nextCellAttributes = [self layoutAttributesForItemAtIndexPath:nextIndexPath];
    
    UICollectionViewLayoutAttributes *layoutAttributes = [UICollectionViewLayoutAttributes layoutAttributesForDecorationViewOfKind:decorationViewKind withIndexPath:indexPath];
    
    CGRect baseFrame = cellAttributes.frame;
    CGRect nextFrame = nextCellAttributes.frame;
    
    CGFloat strokeWidth = 1;
    CGFloat spaceToNextItem = 0;
    if (nextFrame.origin.y == baseFrame.origin.y)
        spaceToNextItem = (nextFrame.origin.x - baseFrame.origin.x - baseFrame.size.width);
    if (indexPath.section == 2) {
        if ([decorationViewKind isEqualToString:@"Vertical"]) {
            CGFloat padding = 10;
            
            // Positions the vertical line for this item.
            CGFloat x = baseFrame.origin.x + baseFrame.size.width + (spaceToNextItem - strokeWidth)/2;
            layoutAttributes.frame = CGRectMake(x,
                                                baseFrame.origin.y + padding,
                                                strokeWidth,
                                                baseFrame.size.height - padding*2);
        } else {
            // Positions the horizontal line for this item.
            layoutAttributes.frame = CGRectMake(baseFrame.origin.x,
                                                baseFrame.origin.y + baseFrame.size.height+5,
                                                baseFrame.size.width + spaceToNextItem,
                                                strokeWidth);
        }

    }
    
    layoutAttributes.zIndex = -1;
    return layoutAttributes;
}


- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSArray *baseLayoutAttributes = [super layoutAttributesForElementsInRect:rect];
    NSMutableArray * layoutAttributes = [baseLayoutAttributes mutableCopy];
    
    for (UICollectionViewLayoutAttributes *thisLayoutItem in baseLayoutAttributes) {
        if (thisLayoutItem.representedElementCategory == UICollectionElementCategoryCell) {
            // Adds vertical lines when the item isn't the last in a section or in line.
            if (!([self indexPathLastInSection:thisLayoutItem.indexPath] ||
                  [self indexPathLastInLine:thisLayoutItem.indexPath])) {
                UICollectionViewLayoutAttributes *newLayoutItem = [self layoutAttributesForDecorationViewOfKind:@"Vertical" atIndexPath:thisLayoutItem.indexPath];
                [layoutAttributes addObject:newLayoutItem];
            }
            
            // Adds horizontal lines when the item isn't in the last line.
            if (![self indexPathInLastLine:thisLayoutItem.indexPath]) {
                UICollectionViewLayoutAttributes *newHorizontalLayoutItem = [self layoutAttributesForDecorationViewOfKind:@"Horizontal" atIndexPath:thisLayoutItem.indexPath];
                [layoutAttributes addObject:newHorizontalLayoutItem];
            }
        }
    }
    
    return layoutAttributes;
}



@end
