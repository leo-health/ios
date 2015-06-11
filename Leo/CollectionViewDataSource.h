//
//  CollectionViewDataSource.h
//  Leo
//
//  Created by Zachary Drossman on 6/5/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import <Foundation/Foundation.h>
@import UIKit;

typedef void (^CollectionViewCellConfigureBlock)(id cell, id item);

@interface CollectionViewDataSource : NSObject <UICollectionViewDataSource>

- (id)initWithItems:(NSArray *)items
     cellIdentifier:(NSString *)cellIdentifier
 configureCellBlock:(CollectionViewCellConfigureBlock)configureCellBlock;

- (id)itemAtIndexPath:(NSIndexPath *)indexPath;

@end
