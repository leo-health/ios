//
//  LEOSingleAppointmentSchedulerCardVC.m
//  Leo
//
//  Created by Zachary Drossman on 5/14/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import "LEOAppointmentSchedulingCardVC.h"
#import "LEOCoreDataManager.h"
#import <NSDate+DateTools.h>
#import "LEOTimeCell.h"
#import "UIFont+LeoFonts.h"
#import "ArrayDataSource.h"
#import "LEODateCell.h"
#import "UIColor+LeoColors.h"
#import "PageViewDataSource.h"
#import "NSDate+Extensions.h"
#import "CollectionViewDataSource.h"
#import "LEODateCell+ConfigureCell.h"
#import "LEODropDownController.h"
#import "LEODropDownTableView.h"
#import "LEOCardScheduling.h"
#import "LEOSectionSeparator.h"
#import "LEOChildDropDownTableViewController.h"

@interface LEOAppointmentSchedulingCardVC ()

#pragma mark - IBOutlets
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UICollectionView *dateCollectionView;
@property (weak, nonatomic) IBOutlet UILabel *monthLabel;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *cancelButton;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UINavigationBar *navBar;
@property (weak, nonatomic) IBOutlet LEODropDownTableView *doctorDropDownTV;
@property (weak, nonatomic) IBOutlet LEODropDownTableView *visitDropDownTV;
@property (weak, nonatomic) IBOutlet UIButton *bookButton;
@property (weak, nonatomic) IBOutlet UILabel *patientLabel;
@property (weak, nonatomic) IBOutlet UILabel *appointmentTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *providerLabel;
@property (weak, nonatomic) IBOutlet UILabel *appointmentLabel;
@property (weak, nonatomic) IBOutlet UILabel *appointmentDateLabel;

#pragma mark - Data
@property (strong, nonatomic) Appointment *appointment;
@property (strong, nonatomic) NSDate *selectedDate;
@property (strong, nonatomic) NSDate *tempSelectedDate;
@property (strong, nonatomic) NSArray *dates;
@property (strong, nonatomic) NSLayoutConstraint *containerViewHeightConstraint;
@property (strong, nonatomic) LEODropDownController *doctorDropDownController;
@property (strong, nonatomic) LEODropDownController * visitTypeDropDownController;

#pragma mark - Helper classes
@property (strong, nonatomic) ArrayDataSource *arrayDataSource;
@property (strong, nonatomic) CollectionViewDataSource *dataSource;
@property (strong, nonatomic) LEOCoreDataManager *coreDataManager;
@property (strong, nonatomic) PageViewDataSource *pageViewDataSource;

#pragma mark - State
@property (strong, nonatomic) TimeCollectionViewController *timeCollectionVC;
@property (nonatomic) BOOL initialScrollDone;
@property (nonatomic) BOOL startingContentOffsetX;
@property (nonatomic) BOOL alreadyTurnedPage;

@end

@implementation LEOAppointmentSchedulingCardVC

static NSString * const dateReuseIdentifier = @"DateCell";



#pragma mark - View Controller Lifecycle

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self prepareForLaunch];

    [self setupDateCollectionView];
    
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self.dateCollectionView layoutIfNeeded];
//    [self goToStartingDate];
}

