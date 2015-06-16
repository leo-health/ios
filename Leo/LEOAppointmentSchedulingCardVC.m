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
#import "LEOListItem.h"
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
@property (weak, nonatomic) IBOutlet UILabel *fullAppointmentDateLabel;
@property (weak, nonatomic) IBOutlet UINavigationBar *navBar;
@property (weak, nonatomic) IBOutlet LEODropDownTableView *doctorDropDownTV;
@property (weak, nonatomic) IBOutlet LEODropDownTableView *visitDropDownTV;
@property (weak, nonatomic) IBOutlet UIButton *bookButton;

@property (weak, nonatomic) IBOutlet UILabel *patientLabel;
@property (weak, nonatomic) IBOutlet UILabel *appointmentTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *providerLabel;



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

    [self.view layoutIfNeeded];
    //    [self setupFullAppointmentDateLabel];
    
}

-(void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    [self goToStartingDate]; //FIXME: At some point we need to find a way for this to happen BEFORE the view appears. (Looks like in iOS8, you can't do this in viewWillAppear. Maybe a bug? But if not, we'll have to figure out another solution.)

}

- (void)prepareForLaunch {
    
    //TODO: Remove these and update with data from server.
    LEOListItem *doc1 = [[LEOListItem alloc] initWithName:@"Om Lala"];
    LEOListItem *doc2 = [[LEOListItem alloc] initWithName:@"Brady Isaacs"];
    LEOListItem *doc3 = [[LEOListItem alloc] initWithName:@"Summer Cece"];
    
    self.doctorDropDownController = [[LEODropDownController alloc] initWithTableView:self.doctorDropDownTV items:@[doc1, doc2, doc3]];
    //TODO: Remove these and update with data from server.
    LEOListItem *visitType1 = [[LEOListItem alloc] initWithName:@"Well"];
    LEOListItem *visitType2 = [[LEOListItem alloc] initWithName:@"Sick"];
    LEOListItem *visitType3 = [[LEOListItem alloc] initWithName:@"Follow-up"];
    
    self.visitTypeDropDownController = [[LEODropDownController alloc] initWithTableView:self.visitDropDownTV items:@[visitType1, visitType2, visitType3]];
    
    [self.view setNeedsLayout];
}

