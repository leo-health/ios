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

@interface LEODropDownController ()

@property (strong, nonatomic) LEODropDownTableView *tableView;
@property (strong, nonatomic) NSArray *items;
@property (strong, nonatomic) LEODropDownTableViewDataSource *dataSource;
@property (strong, nonatomic) LEODropDownTableViewDelegate *delegate;
@end

@implementation LEODropDownController

static NSString * const selectionReuseIdentifier = @"SelectionCell";

- (instancetype)initWithTableView:(LEODropDownTableView *)tableView items:(NSArray *)items {
    
    self = [super init];

    if (self) {
        
        _tableView = tableView;
        _items = items;
        [self prepareForLaunch];
    }
    
    return self;
}


- (void)prepareForLaunch {
    
    __weak LEODropDownTableView *weakTableView = self.tableView;
    
    void (^configureCell)(LEODropDownSelectionCell *, id item) = ^(LEODropDownSelectionCell* cell, id item) {
        
        [cell configureForListItem:item withTableView:weakTableView];
    };
    
    self.dataSource = [[LEODropDownTableViewDataSource alloc] initWithItems:self.items cellIdentifier:selectionReuseIdentifier configureCellBlock:configureCell];
    self.delegate = [[LEODropDownTableViewDelegate alloc] initWithItems:self.items];
    
    self.tableView.delegate = self.delegate;
    self.tableView.dataSource = self.dataSource;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"LEODropDownSelectionCell" bundle:nil] forCellReuseIdentifier:selectionReuseIdentifier];
    }

-(void)didChooseItemAtIndexPath:(NSIndexPath *)indexPath {
    self.selectedItem = self.items[indexPath.row];
}

@end