- (void)prepareForLaunch {
    
    self.doctorDropDownController = [[LEODropDownController alloc] initWithTableView:self.doctorDropDownTV items:[self.coreDataManager fetchDoctors] usingDescriptorKey:@"fullName" associatedCardObject:self.card.associatedCardObject associatedCardObjectPropertyDescriptor:@"provider"];
    
    //TODO: Remove hard coded options and move to DataManager.
    self.visitTypeDropDownController = [[LEODropDownController alloc] initWithTableView:self.visitDropDownTV items:[self.coreDataManager fetchAppointmentTypes] usingDescriptorKey:@"typeDescriptor" associatedCardObject:self.card.associatedCardObject associatedCardObjectPropertyDescriptor:@"leoAppointmentType"];
    
    [self.view setNeedsLayout];
    
    self.card.delegate = self;
    
    NSString *buttonTitle = [self.card stringRepresentationOfActionsAvailableForState][0];
    
    [self.bookButton setTitle:[buttonTitle uppercaseString] forState:UIControlStateNormal];
    [self.bookButton addTarget:self.card action:NSSelectorFromString([self.card actionsAvailableForState][0]) forControlEvents:UIControlEventTouchUpInside];
    self.bookButton.backgroundColor = [UIColor leoOrangeRed];
    [self.bookButton setTitleColor:[UIColor leoWhite] forState:UIControlStateNormal];
    self.bookButton.titleLabel.font = [UIFont leoBodyBoldFont];
    
    self.providerLabel.textColor = [UIColor leoWarmHeavyGray];
    self.patientLabel.textColor = [UIColor leoWarmHeavyGray];
    self.appointmentTypeLabel.textColor = [UIColor leoWarmHeavyGray];
    self.appointmentLabel.textColor = [UIColor leoWarmHeavyGray];
    self.appointmentDateLabel.textColor = [UIColor leoOrangeRed];
    
    UINavigationItem *navCarrier = [[UINavigationItem alloc] init];
    
    UIImageView *iconImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"SMS-32"]];
    UIBarButtonItem *icon = [[UIBarButtonItem alloc] initWithCustomView:iconImageView];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 300, 44)];
    titleLabel.text = @"Schedule An Appointment";
    titleLabel.font = [UIFont leoTitleBasicFont];
    titleLabel.textColor = [UIColor leoWarmHeavyGray];
    UIBarButtonItem *title = [[UIBarButtonItem alloc] initWithCustomView:titleLabel];
    
    navCarrier.leftBarButtonItems = @[icon, title];
    
    self.navBar.items = @[navCarrier];
    
    if (self.appointment.date == nil) {
        self.selectedDate = [self firstAvailableAppointmentTimeFromDate:nil toDate:nil];
    }
    
    [self setupMonthLabel];
    [self setupAppointmentDateLabel];

}

- (void)goToStartingDate {
    
    [self.dateCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow: [self indexPathOfDate:self.appointment.date].row inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
}


#pragma mark - Lifecycle Helper Methods
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

- (void)setupMonthLabel {
    
    self.monthLabel.textColor = [UIColor leoWarmHeavyGray];
    self.monthLabel.font = [UIFont leoTitleBasicFont];
    
    [self updateMonthLabel];
}

- (void)updateMonthLabel {
    
    NSDateFormatter *monthYearFormatter = [[NSDateFormatter alloc] init];
    monthYearFormatter.dateFormat = @"MMMM' 'YYYY";
    self.monthLabel.text = [monthYearFormatter stringFromDate:self.appointment.date];
}

- (void)setupAppointmentDateLabel {
    
    self.monthLabel.textColor = [UIColor leoWarmHeavyGray];
    self.monthLabel.font = [UIFont leoTitleBasicFont];
    
    [self updateAppointmentDateLabel];
}

- (void)updateAppointmentDateLabel {
    
    self.appointmentDateLabel.text = [self formatDateTimeForLabel:self.appointment.date];
}

- (NSString *)formatDateTimeForLabel:(NSDate *)dateTime {
    
    NSDateFormatter *fullDateFormatter = [[NSDateFormatter alloc] init];
    fullDateFormatter.dateFormat = @"MMMM' 'd', 'h':'mma";
    [fullDateFormatter setAMSymbol:@"am"];
    [fullDateFormatter setPMSymbol:@"pm"];
    NSString *formattedDateTime = [fullDateFormatter stringFromDate:dateTime];
    
    return formattedDateTime;
}



#pragma mark - Setup, Getters, Setters

- (Appointment *)appointment {
    return self.card.associatedCardObject;
}



#pragma mark - Segue and segue helper methods
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    self.coreDataManager = [LEOCoreDataManager sharedManager];
    
    if ([segue.identifier isEqualToString:@"EmbedSegue"]) {
        [self baseViewSetup]; //TODO: See 'MARK' above the implementation of this method.
        self.pageViewController = segue.destinationViewController;
        [self setupPageView];
    }
    
    if([segue.identifier isEqualToString:@"ChildDropDownEmbedSegue"]) {
        LEOChildDropDownTableViewController *tvc = segue.destinationViewController;
        tvc.appointment = self.appointment;
        tvc.children = [self.coreDataManager fetchChildren];
    }
}