- (void)goToStartingDate {
    
    NSUInteger pageOfAppointmentDate = floor(self.indexPathOfAppointmentDate.row / 7.0);
    
    [self.dateCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:pageOfAppointmentDate * 7 inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
    //[self.dateCollectionView selectItemAtIndexPath:self.indexPathOfAppointmentDate animated:NO scrollPosition:UICollectionViewScrollPositionNone];
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

//TODO: Decide whether we're going to have this in the view, and if so, complete it.
//- (void)setupFullAppointmentDateLabel {
//    self.fullAppointmentDateLabel.textColor = [UIColor leoWarmHeavyGray];
//    self.fullAppointmentDateLabel.font = [UIFont leoTitleBasicFont];
//
//    NSDateFormatter *fullDateFormatter = [[NSDateFormatter alloc] init];
//    fullDateFormatter.dateFormat = @"MMMM' 'DDD','hh':'mm";
//    self.fullAppointmentDateLabel.text = [fullDateFormatter stringFromDate:((TimeCollectionViewController *)self.pageViewController.viewControllers[0]).selectedDate];
//}

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

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    
    NSInteger indexForCurrentDate = [self.appointment.date daysFrom:[self startDate]];
    self.selectedDate = self.dates[indexPath.row];

    if (indexPath.row != indexForCurrentDate) {
        [self turnToPage:indexPath.row fromPage:indexForCurrentDate];
    }
    
    [self.dateCollectionView reloadData];
    
}

-(void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDate *date = self.dates[indexPath.row];
    
    if ([date isEarlierThanOrEqualTo:[self appointment].date.endOfDay] && [date isLaterThanOrEqualTo:[self appointment].date.beginningOfDay] ) {
        cell.selected = YES;
        [collectionView selectItemAtIndexPath:indexPath animated:NO scrollPosition:UICollectionViewScrollPositionNone];
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


//TODO: Separate out into multiple smaller methods.
-(void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed {
    
    
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
        
        
        //        [self.dateCollectionView layoutIfNeeded];
        
        [self.dateCollectionView reloadData];
    }
    
    
}

#pragma mark - <TimeSelectionDelegate>
- (void)didUpdateAppointmentDateTime:(NSDate *)dateTime {
    self.appointment.date = dateTime;
}

#pragma mark - <CardActivityDelegate>
-(void)didTapButtonOneOnCard:(LEOCard *)card withAssociatedObject:(id)appointment {
    
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


-(NSIndexPath *)indexPathForSelectedDate {
    
    NSUInteger indexForSelectedDate = [self.appointment.date daysFrom:[self startDate]];
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


 /* Zachary Drossman
  * FIXME: This VFL-based autolayout below is not working as expected,
  * but the autolayout setup on the storyboard is working just
  * fine for now
 */

//-(void)dontupdate {
//    
//    UIView *mainView = self.view;
//    
//    self.view.backgroundColor = [UIColor whiteColor];
//    self.scrollView.backgroundColor = [UIColor blackColor];
//    self.contentView.backgroundColor = [UIColor yellowColor];
//    
//    [super updateViewConstraints];
//    
//    
//    NSDictionary *viewsDictionary = NSDictionaryOfVariableBindings(_scrollView, _navBar, _contentView, _dateCollectionView, _containerView, _monthLabel, _doctorDropDownTV, mainView);
//    
//    
//    //    [self.view removeConstraints:self.view.constraints];
//    [self.scrollView removeConstraints:self.scrollView.constraints];
//    [self.contentView removeConstraints:self.contentView.constraints];
//    
//    //    self.navBar.translatesAutoresizingMaskIntoConstraints = NO;
//    //    self.contentView.translatesAutoresizingMaskIntoConstraints = NO;
//    //    self.dateCollectionView.translatesAutoresizingMaskIntoConstraints = NO;
//    //    self.containerView.translatesAutoresizingMaskIntoConstraints = NO;
//    //    self.monthLabel.translatesAutoresizingMaskIntoConstraints = NO;
//    //    self.visitTypeDropDown.translatesAutoresizingMaskIntoConstraints = NO;
//    
//    
//    // Top (1) level constraints
//    
//    //    NSArray *horizontalScrollViewConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_scrollView]|" options:0 metrics:nil views:viewsDictionary];
//    //
//    //    NSArray *horizontalNavBarConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_navBar]|" options:0 metrics:nil views:viewsDictionary];
//    //
//    //    NSArray *verticalScrollViewConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_navBar][_scrollView]|" options:0 metrics:nil views:viewsDictionary];
//    //
//    //
//    //    [self.view addConstraints:horizontalNavBarConstraints];
//    //    [self.view addConstraints:horizontalScrollViewConstraints];
//    //    [self.view addConstraints:verticalScrollViewConstraints];
//    
//    // Second (2) level constraints
//    
//    NSArray *verticalContentViewConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_contentView]|" options:0 metrics:nil views:viewsDictionary];
//    
//    NSArray *horizontalContentViewConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_contentView]|" options:0 metrics:nil views:viewsDictionary];
//    
//    NSLayoutConstraint *widthOfcontentViewConstraint = [NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0];
//    
//    [self.scrollView addConstraints:verticalContentViewConstraints];
//    [self.scrollView addConstraints:horizontalContentViewConstraints];
//    [self.view addConstraint:widthOfcontentViewConstraint];
//    
//    [self.contentView setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
//    [self.contentView setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
//    
//    
//    // Third (3) level constraints
//    
//    NSLayoutConstraint *constraintForTopOfDoctorDropDown = [NSLayoutConstraint constraintWithItem:self.doctorDropDownTV attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTop multiplier:1.0 constant:0];
//    
//    NSLayoutConstraint *constraintForBottomOfDoctorDropDown = [NSLayoutConstraint constraintWithItem:self.doctorDropDownTV attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.monthLabel attribute:NSLayoutAttributeTop multiplier:1.0 constant:44.0];
//    
//    NSArray *verticalSubviewConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_monthLabel(==44)][_dateCollectionView(==44)][_containerView(==200)]|" options:0 metrics:nil views:viewsDictionary];
//    
//    NSArray *horizontalVisitDropDownConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_visitTypeDropDown]|" options:0 metrics:nil views:viewsDictionary];
//    
//    NSArray *horizontalMonthLabelConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_monthLabel]|" options:0 metrics:nil views:viewsDictionary];
//    
//    NSArray *horizontalDateCollectionViewConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_dateCollectionView]|" options:0 metrics:nil views:viewsDictionary];
//    
//    NSArray *horizontalContainerViewConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_containerView]|" options:0 metrics:nil views:viewsDictionary];
//    
//    NSArray *horizontalButtonViewConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:[_visitTypeDropDown]|" options:0 metrics:nil views:viewsDictionary];
//    
//    NSLayoutConstraint *constraintForWidthOfDateCollectionView = [NSLayoutConstraint constraintWithItem:self.dateCollectionView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0];
//    
//    [self.view addConstraint:constraintForTopOfDoctorDropDown];
//    [self.view addConstraint:constraintForBottomOfDoctorDropDown];
//    [self.contentView addConstraints:verticalSubviewConstraints];
//    
//    [self.contentView addConstraints:horizontalVisitDropDownConstraints];
//    [self.contentView addConstraints:horizontalDateCollectionViewConstraints];
//    [self.contentView addConstraints:horizontalMonthLabelConstraints];
//    [self.contentView addConstraints:horizontalContainerViewConstraints];
//    
//}


@end
