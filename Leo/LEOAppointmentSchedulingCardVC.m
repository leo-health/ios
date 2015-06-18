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
@end

@implementation LEOAppointmentSchedulingCardVC

static NSString * const dateReuseIdentifier = @"DateCell";



#pragma mark - View Controller Lifecycle

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self prepareForLaunch];
    
    [self setupDateCollectionView];
    [self setupMonthLabel];
    
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
    
    [self.view layoutIfNeeded];
    [self setupAppointmentDateLabel];
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
}

- (void)viewWillLayoutSubviews {
    
    if (!self.initialScrollDone) {
        self.initialScrollDone = YES;
        [self goToStartingDate];
    }
}

- (void)prepareForLaunch {
    
    self.doctorDropDownController = [[LEODropDownController alloc] initWithTableView:self.doctorDropDownTV items:[self.coreDataManager fetchDoctors] usingDescriptorKey:@"fullName" associatedCardObject:self.card.associatedCardObject associatedCardObjectPropertyDescriptor:@"provider"];
    
    //TODO: Remove hard coded options and move to DataManager.
    self.visitTypeDropDownController = [[LEODropDownController alloc] initWithTableView:self.visitDropDownTV items:[self.coreDataManager fetchAppointmentTypes] usingDescriptorKey:@"typeDescriptor" associatedCardObject:self.card.associatedCardObject associatedCardObjectPropertyDescriptor:@"leoAppointmentType"];
    
    
    [self.view setNeedsLayout];
}

- (void)goToStartingDate {
    
    NSUInteger pageOfAppointmentDate = floor(self.indexPathOfAppointmentDate.row / 7.0);
    
    [self.dateCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:pageOfAppointmentDate * 7 inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
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
    
    NSDateFormatter *monthYearFormatter = [[NSDateFormatter alloc] init];
    monthYearFormatter.dateFormat = @"MMMM' 'YYYY";
    self.monthLabel.text = [monthYearFormatter stringFromDate:self.appointment.date];
}

- (void)setupAppointmentDateLabel {
    
    self.appointmentDateLabel.text = [self formatDateTimeForLabel:((TimeCollectionViewController *)self.pageViewController.viewControllers[0]).selectedDate];
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
    
    self.pageViewDataSource = [[PageViewDataSource alloc] initWithItems:self.dates];
}

- (void)setupPageView {
    
    self.pageViewController.dataSource = self.pageViewDataSource;
    self.pageViewController.delegate = self;
    
    [self turnToPage:[self indexPathOfAppointmentDate].row fromPage:0];
    
    // Set the page view controller's bounds using an inset rect so that self's view is visible around the edges of the pages.
    //TODO: Override this and make it such that it fits in three columns on the screen *using autolayout*.
    CGRect pageViewRect = self.containerView.bounds;
    self.pageViewController.view.frame = pageViewRect;
    
    //MARK: Should this really be done to bring the gestures forward?
    //self.view.gestureRecognizers = self.pageViewController.gestureRecognizers;
    
}

- (void)turnToPage:(NSInteger)toPage fromPage:(NSInteger )fromPage {
    
    TimeCollectionViewController *timeCollectionVC = [self.pageViewDataSource viewControllerAtIndex:toPage storyboard:self.storyboard];
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

- (NSIndexPath *)indexPathOfAppointmentDate {
    
    NSInteger daysFromBeginningOfDateArray = [[[self appointment] date].beginningOfDay daysFrom:self.dates.firstObject] + 1;
    return [NSIndexPath indexPathForRow:daysFromBeginningOfDateArray inSection:0];
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
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger indexForCurrentDate = [self.appointment.date daysFrom:[self startDate]];
    self.selectedDate = self.dates[indexPath.row]; //MARK: Is this being used even?
    
    if (indexPath.row != indexForCurrentDate) {
        [self turnToPage:indexPath.row fromPage:indexForCurrentDate];
    }
    
    [collectionView selectItemAtIndexPath:indexPath animated:NO scrollPosition:UICollectionViewScrollPositionNone];
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    cell.selected = YES;
    
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDate *date = self.dates[indexPath.row];
    
    NSCalendar *calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    if ([calendar isDate:date inSameDayAsDate:self.appointment.date] ) {
        cell.selected = YES;
        [collectionView selectItemAtIndexPath:indexPath animated:NO scrollPosition:UICollectionViewScrollPositionNone];
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
        
        self.appointment.date = self.tempSelectedDate;
        
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
        
        [self.dateCollectionView reloadData];
    }
}



#pragma mark - <TimeSelectionDelegate>
- (void)didUpdateAppointmentDateTime:(NSDate *)dateTime {
    
    self.appointment.date = dateTime;
    self.appointmentDateLabel.text = [self formatDateTimeForLabel:dateTime];
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

- (NSIndexPath *)indexPathForSelectedDate {
    
    NSUInteger indexForSelectedDate = [self.appointment.date daysFrom:[self startDate]];
    NSIndexPath *indexPathForDate = [NSIndexPath indexPathForRow:indexForSelectedDate inSection:0];
    return indexPathForDate;
}

- (NSDate *)startDate {
    
    static NSDate *startDate;
    
    if (!startDate) {
        
        startDate = [[NSDate todayAdjustedForLocalTimeZone].endOfDay dateBySubtractingDays:[NSDate todayAdjustedForLocalTimeZone].weekday - 1];
    }
    
    return startDate;
}

@end