/* Zachary Drossman
 * MARK: I take issue with the fact
 * that we can only set these things
 * up in our segue because it gets
 * called before view did load.
 * There has to be a better way.
 */

- (void)baseViewSetup {
    
    self.pageViewDataSource = [[PageViewDataSource alloc] initWithAllItems:self.dates selectedSubsetOfItems:self.coreDataManager.availableDates];
}

- (void)setupPageView {
    
    self.pageViewController.dataSource = self.pageViewDataSource;
    self.pageViewController.delegate = self;
    
    // Set the page view controller's bounds using an inset rect so that self's view is visible around the edges of the pages.
    //TODO: Override this and make it such that it fits in three columns on the screen *using autolayout*.
    CGRect pageViewRect = self.containerView.bounds;
    self.pageViewController.view.frame = pageViewRect;
    
    //MARK: Should this really be done to bring the gestures forward?
    //self.view.gestureRecognizers = self.pageViewController.gestureRecognizers;
    
    
}

- (void)turnToPage:(NSInteger)toPage fromPage:(NSInteger )fromPage {
    
    TimeCollectionViewController *timeCollectionVC = [self.pageViewDataSource viewControllerAtIndex:[self indexPathOfDate:self.appointment.date].row storyboard:self.storyboard];
    
    self.timeCollectionVC = timeCollectionVC;

    self.timeCollectionVC.delegate = self;
    UIPageViewControllerNavigationDirection direction;
    
    if (fromPage < toPage) {
        direction = UIPageViewControllerNavigationDirectionForward;
    } else {
        direction = UIPageViewControllerNavigationDirectionReverse;
        
    }
    
    [self.pageViewController setViewControllers:@[timeCollectionVC] direction:direction animated:NO completion:nil];
    
}

- (NSIndexPath *)indexPathOfDate:(NSDate *)date {
    
    NSInteger daysFromBeginningOfDateArray;
    
    if (self.appointment.date) {
        daysFromBeginningOfDateArray = [[self.appointment.date beginningOfDay] daysFrom:self.dates.firstObject];
    } else {
        daysFromBeginningOfDateArray = [self.coreDataManager.availableDates.firstObject daysFrom:self.dates.firstObject];
    }
    
    NSLog(@"daysFromBeginningOfDate: %ld",(long)daysFromBeginningOfDateArray);
    return [NSIndexPath indexPathForRow:daysFromBeginningOfDateArray inSection:0];
}


//MARK: Can we remove / condense this and the above into one?
//- (NSIndexPath *)indexPathForSelectedDate {
//    
//    NSUInteger indexForSelectedDate = [self.appointment.date daysFrom:[self startDate]];
//    NSIndexPath *indexPathForDate = [NSIndexPath indexPathForRow:indexForSelectedDate inSection:0];
//    return indexPathForDate;
//}

- (NSUInteger)pageOfDate:(NSDate *)date {
    
    NSUInteger page = floor([self indexPathOfDate:date].row / 7.0);
    return page;
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

//FIXME: Shouldn't be using selectedDate for side effects. Create another method.
-(void)setSelectedDate:(NSDate *)selectedDate {
    self.appointment.date = selectedDate;
    
    [self updateMonthLabel];
    [self updateAppointmentDateLabel];
}

- (BOOL)shouldTurnPage {
 
    NSArray *visibleIndexPaths = [[self.dateCollectionView indexPathsForVisibleItems] sortedArrayUsingSelector:@selector(compare:)];
    
    if ([visibleIndexPaths containsObject:[self indexPathOfDate:self.appointment.date]]) {
        return NO;
    }
    
    return YES;
}


#pragma mark - <UICollectionViewDelegate>
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self updateCollectionView:collectionView forSelectedCellAtIndexPath:indexPath];
    [self turnToPage:[self pageOfDate:self.appointment.date] fromPage:0];
}

