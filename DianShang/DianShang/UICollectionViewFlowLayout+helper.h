//
//  UICollectionViewFlowLayout+helper.h
//  DianShang
//
//  Created by 张伟颖 on 15/7/16.
//  Copyright (c) 2015年 XMUSoftware. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UICollectionViewFlowLayout (helper)
- (BOOL)indexPathLastInSection:(NSIndexPath *)indexPath;
- (BOOL)indexPathInLastLine:(NSIndexPath *)indexPath;
- (BOOL)indexPathLastInLine:(NSIndexPath *)indexPath;
@end
