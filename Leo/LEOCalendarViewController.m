//
//  LEOCalendarViewController.m
//  LEO
//
//  Created by Zachary Drossman on 7/28/15.
//  Copyright (c) 2015 Zachary Drossman. All rights reserved.
//

#import "LEOCalendarViewController.h"
#import "LEOCalendarDataSource.h"
#import "DateCollectionController.h"
#import "TimeCollectionController.h"
#import <NSDate+DateTools.h>
#import "NSDate+Extensions.h"
#import "Slot.h"
#import "LEOConstants.h"
#import "PrepAppointment.h"
#import "Appointment.h"
#import "LEOAPISlotsOperation.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import "UIColor+LeoColors.h"
#import "UIFont+LeoFonts.h"
#import "LEOStyleHelper.h"
#import "LEOAlertHelper.h"
#import "LEOAnalytic.h"

@interface LEOCalendarViewController ()

@property (weak, nonatomic) IBOutlet UICollectionView *dateCollectionView;
@property (weak, nonatomic) IBOutlet UICollectionView *timeCollectionView;
@property (weak, nonatomic) IBOutlet UILabel *monthLabel;
@property (weak, nonatomic) IBOutlet UIView *monthView;
@property (weak, nonatomic) IBOutlet UIView *gradientView;

@property (strong, nonatomic) NSDictionary *slotsDictionary;

@property (strong, nonatomic) DateCollectionController *dateCollectionController;
@property (strong, nonatomic) TimeCollectionController *timeCollectionController;
@property (weak, nonatomic) IBOutlet UILabel *noSlotsLabel;

@end

@implementation LEOCalendarViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];

    [self formatCalendar];
    [self setupCollectionView];
    [self setupNavBar];
}

- (void)viewDidAppear:(BOOL)animated {

    [super viewDidAppear:animated];

    [LEOAnalytic tagType:LEOAnalyticTypeScreen
               eventName:kAnalyticScreenAppointmentCalendar];

    [LEOApiReachability startMonitoringForController:self withOfflineBlock:^{

        // TODO: what should happen when the user is offline?
    } withOnlineBlock:^{

        [self loadCollectionViewWithInitialDate];
    }];
    
}


- (void)viewDidLayoutSubviews {

    [super viewDidLayoutSubviews];
    [self setupGradient];
}

- (void)setupGradient {

    UIColor *startColor = [LEOStyleHelper gradientStartColorForFeature:FeatureAppointmentScheduling];
    UIColor *endColor = [LEOStyleHelper gradientEndColorForFeature:FeatureAppointmentScheduling];
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.colors = @[(id)startColor.CGColor, (id)endColor.CGColor];
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(1, 1);
    gradientLayer.frame = self.gradientView.frame;
    [self.gradientView.layer addSublayer:gradientLayer];
}

- (void)setupNavBar {

    [LEOStyleHelper styleNavigationBarForViewController:self forFeature:FeatureAppointmentScheduling withTitleText:nil dismissal:NO backButton:YES];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
}

- (void)formatCalendar {
    
    self.monthView.backgroundColor = [UIColor clearColor];
    self.monthLabel.font = [UIFont leo_ultraLight27];
    self.monthLabel.textColor = [UIColor leo_white];
    self.noSlotsLabel.text = @"We're all booked up this week!\nCheck out next week for more appointments.";
    self.noSlotsLabel.textColor = [UIColor leo_gray124];
    self.noSlotsLabel.font = [UIFont leo_regular15];
    self.noSlotsLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.noSlotsLabel.numberOfLines = 0;
    self.noSlotsLabel.hidden = YES;
}

- (void)requestDataWithCompletion:(void (^) (id data, NSError *error))completionBlock {
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];

    self.requestOperation = [[LEOAPISlotsOperation alloc] initWithAppointment:self.appointment];

    self.requestOperation.requestBlock = ^(id data, NSError *error) {
        completionBlock(data, error);
    };
    
    [queue addOperation:self.requestOperation];
    
}

- (void)showEmptyState {

    self.timeCollectionView.hidden = YES;
    self.noSlotsLabel.hidden = NO;
}