- (void)updateCollectionView:(UICollectionView *)collectionView forSelectedCellAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger indexForCurrentDate = [self.appointment.date daysFrom:[self startDate]];
    
    self.selectedDate = self.dates[indexPath.row];
    
    [collectionView selectItemAtIndexPath:indexPath animated:NO scrollPosition:UICollectionViewScrollPositionNone];
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    cell.selected = YES;
    
    [collectionView layoutIfNeeded];

}

-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    LEODateCell *cell = (LEODateCell *)[collectionView cellForItemAtIndexPath:indexPath];
    
    if (cell.selectable) {
        return YES;
    }
    
    return NO;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    
    cell.selected = NO;
    
    NSDate *date = self.dates[indexPath.row];
    
    NSCalendar *calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    
    if ([calendar isDate:date inSameDayAsDate:self.appointment.date]) {
        if (!self.initialScrollDone) {
            cell.selected = YES;
            [collectionView selectItemAtIndexPath:indexPath animated:NO scrollPosition:UICollectionViewScrollPositionNone];
            [self updateCollectionView:collectionView forSelectedCellAtIndexPath:indexPath]; //FIXME: This is frustrating that I have to update directly in willDisplay but this method is duplicating what is already done here...
            
            if ([self shouldTurnPage]) {
                [self turnToPage:[self pageOfDate:self.appointment.date] fromPage:0];
            }
            
            self.selectedDate = date;
        } else {
            ((LEODateCell *)cell).selectable = YES;
        }
    } else {

        NSArray *availableSlotsForDate = [self.coreDataManager availableTimesForDate:date];
        
        if ([availableSlotsForDate count] > 0) {
            
            ((LEODateCell *)cell).selectable = YES;
        } else {
            
            ((LEODateCell *)cell).selectable = NO;
        }
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView {
    [self updateSelectedCellBasedOnScrollViewUpdate:scrollView];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    self.startingContentOffsetX = scrollView.contentOffset.x;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self updateSelectedCellBasedOnScrollViewUpdate:scrollView];
}

- (void)updateSelectedCellBasedOnScrollViewUpdate:(UIScrollView *)scrollView {
    
    if (self.startingContentOffsetX != scrollView.contentOffset.x) {
        self.initialScrollDone = YES;
    }
    
    NSArray *indexPathsOfVisibleItems = [[self.dateCollectionView indexPathsForVisibleItems] sortedArrayUsingSelector:@selector(compare:)];
    
    for (NSIndexPath *indexPath in indexPathsOfVisibleItems) {
        LEODateCell *cell = (LEODateCell *)[self.dateCollectionView cellForItemAtIndexPath:indexPath];
        
        if (cell.selectable) {
            cell.selected = YES;
            [self updateCollectionView:self.dateCollectionView forSelectedCellAtIndexPath:indexPath];
            [self turnToPage:[self pageOfDate:self.appointment.date] fromPage:0];
            break;
        }
    }
}

#pragma mark - <UICollectionViewDelegateFlowLayout>

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return CGSizeMake((self.view.frame.size.width - 70)/7.0, 55.0);
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    return UIEdgeInsetsMake(10,5,10,5);
}



#pragma mark - <UPageViewControllerDelegate>

- (void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray *)pendingViewControllers {
    
    self.tempSelectedDate = ((TimeCollectionViewController *)pendingViewControllers[0]).selectedDate;
}


