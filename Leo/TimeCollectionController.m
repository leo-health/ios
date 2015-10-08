//
//  TimeCollectionController.m
//  LEOCalendar
//
//  Created by Zachary Drossman on 7/29/15.
//  Copyright (c) 2015 Zachary Drossman. All rights reserved.
//

#import "TimeCollectionController.h"

#import "LEOTimeCell+ConfigureCell.h"
#import "CollectionViewDataSource.h"
#import <NSDate+DateTools.h>
#import "NSDate+Extensions.h"
#import "Slot.h"
@interface TimeCollectionController ()
@property (strong, nonatomic) UICollectionView *collectionView;

@property (strong, nonatomic) NSArray *slots;
@property (strong, nonatomic) CollectionViewDataSource *dataSource;
@property (strong, nonatomic) Slot *chosenSlot;

@end

@implementation TimeCollectionController

NSString *const timeReuseIdentifier = @"TimeCell";

- (instancetype)initWithCollectionView:(UICollectionView *)collectionView slots:(NSArray *)slots chosenSlot:(nullable Slot *)chosenSlot {
    
    self = [super init];
    
    if (self) {
        
        _collectionView = collectionView;
        _slots = slots;
        _chosenSlot = chosenSlot;
        [self setupCollectionView];
    }
    
    return self;
}


#pragma mark - View Controller Lifecycle and VCL Helper Methods

- (void)setupCollectionView {
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"LEOTimeCell" bundle:nil] forCellWithReuseIdentifier:timeReuseIdentifier];

    void (^configureCell)(LEOTimeCell *, Slot*) = ^(LEOTimeCell* cell, Slot* slot) {

        [cell configureForSlot:slot];
    };

    self.dataSource = [[CollectionViewDataSource alloc] initWithItems:self.slots cellIdentifier:timeReuseIdentifier configureCellBlock:configureCell];
    
    self.collectionView.dataSource = self.dataSource;
    self.collectionView.delegate = self;
    [self.collectionView setShowsVerticalScrollIndicator:NO];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    [flowLayout setMinimumInteritemSpacing:5.0f];
    [flowLayout setMinimumLineSpacing:5.0f];
    self.collectionView.collectionViewLayout = flowLayout;
    self.collectionView.backgroundColor = [UIColor clearColor];
    
    if ([self.slots count] > 0) {
        NSLog(@"Times are being shown for date: %@", self.slots[0]);
    } else {
        NSLog(@"No slots for this date to be shown.");
    }
    
}


#pragma mark - <UICollectionViewDelegate>
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    [self updateCollectionView:collectionView forSelectedCellAtIndexPath:indexPath];
    [self.delegate didSelectSlot:self.chosenSlot];

}

- (void)updateCollectionView:(UICollectionView *)collectionView forSelectedCellAtIndexPath:(NSIndexPath *)indexPath {
    
    self.chosenSlot = self.slots[indexPath.row];
    [collectionView selectItemAtIndexPath:indexPath animated:NO scrollPosition:UICollectionViewScrollPositionNone];
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    cell.selected = YES;
}

-(void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.chosenSlot.startDateTime == ((Slot *)self.slots[indexPath.row]).startDateTime) {
        [collectionView selectItemAtIndexPath:indexPath animated:NO scrollPosition:UICollectionViewScrollPositionNone];
        cell.selected = YES;
    }
}


#pragma mark - <UICollectionViewDelegateFlowLayout>
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return CGSizeMake((self.collectionView.frame.size.width - 100) / 3, 50.0);
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    return UIEdgeInsetsMake(0, 40, 0, 40);
}

@end
