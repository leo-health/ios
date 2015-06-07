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
#import "CirclePhotoView.h"
#import "LEODateCell+ConfigureCell.h"


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
@property (strong, nonatomic) PageViewDataSource *pageViewDataSource;

#pragma mark - State
@property (nonatomic) BOOL dataLoaded;

@property (strong, nonatomic) TimeCollectionViewController *timeCollectionVC;

@end

@implementation LEOSingleAppointmentSchedulerCardVC

//@synthesize pageViewDataSource = _pageViewDataSource;

static NSString * const dateReuseIdentifier = @"DateCell";


#pragma mark - View Controller Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];

    self.selectedDate = [NSDate todayAdjustedForLocalTimeZone];
    self.coreDataManager = [LEOCoreDataManager sharedManager];

    self.pageViewDataSource = [[PageViewDataSource alloc] initWithItems:self.dates];

    [self setupDateCollectionView];
    [self setupPageView];
    [self setupMonthLabel];
    
//    [self setupFullAppointmentDateLabel];

}

-(void)viewDidAppear:(BOOL)animated {
    self.dataLoaded = YES;
}



#pragma mark - Setup, Getters, Setters

- (void)setupMonthLabel {
    self.monthLabel.textColor = [UIColor leoWarmHeavyGray];
    self.monthLabel.font = [UIFont leoTitleBasicFont];
    
    NSDateFormatter *monthYearFormatter = [[NSDateFormatter alloc] init];
    monthYearFormatter.dateFormat = @"MMMM' 'YYYY";
    self.monthLabel.text = [monthYearFormatter stringFromDate:self.selectedDate];
}

//- (void)setupFullAppointmentDateLabel {
//    self.fullAppointmentDateLabel.textColor = [UIColor leoWarmHeavyGray];
//    self.fullAppointmentDateLabel.font = [UIFont leoTitleBasicFont];
//    
//    NSDateFormatter *fullDateFormatter = [[NSDateFormatter alloc] init];
//    fullDateFormatter.dateFormat = @"MMMM' 'DDD','hh':'mm";
//    self.fullAppointmentDateLabel.text = [fullDateFormatter stringFromDate:((TimeCollectionViewController *)self.pageViewController.viewControllers[0]).selectedDate];
//}


-(void)setSelectedDate:(NSDate *)selectedDate {
    
    if (self.dataLoaded) {
        
        if (_selectedDate != selectedDate) {
            
            NSUInteger indexForPriorSelectedDate = [_selectedDate daysFrom:[self startDate]];
            NSIndexPath *indexPathForPriorSelectedDate = [NSIndexPath indexPathForRow:indexForPriorSelectedDate inSection:0];
            
            _selectedDate = selectedDate;
            
            [self setupMonthLabel];
            
            [self.dateCollectionView reloadItemsAtIndexPaths:@[[self indexPathForSelectedDate], indexPathForPriorSelectedDate]];
        }
        //        [self setupFullAppointmentDateLabel];
    }
    _selectedDate = selectedDate;
    [self setupMonthLabel];
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
    
    //MARK: Should this really be done to bring the gestures forward?
    self.view.gestureRecognizers = self.pageViewController.gestureRecognizers;
}

- (void)fillPageWithTimeContentAndDirection:(UIPageViewControllerNavigationDirection)direction {
    
    TimeCollectionViewController *timeCollectionVC = [self.storyboard instantiateViewControllerWithIdentifier:@"TimeCollectionViewController"];
    timeCollectionVC.selectedDate = self.selectedDate;
    self.timeCollectionVC = timeCollectionVC;

    [self.pageViewController setViewControllers:@[timeCollectionVC] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:^(BOOL finished) {
    }];
    
}

