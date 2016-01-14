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
        _items = items;
        _cellIdentifier = cellIdentifier;
        _configureCellBlock = [configureCellBlock copy];
        _selectionCriteriaBlock = [selectionCriteriaBlock copy];
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

    //TODO: Come back and review this as a pattern; obviously would be more effective if all cells were reloaded in one call (but this might be premature optimization.)
    NSOperationQueue *reloadCellQueue = [NSOperationQueue new];

    [[NSNotificationCenter defaultCenter] addObserverForName:kNotificationCellUpdate object:item queue:reloadCellQueue usingBlock:^(NSNotification * _Nonnull notification) {

        dispatch_async(dispatch_get_main_queue(), ^{
            [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        });
    }];

    BOOL selected = self.configureCellBlock(cell, item);
    
    if (self.selectionCriteriaBlock) {
        self.selectionCriteriaBlock(selected, indexPath);
    }
    
    return cell;
}


@end
