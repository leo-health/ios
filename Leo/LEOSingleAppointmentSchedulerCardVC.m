//
//  LEOSingleAppointmentSchedulerCardVC.m
//  Leo
//
//  Created by Zachary Drossman on 5/14/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import "LEOSingleAppointmentSchedulerCardVC.h"
#import "LEOCoreDataManager.h"
#import <NSDate+DateTools.h>
#import "LEOTimeCell.h"
#import "UIFont+LeoFonts.h"
#import "ArrayDataSource.h"
#import "LEODateCell.h"
#import "UIColor+LeoColors.h"
#import "UIFont+LeoFonts.h"
#import "PageViewDataSource.h"
#import "TimeCollectionViewController.h"
#import "NSDate+Extensions.h"
#import "LEOButtonView.h"
#import "CollectionViewDataSource.h"

@interface LEOSingleAppointmentSchedulerCardVC ()

#pragma mark - IBOutlets

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UICollectionView *dateCollectionView;
@property (weak, nonatomic) IBOutlet UILabel *monthLabel;
@property (weak, nonatomic) IBOutlet LEOButtonView *buttonView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *cancelButton;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UILabel *fullAppointmentDateLabel;


#pragma mark - Data
@property (strong, nonatomic) NSDate *selectedDate;
@property (strong, nonatomic) NSDate *tempSelectedDate;
@property (strong, nonatomic) NSArray *dates;
@property (strong, nonatomic) NSLayoutConstraint *containerViewHeightConstraint;

#pragma mark - Helper classes
@property (strong, nonatomic) ArrayDataSource *arrayDataSource;
@property (strong, nonatomic) CollectionViewDataSource *dataSource;
@property (strong, nonatomic) LEOCoreDataManager *coreDataManager;
@property (readonly, strong, nonatomic) PageViewDataSource *pageViewDataSource;



@property (strong, nonatomic) TimeCollectionViewController *timeCollectionVC;

@end

@implementation LEOSingleAppointmentSchedulerCardVC

@synthesize pageViewDataSource = _pageViewDataSource;

static NSString * const dateReuseIdentifier = @"DateCell";

- (void)viewDidLoad {
    [super viewDidLoad];

    self.coreDataManager = [LEOCoreDataManager sharedManager];

    [self setupDateCollectionView];
    [self setupPageView];
    [self setupMonthLabel];
    
    
}

-(void)viewDidLayoutSubviews {
    [self selectInitialCell];
}

