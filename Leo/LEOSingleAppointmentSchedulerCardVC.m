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

@interface LEOSingleAppointmentSchedulerCardVC ()

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) TimeCollectionViewController *timeCollectionView;
@property (weak, nonatomic) IBOutlet UICollectionView *dateCollectionView;
@property (weak, nonatomic) IBOutlet UILabel *monthLabel;

@property (strong, nonatomic) ArrayDataSource *arrayDataSource;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;

@property (strong, nonatomic) LEOCoreDataManager *coreDataManager;
@property (strong, nonatomic) NSDate *selectedDate;
@property (weak, nonatomic) IBOutlet UIView *contentView;

@property (strong, nonatomic) NSArray *dates;

@property (readonly, strong, nonatomic) PageViewDataSource *pageViewDataSource;

@end

@implementation LEOSingleAppointmentSchedulerCardVC

@synthesize pageViewDataSource = _pageViewDataSource;

static NSString * const dateReuseIdentifier = @"DateCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupDateCollectionView];
    [self setupPageView];
    [self setupMonthLabel];
    
    self.coreDataManager = [LEOCoreDataManager sharedManager];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
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

    self.timeCollectionView = [self.storyboard instantiateViewControllerWithIdentifier:@"TimeCollectionViewController"];
    self.timeCollectionView.selectedDate = self.selectedDate;
    
    NSArray *viewControllers = @[self.timeCollectionView];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    self.pageViewController.dataSource = self.pageViewDataSource;
    
    [self addChildViewController:self.pageViewController];
    [self.containerView addSubview:self.pageViewController.view];
    
    // Set the page view controller's bounds using an inset rect so that self's view is visible around the edges of the pages.
    //TODO: Override this and make it such that it fits in two or three columns on the screen...
    CGRect pageViewRect = self.containerView.bounds;
    self.pageViewController.view.frame = pageViewRect;
    
    [self.pageViewController didMoveToParentViewController:self];
    
    // Add the page view controller's gesture recognizers to the book view controller's view so that the gestures are started more easily.
    self.view.gestureRecognizers = self.pageViewController.gestureRecognizers;
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

    self.dateCollectionView.dataSource = self;
    self.dateCollectionView.delegate = self;
    self.dateCollectionView.backgroundColor = [UIColor leoWarmLightGray];
    self.dateCollectionView.pagingEnabled = YES;
    [self.dateCollectionView registerNib:[UINib nibWithNibName:@"LEODateCell" bundle:nil] forCellWithReuseIdentifier:dateReuseIdentifier];
    
    NSInteger indexForDate = [self.selectedDate daysFrom:[NSDate date]] + 1;
    NSIndexPath *indexPathForDate = [NSIndexPath indexPathForRow:indexForDate inSection:0];
    [self.dateCollectionView scrollToItemAtIndexPath:indexPathForDate atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
    [self.dateCollectionView layoutIfNeeded];
}

- (IBAction)cancelTapped:(UIButton *)sender {
    
    [self.presentingViewController dismissViewControllerAnimated:YES completion:^{
        [UIView animateWithDuration:0.2 animations:^{
            self.collapsedCell.layer.transform = CATransform3DMakeRotation(0,0.0,1.0,0.0); ; //flip halfway
            self.collapsedCell.selected = NO;
        }];
    }];
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

        self.selectedDate = self.dates[indexPath.row];
        [self.timeCollectionView.collectionView reloadData];
        [self.dateCollectionView reloadData]; //FIXME: Smelly.
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
        return [[self dates] count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
        LEODateCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:dateReuseIdentifier forIndexPath:indexPath];
        
        NSDate *date = self.dates[indexPath.row];
        
        cell.dateLabel.text = [@(date.day) stringValue];
        
        NSDateFormatter *weekdayFormatter = [[NSDateFormatter alloc] init];
        weekdayFormatter.dateFormat = @"EEE";
        
        cell.dayOfDateLabel.text = [[weekdayFormatter stringFromDate:date] uppercaseString];
        
       if (date.weekday == self.selectedDate.weekday) {
           cell.selected = YES;
           self.selectedDate = date;
       }
       else {
           cell.selected = NO;
       }
    return cell;
}


- (NSArray *)availableTimesForDate:(NSDate*)date {
    
    NSDate *beginningOfDay = [NSDate dateWithYear:date.year month:date.month day:date.day hour:0 minute:0 second:0];
    
    NSDate *endOfDay = [NSDate dateWithYear:date.year month:date.month day:date.day hour:23 minute:59 second:59];
    
    NSMutableArray *timesForDate = [[NSMutableArray alloc] init];
    
    for (NSDate *availableTime in self.coreDataManager.availableTimes) {
        
        if ( ([beginningOfDay timeIntervalSince1970] < [availableTime timeIntervalSince1970]) && ( [availableTime timeIntervalSince1970] < [endOfDay timeIntervalSince1970])){
            
            [timesForDate addObject:availableTime];
        }
    }
    
    return timesForDate;
}

#pragma mark <UICollectionViewDelegate>

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

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
        return CGSizeMake(41.0, 41.0);
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
        return UIEdgeInsetsMake(0,0,0,0);
}

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

@end