- (void)setupDateCollectionView {
    
    void (^configureCell)(LEODateCell *, NSDate*) = ^(LEODateCell* cell, NSDate* date) {
        [cell configureForDate:date];
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


#pragma mark - IBActions

- (IBAction)cancelTapped:(UIBarButtonItem *)sender {
    
    [self.presentingViewController dismissViewControllerAnimated:YES completion:^{
        [UIView animateWithDuration:0.2 animations:^{
            self.collapsedCell.layer.transform = CATransform3DMakeRotation(0,0.0,1.0,0.0); ; //flip halfway
            self.collapsedCell.selected = NO;
        }];
    }];
}




#pragma mark - <UICollectionViewDelegate>

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    
    NSInteger indexForDate = [self.selectedDate daysFrom:[self startDate]] + 1;
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

-(void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDate *date = self.dates[indexPath.row];
    
    if ([date isEarlierThanOrEqualTo:self.selectedDate.endOfDay] && [date isLaterThanOrEqualTo:self.selectedDate.beginningOfDay] ) {
        cell.selected = YES;
    }
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
        
        NSArray *visibleIndexPaths = [self.dateCollectionView indexPathsForVisibleItems];
        
        NSSortDescriptor *rowDescriptor = [[NSSortDescriptor alloc] initWithKey:@"row" ascending:YES];
        NSArray *sortedRows = [visibleIndexPaths sortedArrayUsingDescriptors:@[rowDescriptor]];
        
        if (![visibleIndexPaths containsObject:self.indexPathForSelectedDate]) {
            if (self.indexPathForSelectedDate < (NSIndexPath *)visibleIndexPaths[0]) {
                [self.dateCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:((NSIndexPath *)sortedRows.firstObject).row - 7 inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
                
                [self.dateCollectionView layoutIfNeeded];
                
                CGPoint point = self.dateCollectionView.contentOffset;
                
                UIEdgeInsets insets = [self collectionView:self.dateCollectionView layout:self.dateCollectionView.collectionViewLayout insetForSectionAtIndex:self.indexPathForSelectedDate.section];
                
                point.x -= insets.right;
                self.dateCollectionView.contentOffset = point;
            }
            else if (self.indexPathForSelectedDate > (NSIndexPath *)visibleIndexPaths.lastObject) {
                [self.dateCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:((NSIndexPath *)sortedRows.lastObject).row + 7 inSection:0] atScrollPosition:UICollectionViewScrollPositionRight animated:YES];
                
                
                [self.dateCollectionView layoutIfNeeded];
                
                CGPoint point = self.dateCollectionView.contentOffset;
                
                UIEdgeInsets insets = [self collectionView:self.dateCollectionView layout:self.dateCollectionView.collectionViewLayout insetForSectionAtIndex:self.indexPathForSelectedDate.section];
                
                point.x += insets.left;
                self.dateCollectionView.contentOffset = point;
            }
        }
        
        
        //        [self.dateCollectionView layoutIfNeeded];
        
        [self.dateCollectionView reloadData];
    }
    
    
}


#pragma mark - Helper Date Methods

- (NSArray *)dates {
    
    if (!_dates || [((NSDate *)_dates.firstObject) daysFrom:[self startDate]] != 0) {
        
        NSMutableArray *dateArray = [[NSMutableArray alloc] init];
        
        NSDate *lastDate = [[self startDate] dateByAddingDays:180];
        
        NSDate *dateToAdd = [self startDate];
        
        while ([dateToAdd timeIntervalSinceDate:lastDate] < 0) {
            [dateArray addObject:dateToAdd];
            dateToAdd = [dateToAdd dateByAddingDays:1];
        }
        
        _dates = dateArray;
    }
    
    return _dates;
}


-(NSIndexPath *)indexPathForSelectedDate {
    
    NSUInteger indexForSelectedDate = [self.selectedDate daysFrom:[self startDate]];
    NSIndexPath *indexPathForDate = [NSIndexPath indexPathForRow:indexForSelectedDate inSection:0];
    return indexPathForDate;
}

-(NSDate *)startDate {
    
    static NSDate *startDate;
    
    if (!startDate) {
        
        startDate = [[NSDate todayAdjustedForLocalTimeZone] dateBySubtractingDays:[NSDate todayAdjustedForLocalTimeZone].weekday - 1];
    }
    
    return startDate;
}

@end