//TODO: Separate out into multiple smaller methods.
- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed {
    
    if (completed) {
        
        self.selectedDate = self.tempSelectedDate;
        
        NSArray *visibleIndexPaths = [[self.dateCollectionView indexPathsForVisibleItems] sortedArrayUsingSelector:@selector(compare:)];
        
        NSIndexPath *indexPathToSelect;
        NSIndexPath *indexPathOfAppointment = [self indexPathOfDate:self.appointment.date];

        CGPoint point = self.dateCollectionView.contentOffset;
        UIEdgeInsets insets = [self collectionView:self.dateCollectionView layout:self.dateCollectionView.collectionViewLayout insetForSectionAtIndex:indexPathOfAppointment.section]; //Not using scroll to cell here because for whatever reason, and we should go back and determine why someday, it is leaving an eight cell visible which is messing with everything. Probably due to the very manual sizing of cell layout, but using insets does appear to work as an alternative so I'm not 100% sure what is going on.

        if (![visibleIndexPaths containsObject:indexPathOfAppointment]) {
            
            if ( indexPathOfAppointment < (NSIndexPath *)visibleIndexPaths[0]) {
                point.x -= insets.right;
            } else if (indexPathOfAppointment > (NSIndexPath *)visibleIndexPaths.lastObject) {
                point.x += insets.left;
            }
            
            self.dateCollectionView.contentOffset = point;

            NSIndexPath *indexPath = visibleIndexPaths.lastObject;
            NSDate *firstAvailableDateInWeek = [self firstAvailableAppointmentTimeFromDate:self.dates[indexPath.row + 1] toDate:self.dates[indexPath.row + 7]];
            
            if (firstAvailableDateInWeek != nil) {
                indexPathToSelect = [self indexPathOfDate:firstAvailableDateInWeek];
            }
        }
        else {
            indexPathToSelect = [self indexPathOfDate:self.appointment.date];
        }
        
        UICollectionViewCell *cell = [self.dateCollectionView cellForItemAtIndexPath:indexPathToSelect];
        [self.dateCollectionView selectItemAtIndexPath:indexPathToSelect animated:NO scrollPosition:UICollectionViewScrollPositionNone];
        cell.selected = YES;
        
        [self.dateCollectionView layoutIfNeeded];
        [self.dateCollectionView reloadData];
    }
}



#pragma mark - <TimeSelectionDelegate>
- (void)didUpdateAppointmentDateTime:(NSDate *)dateTime {
    
    self.selectedDate = [self firstAvailableAppointmentTimeFromDate:dateTime toDate:dateTime];
    
//    self.appointmentDateLabel.text = [self formatDateTimeForLabel:dateTime];
}



#pragma mark - <CardActivityDelegate>
- (void)didUpdateObjectStateForCard:(LEOCard *)card {
    
    [self.presentingViewController dismissViewControllerAnimated:YES completion:^{
        [UIView animateWithDuration:0.2 animations:^{
            // self.collapsedCell.layer.transform = CATransform3DMakeRotation(0,0.0,1.0,0.0); ; //flip halfway
            self.collapsedCell.selected = NO;
        }];
    }];
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

//MARK: Strategically, at scale this may not make sense, but with a few patients, we can probably do this and not engage too many conflicts.
- (NSDate *)firstAvailableAppointmentTimeFromDate:(NSDate *)fromDate toDate:(NSDate *)toDate {
    
    NSUInteger fromDateIndex;
    NSUInteger toDateIndex;
    
    if (fromDate == nil) {
        fromDateIndex = 0;
    } else {
        fromDateIndex = [self findIndexForExactDate:fromDate inArray:self.dates];
    }
    if (toDate == nil) {
        toDateIndex = [self.dates count] - 1;
    } else {
        toDateIndex = [self findIndexForExactDate:toDate inArray:self.dates];
    }
    
    NSArray *dateSubarray = [self.dates subarrayWithRange:NSMakeRange(fromDateIndex, toDateIndex + 1)]; //MARK: Remind myself why I have to add +1 to this.
    
    for (NSInteger i = fromDateIndex; i <= toDateIndex; i++) {
        
        NSArray *availableTimes = [self.coreDataManager availableTimesForDate:dateSubarray[i]];
        
        if ([availableTimes count] > 0) {
            return availableTimes[0];
        }
    }
    
    return nil;
    
    //TODO: Need to deal with rare case in which no dates have availability so app doesn't crash here. I really hope we crash for this reason someday though...
}


- (NSUInteger)findIndexForExactDate:(NSDate *)date inArray:(NSArray *)array {
    
    for (NSInteger i = 0; i < [array count]; i++) {
        if ([date isEqualToDate:array[i]]) {
            return i;
        }
    }
    
    ALog(@"Warning: Couldn't find index for exact date.");
    return 0; //TODO: Deal with this.
}

- (NSDate *)startDate {
    
    static NSDate *startDate;
    
    if (!startDate) {
        
        startDate = [[NSDate date].beginningOfDay dateBySubtractingDays:[NSDate date].weekday - 1];
    }
    
    return startDate;
}

@end