- (void)didScrollDateCollectionViewToDate:(NSDate *)date selectable:(BOOL)selectable {
    
    if (!selectable) {

        [self showEmptyState];
    } else {
        
        self.timeCollectionController = [[TimeCollectionController alloc] initWithCollectionView:self.timeCollectionView slots:self.slotsDictionary[date] chosenSlot:[Slot slotFromExistingAppointment:self.appointment]];
        self.timeCollectionController.delegate = self;

        [self.timeCollectionView layoutIfNeeded];

        self.timeCollectionView.hidden = NO;
        self.noSlotsLabel.hidden = YES;
    }
    
    
    [self updateMonthLabelWithDate:date];
}


- (void)setupCollectionView {

    self.automaticallyAdjustsScrollViewInsets = NO;

    //FIXME: This is a code smell. These shouldn't be initialized just for the sake of setting up the design. Will come back to this later for speed of first module completion.
    self.dateCollectionController = [[DateCollectionController alloc] initWithCollectionView:self.dateCollectionView dates:self.slotsDictionary chosenDate:[self initialDate]];
    self.timeCollectionController = [[TimeCollectionController alloc] initWithCollectionView:self.timeCollectionView slots:self.slotsDictionary[[self initialDate]] chosenSlot:nil];
}

- (NSDate *)initialDate {
    
    NSDate *initialDate;
    
    if (self.appointment.date) {
        initialDate = self.appointment.date;
    } else {
        initialDate = [self firstSlot].startDateTime;
    }
    
    return initialDate;
}

- (void)loadCollectionViewWithInitialDate {
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    __weak typeof(self) weakSelf = self;

    [self requestDataWithCompletion:^(id data, NSError *error){

        __strong typeof(self) strongSelf = weakSelf;

        [MBProgressHUD hideHUDForView:strongSelf.view animated:YES];

        if (error) {

            [LEOAlertHelper alertForViewController:strongSelf error:error backupTitle:@"Oops!" backupMessage:@"Looks like we have a boo boo or your internet is not working at the moment. Please try again."];
            return;
        }

        strongSelf.slotsDictionary = data;

        strongSelf.dateCollectionController = [[DateCollectionController alloc] initWithCollectionView:strongSelf.dateCollectionView dates:strongSelf.slotsDictionary chosenDate:[strongSelf initialDate]];
        strongSelf.dateCollectionController.delegate = strongSelf;
        
        strongSelf.timeCollectionController = [[TimeCollectionController alloc] initWithCollectionView:strongSelf.timeCollectionView slots:strongSelf.slotsDictionary[[[strongSelf initialDate] leo_beginningOfDay]] chosenSlot:[Slot slotFromExistingAppointment:strongSelf.appointment]];
        strongSelf.timeCollectionController.delegate = strongSelf;
        
        //FIXME: Don't love that I have to call this from outside of the DateCollectionController. There has got to be a better way.
        [strongSelf.dateCollectionView setContentOffset:[strongSelf.dateCollectionController offsetForWeekOfStartingDate] animated:NO];

        [strongSelf updateMonthLabelWithDate:[strongSelf initialDate]];
        
        [strongSelf.timeCollectionView layoutIfNeeded];

        if ([strongSelf.timeCollectionController shouldShowEmptyState]) {
            [strongSelf showEmptyState];
        }
    }];
}

- (void)updateMonthLabelWithDate:(NSDate *)date {

    NSDateFormatter *monthYearFormatter = [[NSDateFormatter alloc] init];
    monthYearFormatter.dateFormat = @"MMMM yyyy";
    self.monthLabel.text = [monthYearFormatter stringFromDate:date];
}


-(void)didSelectSlot:(Slot * __nonnull)slot {
    
    [self.delegate didUpdateItem:slot forKey:kKeySelectionVCSlot];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)reloadTapped:(UIButton *)sender {
    [self.dateCollectionView reloadData];
}

#pragma mark - Data helper functions

- (Slot *)firstSlot {
    
    NSArray *dates = [[self.slotsDictionary allKeys] sortedArrayUsingSelector:@selector(compare:)];
    
    NSArray *openSlots;
    
    for (NSDate *slotDate in dates) {
        
        openSlots = self.slotsDictionary[slotDate];
        
        if ([openSlots count] > 0) {
            return openSlots.firstObject;
        }
    }
    
    return nil; // Need to deal with this since it would break, even though we'd never have no open slots.
}


@end
