//
//  LEODropDownTableViewDataSource.m
//  Leo
//
//  Created by Zachary Drossman on 6/8/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import "LEODropDownTableViewDataSource.h"
#import "LEODropDownTableView.h"
#import "LEOListItem.h"

@interface LEODropDownTableViewDataSource ()

@property (nonatomic, strong) NSArray *items;
@property (nonatomic, copy) NSString *cellIdentifier;
@property (nonatomic, copy) TableViewCellConfigureBlock configureCellBlock;
@property (strong, nonatomic) id associatedCardObject;

@end


@implementation LEODropDownTableViewDataSource

- (id)init {
    return nil;
}

- (id)initWithItems:(NSArray *)items
     cellIdentifier:(NSString *)cellIdentifier
 configureCellBlock:(TableViewCellConfigureBlock)configureCellBlock
associatedCardObject:(id)associatedCardObject {
    self = [super init];
    if (self) {
        _items = items;
        _cellIdentifier = cellIdentifier;
        _configureCellBlock = [configureCellBlock copy];
        _associatedCardObject = associatedCardObject;
    }
    
    return self;
}

- (id)itemAtIndexPath:(NSIndexPath *)indexPath {
    return self.items[(NSUInteger) indexPath.row];
}


#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    LEODropDownTableView *ddTableView = (LEODropDownTableView *)tableView;
    
    if (!ddTableView.expanded) {
        return 1;
    } else {
        return [self.items count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    LEODropDownTableView *ddTableView = (LEODropDownTableView *)tableView;
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:self.cellIdentifier
                                                            forIndexPath:indexPath];
    id item;
    
    if (ddTableView.expanded) {
        item = [self itemAtIndexPath:indexPath];
    } else {
        item = [self.associatedCardObject valueForKey:@"provider"];
    }

    self.configureCellBlock(cell, item);
    
    return cell;
}



@end