- (void)selectInitialCell {
 
    NSInteger indexForDate = [self.selectedDate daysFrom:[NSDate date]] + 1;
    NSIndexPath *indexPathForDate = [NSIndexPath indexPathForRow:indexForDate inSection:0];
    
    NSArray *visibleIndexPaths = [self.dateCollectionView indexPathsForVisibleItems];

    if (![visibleIndexPaths containsObject:indexPathForDate]) {
        
        [self.dateCollectionView scrollToItemAtIndexPath:indexPathForDate atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
        CGPoint point = self.dateCollectionView.contentOffset;
        
        CGSize cellSize = [self collectionView:self.dateCollectionView layout:self.dateCollectionView.collectionViewLayout sizeForItemAtIndexPath:indexPathForDate];
        
        UIEdgeInsets insets = [self collectionView:self.dateCollectionView layout:self.dateCollectionView.collectionViewLayout insetForSectionAtIndex:indexPathForDate.section];
        
        //FIXME: This is a placeholder for an appropriate offset.
        NSInteger multiplierForOffset = fabs(self.selectedDate.weekday - [NSDate date].weekday);
        point .x -= multiplierForOffset * (cellSize.width + insets.left + insets.right) + (insets.left * 3/2);
        self.dateCollectionView.contentOffset = point;
        [self.dateCollectionView reloadData];
    }
}

- (void)setupMonthLabel {
    self.monthLabel.textColor = [UIColor leoWarmHeavyGray];
    self.monthLabel.font = [UIFont leoTitleBasicFont];
    
    NSDateFormatter *monthYearFormatter = [[NSDateFormatter alloc] init];
    monthYearFormatter.dateFormat = @"MMMM' 'YYYY";
    self.monthLabel.text = [monthYearFormatter stringFromDate:self.selectedDate];
}

-(void)setSelectedDate:(NSDate *)selectedDate {
    
    if (_selectedDate != selectedDate) {
        _selectedDate = selectedDate;
        [self setupMonthLabel];
    }
}

- (void)setupPageView {
    
    self.pageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PageViewController"];
    self.pageViewController.dataSource = self.pageViewDataSource;
    self.pageViewController.delegate = self;
    
    [self fillPageWithTimeContentAndDirection:UIPageViewControllerNavigationDirectionForward];
    
    [self addChildViewController:self.pageViewController];
    [self.containerView addSubview:self.pageViewController.view];
    
    // Set the page view controller's bounds using an inset rect so that self's view is visible around the edges of the pages.
    //TODO: Override this and make it such that it fits in two or three columns on the screen *using autolayout*.
    CGRect pageViewRect = self.containerView.bounds;
    self.pageViewController.view.frame = pageViewRect;
    
    [self.pageViewController didMoveToParentViewController:self];
    
    //TODO: Should this really be done to bring the gestures forward?
    self.view.gestureRecognizers = self.pageViewController.gestureRecognizers;
}

- (void)fillPageWithTimeContentAndDirection:(UIPageViewControllerNavigationDirection)direction {
    
    TimeCollectionViewController *timeCollectionVC = [self.storyboard instantiateViewControllerWithIdentifier:@"TimeCollectionViewController"];
    timeCollectionVC.selectedDate = self.selectedDate;
    self.timeCollectionVC = timeCollectionVC;

    [self.pageViewController setViewControllers:@[timeCollectionVC] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:^(BOOL finished) {
    }];

    
}



- (PageViewDataSource *)pageViewDataSource {
    // Return the model controller object, creating it if necessary.
    // In more complex implementations, the model controller may be passed to the view controller.
    if (!_pageViewDataSource) {
        _pageViewDataSource = [[PageViewDataSource alloc] initWithItems:self.dates];
    }
    return _pageViewDataSource;
}

- (void)setupDateCollectionView {
    
    self.selectedDate = [NSDate dateWithYear:2015 month:6 day:14];
   
    void (^configureCell)(LEODateCell *, NSDate*) = ^(LEODateCell* cell, NSDate* date) {
        
        cell.dateLabel.text = [@(date.day) stringValue];
        
        NSDateFormatter *weekdayFormatter = [[NSDateFormatter alloc] init];
        weekdayFormatter.dateFormat = @"EEE";
        
        cell.dayOfDateLabel.text = [[weekdayFormatter stringFromDate:date] uppercaseString];
        
        if ([date isEarlierThanOrEqualTo:self.selectedDate.endOfDay] && [date isLaterThanOrEqualTo:self.selectedDate.beginningOfDay] ) {
            cell.selected = YES;
//            self.selectedDate = date;
        }
        else {
            cell.selected = NO;
        }
        
    };
    
    self.dataSource = [[CollectionViewDataSource alloc] initWithItems:self.dates cellIdentifier:dateReuseIdentifier configureCellBlock:configureCell];
    
    self.dateCollectionView.dataSource = self.dataSource;
    self.dateCollectionView.delegate = self;
    self.dateCollectionView.backgroundColor = [UIColor leoWarmLightGray];
    self.dateCollectionView.pagingEnabled = YES;
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    [flowLayout setMinimumInteritemSpacing:10.0f];
    [flowLayout setMinimumLineSpacing:10.0f];
    self.dateCollectionView.collectionViewLayout = flowLayout;
    
    [self.dateCollectionView registerNib:[UINib nibWithNibName:@"LEODateCell" bundle:nil] forCellWithReuseIdentifier:dateReuseIdentifier];
    
}

- (IBAction)cancelTapped:(UIBarButtonItem *)sender {
    
    [self.presentingViewController dismissViewControllerAnimated:YES completion:^{
        [UIView animateWithDuration:0.2 animations:^{
            self.collapsedCell.layer.transform = CATransform3DMakeRotation(0,0.0,1.0,0.0); ; //flip halfway
            self.collapsedCell.selected = NO;
        }];
    }];
}





#pragma mark - Helper Methods

- (NSArray *)dates {
    
    if (!_dates || [_dates count] < 180) {
        
        NSMutableArray *dateArray = [[NSMutableArray alloc] init];
        
        NSDate *lastDate = [[NSDate date] dateByAddingDays:180];
        
        NSDate *dateToAdd = [NSDate date];
        
        while ([dateToAdd timeIntervalSinceDate:lastDate] < 0) {
            [dateArray addObject:dateToAdd];
            dateToAdd = [dateToAdd dateByAddingDays:1];
        }
        
        _dates = dateArray;
        
    }
    
    return _dates;
}


#pragma mark - <UICollectionViewDelegate>

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    
    NSInteger indexForDate = [self.selectedDate daysFrom:[NSDate date]] + 1;
    self.selectedDate = self.dates[indexPath.row];
    
    UIPageViewControllerNavigationDirection direction;
    
    if (indexPath.row > indexForDate) {
        direction = UIPageViewControllerNavigationDirectionForward;
    } else {
        direction = UIPageViewControllerNavigationDirectionReverse;
    }
    
    if (indexPath.row != indexForDate) {
        [self fillPageWithTimeContentAndDirection:direction];
    }
    
    [self.dateCollectionView reloadData];

}

#pragma mark - <UICollectionViewDelegateFlowLayout>


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake((self.view.frame.size.width - 70)/7.0, 41.0);
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0,5,0,5);
}




#pragma mark - <UPageViewControllerDelegate>

-(void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray *)pendingViewControllers {
    self.tempSelectedDate = ((TimeCollectionViewController *)pendingViewControllers[0]).selectedDate;
}

