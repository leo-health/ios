//
//  LEODropDownController.m
//  Leo
//
//  Created by Zachary Drossman on 6/8/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import "LEODropDownController.h"
#import "LEODropDownSelectionCell.h"
#import "LEODropDownSelectionCell+ConfigureCell.h"
#import "LEODropDownSelectedCell.h"
#import "LEODropDownSelectedCell+ConfigureCell.h"
#import "LEODropDownTableView.h"

@interface LEODropDownController ()

@property (strong, nonatomic) LEODropDownTableView *tableView;
@property (strong, nonatomic) NSArray *items;
@property (copy, nonatomic) NSString *descriptorKey;
@property (copy, nonatomic) NSString *cardPropertyDescriptor;
@property (strong, nonatomic) id associatedCardObject;

@end

@implementation LEODropDownController

static NSString * const selectionReuseIdentifier = @"SelectionCell";
static NSString * const selectedReuseIdentifier = @"SelectedCell";


#pragma mark - Designated Initializer and Initializer Helper Methods
- (instancetype)initWithTableView:(LEODropDownTableView *)tableView items:(NSArray *)items usingDescriptorKey:(NSString *)descriptorKey associatedCardObject:(id)associatedCardObject associatedCardObjectPropertyDescriptor:(NSString *)cardPropertyDescriptor {
    
    self = [super init];
    
    if (self) {
        
        _tableView = tableView;
        _items = items;
        _associatedCardObject = associatedCardObject;
        _descriptorKey = descriptorKey;
        _cardPropertyDescriptor = cardPropertyDescriptor;
        
        [self prepareForLaunch];
    }
    
    return self;
}


- (void)prepareForLaunch {
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"LEODropDownSelectionCell" bundle:nil] forCellReuseIdentifier:selectionReuseIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:@"LEODropDownSelectedCell" bundle:nil] forCellReuseIdentifier:selectedReuseIdentifier];
}



#pragma mark - <UITableViewDataSource>
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
    
    if (ddTableView.expanded) {
        LEODropDownSelectionCell *cell = [tableView dequeueReusableCellWithIdentifier:selectionReuseIdentifier
                                                                         forIndexPath:indexPath];
        [cell configureForItem:self.items[indexPath.row] withDescriptorKey:self.descriptorKey];
        return cell;
    } else {
        
        LEODropDownSelectedCell *cell = [tableView dequeueReusableCellWithIdentifier:selectedReuseIdentifier
                                                                        forIndexPath:indexPath];
        [cell configureForItem:[self associatedObjectItem] withDescriptorKey:self.descriptorKey];
        return cell;
    }
}

- (id)associatedObjectItem {
    
    return [self.associatedCardObject valueForKey:self.cardPropertyDescriptor];
}



#pragma mark - <UITableViewDelegate>
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    LEODropDownTableView *ddTableView = (LEODropDownTableView *)tableView;
    
    ddTableView.expanded = !ddTableView.expanded;
    
    UITableViewCell *cell;
    
    if (!ddTableView.expanded) {
        NSIndexPath *firstIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        cell = [tableView cellForRowAtIndexPath:firstIndexPath];
        [self.associatedCardObject setValue:self.items[indexPath.row] forKey:self.cardPropertyDescriptor];
        [tableView reloadData];
        [ddTableView invalidateIntrinsicContentSize];
        
    } else {
        NSIndexPath *itemIndexPath = [NSIndexPath indexPathForRow:[self selectedItemIndex] inSection:0];
        cell = [tableView cellForRowAtIndexPath:itemIndexPath];
        [tableView reloadData];
        [ddTableView invalidateIntrinsicContentSize];
        
        [tableView selectRowAtIndexPath:itemIndexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    }
    
    cell.selected = YES;
}


#pragma mark - Other Helper Methods
//MARK: Doing this using the server-based "id" field given not sure we'll actually have the same objects in memory to compare. (Discussion about caching to happen shortly.)
- (NSUInteger)selectedItemIndex {
    
    for (NSUInteger i = 0; i < [self.items count]; i++) {
        
        if ([[self.items[i] valueForKey:@"id"] isEqualToString:[[self.associatedCardObject valueForKey:self.cardPropertyDescriptor] valueForKey:@"id"]]) {
            return i;
        }
    }
    
    return 0;
}

- (void)reloadSectionForTableView:(UITableView *)tableView WithCompletion:(void (^) (void))completionBlock {
    [tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
    if (completionBlock) {
        completionBlock();
    }
}



@end
