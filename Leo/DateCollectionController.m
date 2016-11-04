//
//  DateCollectionController.m
//  LEOCalendar
//
//  Created by Zachary Drossman on 7/29/15.
//  Copyright (c) 2015 Zachary Drossman. All rights reserved.
//

#import "DateCollectionController.h"

#import "LEODateCell+ConfigureCell.h"
#import "CollectionViewDataSource.h"
#import <DateTools/DateTools.h>
#import "NSDate+Extensions.h"
#import "UIColor+LeoColors.h"

@interface DateCollectionController ()
@property (strong, nonatomic) UICollectionView *collectionView;

@property (strong, nonatomic) NSDictionary *slotsDictionary;
@property (strong, nonatomic) CollectionViewDataSource *dataSource;
@property (strong, nonatomic) NSDate *chosenDate;
@property (nonatomic) CGFloat startingContentOffsetX;

@end

@implementation DateCollectionController

static NSString *const dateReuseIdentifier = @"DateCell";

- (instancetype)initWithCollectionView:(UICollectionView *)collectionView dates:(NSDictionary *)slotsDictionary chosenDate:(NSDate *)chosenDate {
    
    self = [super init];
    
    if (self) {
        
        _collectionView = collectionView;
        _slotsDictionary = slotsDictionary;
        _chosenDate = chosenDate;
        
        [self setupCollectionViewWithDate:chosenDate];
    }
    
    return self;
}



- (void)setupCollectionViewWithDate:(NSDate *)chosenDate {
    
    // Do any additional setup after loading the view, typically from a nib.
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"LEODateCell" bundle:nil] forCellWithReuseIdentifier:dateReuseIdentifier];
    
    void (^configureCell)(LEODateCell *, NSDate*) = ^(LEODateCell* cell, NSDate* date) {
        
        [cell configureForDate:date];
    };
    
    self.dataSource = [[CollectionViewDataSource alloc]
                       initWithItems:[self slotDateKeys]
                       cellIdentifier:dateReuseIdentifier
                       configureCellBlock:configureCell];
    
    self.collectionView.dataSource = self.dataSource;
    self.collectionView.delegate = self;
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.pagingEnabled = YES;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.showsVerticalScrollIndicator = NO;
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    flowLayout.minimumInteritemSpacing = 10.0f;
    
    self.collectionView.collectionViewLayout = flowLayout;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView {
    
    if (scrollView.contentOffset.x != self.startingContentOffsetX) {
        [self updateSelectedCellBasedOnScrollViewUpdate:scrollView];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    self.startingContentOffsetX = scrollView.contentOffset.x;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    if (scrollView.contentOffset.x != self.startingContentOffsetX) {
        [self updateSelectedCellBasedOnScrollViewUpdate:scrollView];
    }
}

/**
 *  Locate the first visible cell that is selectable, and set it as selected.
 *
 *  @param scrollView scrollview from which selected cell is being updated. Currently not used in method, but may be useful if we use this for multiple scrollviews.
 */
- (void)updateSelectedCellBasedOnScrollViewUpdate:(UIScrollView *)scrollView {
    
    NSArray *indexPathsOfVisibleItems = [[self.collectionView indexPathsForVisibleItems] sortedArrayUsingSelector:@selector(compare:)];
    
    BOOL selectableCellFound = NO;
    
    for (NSIndexPath *indexPath in indexPathsOfVisibleItems) {
        LEODateCell *cell = (LEODateCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
        
        if (cell.selectable) {
            [self updateCollectionView:self.collectionView forSelectedCellAtIndexPath:indexPath];
            selectableCellFound = YES;
            break;
        }
    }
    
    if (!selectableCellFound) {
        NSDate *firstDateInWeek = [self slotDateKeys][((NSIndexPath *)indexPathsOfVisibleItems.firstObject).row];
        [self.delegate didScrollDateCollectionViewToDate:firstDateInWeek selectable:NO];
    }
}

-(void)setChosenDate:(NSDate *)chosenDate {
    
    _chosenDate = chosenDate;
    [self.delegate didScrollDateCollectionViewToDate:chosenDate selectable:YES];
}

#pragma mark <UICollectionViewDelegate>

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self updateCollectionView:collectionView forSelectedCellAtIndexPath:indexPath];
}

- (void)updateCollectionView:(UICollectionView *)collectionView forSelectedCellAtIndexPath:(NSIndexPath *)indexPath {
    
    self.chosenDate = self.slotDateKeys[indexPath.row];
    [collectionView selectItemAtIndexPath:indexPath animated:NO scrollPosition:UICollectionViewScrollPositionNone];
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    cell.selected = YES;
}

-(void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    
    cell.selected = NO;
    
    NSDate *date = [self slotDateKeys][indexPath.row];
    
    NSCalendar *calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    
    //If the cell about to be displayed is showing the same date as the date of the appointment
    if ([calendar isDate:date inSameDayAsDate:self.chosenDate]) {
        
        cell.selected = YES;
        [collectionView selectItemAtIndexPath:indexPath animated:NO scrollPosition:UICollectionViewScrollPositionNone];
        
    } else {
        ((LEODateCell *)cell).selectable = [self.slotsDictionary[date] count] > 0 ? YES : NO;
    }
}

-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    LEODateCell *cell = (LEODateCell *)[collectionView cellForItemAtIndexPath:indexPath];
    
    if (cell.selectable) {
        return YES;
    }
    
    return NO;
}

/**
 *  Description
 */
- (CGPoint) offsetForWeekOfStartingDate {
    
    NSDate *firstDate = [[self slotDateKeys] firstObject];
    NSUInteger weeksFromFirstWeek = floor([NSDate leo_daysBetweenDate:firstDate andDate:self.chosenDate]/7);
    
    return CGPointMake(weeksFromFirstWeek * self.collectionView.frame.size.width, 0);
}

/**
 *  Returns the index path of a date relative to the first date available in the dates array
 *
 *  @param date date being searched for in array of dates
 *
 *  @return indexpath of date
 */
- (NSIndexPath *)indexPathOfDate:(NSDate *)date {
    
    NSInteger daysFromBeginningOfDateArray = [[date leo_beginningOfDay] daysFrom:[self slotDateKeys].firstObject];
    return [NSIndexPath indexPathForRow:daysFromBeginningOfDateArray inSection:0];
}


#pragma mark - <UICollectionViewDelegateFlowLayout>

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    /**
     *  Calculation of the size of each collection view cell taking account of the 10 point minimum between cells (for
     *  a total of 70 pts.
     */
    return CGSizeMake((collectionView.frame.size.width - 70)/7.0, 55.0);
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    return UIEdgeInsetsMake(10,5,10,5);
}


#pragma mark - Data helper functions

//TODO: obviously this is poor implementation, remove later.
- (NSArray *)slotDateKeys {
    
    NSSortDescriptor *ascending = [NSSortDescriptor sortDescriptorWithKey:nil ascending:YES];
    
    NSArray *keys = [[self.slotsDictionary allKeys] sortedArrayUsingDescriptors:@[ascending]];

    NSInteger lastIndexForFullWeek = keys.count - (keys.count % 7);
    keys = [keys subarrayWithRange:NSMakeRange(0, lastIndexForFullWeek)];
    
    return keys;
}

@end
