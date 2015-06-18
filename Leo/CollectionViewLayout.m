//
//  CollectionViewLayout.m
//  Leo
//
//  Created by Zachary Drossman on 6/5/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import "CollectionViewLayout.h"

@implementation CollectionViewLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return CGSizeZero;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
   
    return UIEdgeInsetsZero;
}


@end
