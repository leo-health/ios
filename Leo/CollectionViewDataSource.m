//
//  CollectionViewDataSource.m
//  Leo
//
//  Created by Zachary Drossman on 6/5/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import "CollectionViewDataSource.h"

@interface CollectionViewDataSource ()

@property (nonatomic, strong) NSArray *items;
@property (nonatomic, copy) NSString *cellIdentifier;
@property (nonatomic, copy) CollectionViewCellConfigureBlock configureCellBlock;

@end

@implementation CollectionViewDataSource



#pragma mark - Initializers and Intialization Helper Methods
- (id)init {
    
    return nil;
}

- (id)initWithItems:(NSArray *)items
     cellIdentifier:(NSString *)cellIdentifier
 configureCellBlock:(CollectionViewCellConfigureBlock)configureCellBlock {

    self = [super init];
    
    if (self) {
        self.items = items;
        self.cellIdentifier = cellIdentifier;
        self.configureCellBlock = [configureCellBlock copy];
    }
    
    return self;
}

- (id)itemAtIndexPath:(NSIndexPath *)indexPath {

    return self.items[(NSUInteger) indexPath.row];
}



#pragma mark - <CollectionViewDataSource>
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
 
    return self.items.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    id item = [self itemAtIndexPath:indexPath];
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:self.cellIdentifier forIndexPath:indexPath];
    
    self.configureCellBlock(cell, item);
    
    return cell;
}


@end
