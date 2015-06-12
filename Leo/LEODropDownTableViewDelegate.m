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

@property (strong, nonatomic) NSArray *items;
@end

@implementation LEODropDownTableViewDelegate


- (instancetype)initWithItems:(NSArray *)items {
    
    self = [super init];
    
    if (self) {
        _items = items;
        [self selectFirstItemIfNoItemAlreadySelected];
    }
    
    return self;
}

- (void)selectFirstItemIfNoItemAlreadySelected {
    
    NSUInteger unselectedItemCount = 0;
    
    for (LEOListItem *item in self.items) {
        if (!item.selected) {
            unselectedItemCount++;
        }
    }
    
    if (unselectedItemCount != [self.items count]) {
        LEOListItem *firstItem = self.items[0];
        firstItem.selected = YES;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    LEODropDownTableView *ddTableView = (LEODropDownTableView *)tableView;
    
    if (ddTableView.expanded) {
        [self deselectAllListItems];
        LEOListItem *item = self.items[indexPath.row];
        item.selected = YES;
    }
    
    ddTableView.expanded = !ddTableView.expanded;
    
    [self reloadSectionForTableView:tableView WithCompletion:^{
        [ddTableView invalidateIntrinsicContentSize];
    }];
    
    [self.delegate didChooseItemAtIndexPath:indexPath];
}


-(void)deselectAllListItems {
    for (LEOListItem *item in self.items) {
        item.selected = NO;
    }
}
-(void)reloadSectionForTableView:(UITableView *)tableView WithCompletion:(void (^) (void))completionBlock {
    [tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
    if (completionBlock) {
        completionBlock();
    }
    
}
@end
