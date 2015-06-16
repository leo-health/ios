//
//  BasicSelectionTableViewDelegate.m
//  Leo
//
//  Created by Zachary Drossman on 6/8/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import "LEODropDownTableViewDelegate.h"
#import "LEODropDownTableView.h"
#import "LEOListItem.h"
#import "LEODropDownSelectionCell.h"

@interface LEODropDownTableViewDelegate ()

@property (nonatomic) NSUInteger selectedItemIndex;
@end

@implementation LEODropDownTableViewDelegate


- (instancetype)initWithSelectedItemIndex:(NSUInteger)selectedItemIndex {
    
    self = [super init];
    
    if (self) {
        _selectedItemIndex = selectedItemIndex;
    }
    
    return self;
}

@end
