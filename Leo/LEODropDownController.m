//
//  LEODropDownController.m
//  Leo
//
//  Created by Zachary Drossman on 6/8/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import "LEODropDownController.h"
#import "LEODropDownSelectionCell.h"
#import "LEODropDownTableViewDataSource.h"
#import "LEODropDownTableViewDelegate.h"
#import "LEODropDownSelectionCell+ConfigureCell.h"
#import "LEOListItem.h"
#import "LEODropDownTableView.h"
#import "Appointment.h"

@interface LEODropDownController ()

@property (strong, nonatomic) LEODropDownTableView *tableView;
@property (strong, nonatomic) NSArray *items;
@property (strong, nonatomic) LEODropDownTableViewDataSource *dataSource;
@property (copy, nonatomic) NSString *descriptorKey;
@property (strong, nonatomic) id associatedCardObjectItem;

@end

@implementation LEODropDownController

static NSString * const selectionReuseIdentifier = @"SelectionCell";

- (instancetype)initWithTableView:(LEODropDownTableView *)tableView items:(NSArray *)items usingDescriptorKey:(NSString *)descriptorKey associatedCardObject:(id)associatedCardObject {
    
    self = [super init];
    
    if (self) {
        
        _tableView = tableView;
        _items = items;
        _associatedCardObject = associatedCardObject;
        _descriptorKey = descriptorKey;
        
        [self prepareForLaunch];
    }
    
    return self;
}


- (void)prepareForLaunch {
    
    __weak LEODropDownTableView *weakTableView = self.tableView;
    
    void (^configureCell)(LEODropDownSelectionCell *, id item) = ^(LEODropDownSelectionCell* cell, id item) {
        [cell configureForItem:item withDescriptorKey:self.descriptorKey withTableView:weakTableView];
    };
    
    self.associatedCardObjectItem = [self.associatedCardObject valueForKey:@"provider"];
    self.dataSource = [[LEODropDownTableViewDataSource alloc] initWithItems:self.items cellIdentifier:selectionReuseIdentifier configureCellBlock:configureCell associatedCardObject:self.associatedCardObject];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self.dataSource;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"LEODropDownSelectionCell" bundle:nil] forCellReuseIdentifier:selectionReuseIdentifier];
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    LEODropDownTableView *ddTableView = (LEODropDownTableView *)tableView;
    
        if (ddTableView.expanded) {
            NSIndexPath *firstIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
            UITableViewCell *cell = [tableView cellForRowAtIndexPath:firstIndexPath];
            cell.selected = YES;
            [self.associatedCardObject setValue:self.items[indexPath.row] forKey:@"provider"];
        } else {
            NSIndexPath *itemIndexPath = [NSIndexPath indexPathForRow:[self selectedItemIndex] inSection:0];
            UITableViewCell *cell = [tableView cellForRowAtIndexPath:itemIndexPath];
            cell.selected = YES;
            [tableView selectRowAtIndexPath:itemIndexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
        }
    
    ddTableView.expanded = !ddTableView.expanded;

    [self reloadSectionForTableView:tableView WithCompletion:^{
        [ddTableView invalidateIntrinsicContentSize];
    }];
}


//MARK: Doing this using the server-based "id" field given not sure we'll actually have the same objects in memory to compare. (Discussion about caching to happen shortly.)

- (NSUInteger)selectedItemIndex {
    
    for (NSUInteger i = 0; i < [self.items count]; i++) {
        
        if ([[self.items[i] valueForKey:@"id"] isEqualToString:[[self.associatedCardObject valueForKey:@"provider"] valueForKey:@"id"]]) {
            return i;
        }
    }

    return 0;

}

- (void)reloadSectionForTableView:(UITableView *)tableView WithCompletion:(void (^) (void))completionBlock {
    [tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
    if (completionBlock) {
        completionBlock();
    }
    
}


@end
