//
//  ArrayDataSource.m
//  Leo
//
//  Created by Zachary Drossman on 5/15/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import "ArrayDataSource.h"

@interface ArrayDataSource ()

@property (nonatomic, strong) NSArray *items;
@property (nonatomic, copy) NSString *cellIdentifier;
@property (nonatomic, copy) TableViewCellConfigureBlock configureCellBlock;
@property (nonatomic, copy) SelectionCriteriaBlock selectionCriteriaBlock;

@end


@implementation ArrayDataSource



#pragma mark - Initializers and Initialization Helper Methods
- (id)init {
    
    return nil;
}

- (id)initWithItems:(NSArray *)items
     cellIdentifier:(NSString *)cellIdentifier
 configureCellBlock:(TableViewCellConfigureBlock)configureCellBlock
selectionCriteriaBlock:(SelectionCriteriaBlock)selectionCriteriaBlock {

    self = [super init];
    
    if (self) {
        self.items = items;
        self.cellIdentifier = cellIdentifier;
        self.configureCellBlock = [configureCellBlock copy];
        self.selectionCriteriaBlock = [selectionCriteriaBlock copy];
    }
    
    return self;
}

- (id)itemAtIndexPath:(NSIndexPath *)indexPath {
    
    return self.items[(NSUInteger) indexPath.row];
}



#pragma mark - <UITableViewDataSource>

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    id item = [self itemAtIndexPath:indexPath];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:self.cellIdentifier
                                                            forIndexPath:indexPath];

    BOOL selected = self.configureCellBlock(cell, item);
    
    if (self.selectionCriteriaBlock) {
        self.selectionCriteriaBlock(selected, indexPath);
    }
    
    return cell;
}


@end