-(void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed {
    
    
    if (completed) {
        
        self.selectedDate = self.tempSelectedDate;
        
        NSInteger indexForDate = [self.selectedDate daysFrom:[NSDate date]] + 1;
        NSIndexPath *indexPathForDate = [NSIndexPath indexPathForRow:indexForDate inSection:0];
        
        NSArray *visibleIndexPaths = [self.dateCollectionView indexPathsForVisibleItems];
        
        NSSortDescriptor *rowDescriptor = [[NSSortDescriptor alloc] initWithKey:@"row" ascending:YES];
        NSArray *sortedRows = [visibleIndexPaths sortedArrayUsingDescriptors:@[rowDescriptor]];
        
        if (![visibleIndexPaths containsObject:indexPathForDate]) {
            if (indexPathForDate < (NSIndexPath *)visibleIndexPaths[0]) {
                [self.dateCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:((NSIndexPath *)sortedRows.firstObject).row - 7 inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
                
                [self.dateCollectionView layoutIfNeeded];
                
                CGPoint point = self.dateCollectionView.contentOffset;
                
                UIEdgeInsets insets = [self collectionView:self.dateCollectionView layout:self.dateCollectionView.collectionViewLayout insetForSectionAtIndex:indexPathForDate.section];
                
                point.x -= insets.right;
                self.dateCollectionView.contentOffset = point;
            }
            else if (indexPathForDate > (NSIndexPath *)visibleIndexPaths.lastObject) {
                [self.dateCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:((NSIndexPath *)sortedRows.lastObject).row + 7 inSection:0] atScrollPosition:UICollectionViewScrollPositionRight animated:YES];
                
                
                [self.dateCollectionView layoutIfNeeded];
                
                CGPoint point = self.dateCollectionView.contentOffset;
                
                UIEdgeInsets insets = [self collectionView:self.dateCollectionView layout:self.dateCollectionView.collectionViewLayout insetForSectionAtIndex:indexPathForDate.section];
                
                point.x += insets.left;
                self.dateCollectionView.contentOffset = point;
            }
        }
        
        
        //        [self.dateCollectionView layoutIfNeeded];
        
        [self.dateCollectionView reloadData];
    }
    
    
}


//- (NSInteger)requiredHeightForTimeCollectionView {
//
//    NSInteger cellSize = 50; //FIXME: This should not be hardcoded!
//
//    return ceil([[self.coreDataManager availableTimesForDate:self.selectedDate] count] * cellSize / 3.0);
//}

//-(void)updateViewConstraints {
//    
//    [super updateViewConstraints];

    //    NSLayoutConstraint *leadingDateCollectionViewConstraint = [NSLayoutConstraint constraintWithItem:self.dateCollectionView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0];
    //
    //    NSLayoutConstraint *trailingDateCollectionViewConstraint = [NSLayoutConstraint constraintWithItem:self.dateCollectionView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0];
    //
    //    [self.contentView addConstraint:leadingDateCollectionViewConstraint];
    //    [self.contentView addConstraint:trailingDateCollectionViewConstraint];
    //
    //    NSLayoutConstraint *leadingContainerViewConstraint = [NSLayoutConstraint constraintWithItem:self.containerView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0];
    //
    //    NSLayoutConstraint *trailingContainerViewConstraint = [NSLayoutConstraint constraintWithItem:self.containerView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0];
    //
    //    [self.view addConstraint:leadingContainerViewConstraint];
    //    [self.view addConstraint:trailingContainerViewConstraint];
    //
    //    NSLayoutConstraint *leadingMonthLabelConstraint = [NSLayoutConstraint constraintWithItem:self.monthLabel attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0];
    //
    //    NSLayoutConstraint *trailingMonthLabelConstraint = [NSLayoutConstraint constraintWithItem:self.monthLabel attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0];
    //
    //    [self.view addConstraint:leadingMonthLabelConstraint];
    //    [self.view addConstraint:trailingMonthLabelConstraint];
    //
    //    NSLayoutConstraint *leadingButtonViewConstraint = [NSLayoutConstraint constraintWithItem:self.buttonView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0];
    //
    //    NSLayoutConstraint *trailingButtonViewConstraint = [NSLayoutConstraint constraintWithItem:self.buttonView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0];
    //
    //
    //    [self.view addConstraint:leadingButtonViewConstraint];
    //    [self.view addConstraint:trailingButtonViewConstraint];
    
    //self.coreDataManager.
    
//}

//-(NSLayoutConstraint *)containerViewHeightConstraint {
//    
//    if (!_containerViewHeightConstraint) {
//        _containerViewHeightConstraint = [NSLayoutConstraint constraintWithItem:self.containerView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:200];
//        
//        [self.contentView addConstraint:_containerViewHeightConstraint];
//    }
//    
//    return _containerViewHeightConstraint;
//}



/*
 // Uncomment this method to specify if the specified item should be highlighted during tracking
 - (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
 }
 */

/*
 // Uncomment this method to specify if the specified item should be selected
 - (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
 return YES;
 }
 */

/*
 // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
 - (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
 }
 
 - (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
 }
 
 - (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
 }
 */

@end
