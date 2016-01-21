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
    self.monthLabel.font = [UIFont leo_expandedCardHeaderFont];
    self.monthLabel.textColor = [UIColor leo_white];
    self.noSlotsLabel.text = @"We're all booked up this week!\nCheck out next week for more appointments.";
    self.noSlotsLabel.textColor = [UIColor leo_grayStandard];
    self.noSlotsLabel.font = [UIFont leo_standardFont];
    self.noSlotsLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.noSlotsLabel.numberOfLines = 0;
    self.noSlotsLabel.hidden = YES;
}

- (void)requestDataWithCompletion:(void (^) (id data, NSError *error))completionBlock {
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    self.requestOperation.requestBlock = ^(id data, NSError *error) {
        completionBlock(data, error);
    };
    
    [queue addOperation:self.requestOperation];
    
}

- (void)didScrollDateCollectionViewToDate:(NSDate *)date selectable:(BOOL)selectable {
    
    if (!selectable) {
        
        self.timeCollectionView.hidden = YES;
        self.noSlotsLabel.hidden = NO;
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

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    [LEOApiReachability startMonitoringForController:self withContinueBlock:^{
        [self loadCollectionViewWithInitialDate];
    } withNoContinueBlock:^{
        // TODO: what should happen when the user is offline?
    }];

}

- (void)loadCollectionViewWithInitialDate {
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [self requestDataWithCompletion:^(id data, NSError *error){
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        [self addSlotToSlotData:data];
        
        self.dateCollectionController = [[DateCollectionController alloc] initWithCollectionView:self.dateCollectionView dates:self.slotsDictionary chosenDate:[self initialDate]];
        self.dateCollectionController.delegate = self;
        
        self.timeCollectionController = [[TimeCollectionController alloc] initWithCollectionView:self.timeCollectionView slots:self.slotsDictionary[[[self initialDate] leo_beginningOfDay]] chosenSlot:[Slot slotFromExistingAppointment:self.appointment]];
        self.timeCollectionController.delegate = self;
        
        //FIXME: Don't love that I have to call this from outside of the DateCollectionController. There has got to be a better way.
        [self.dateCollectionView setContentOffset:[self.dateCollectionController offsetForWeekOfStartingDate] animated:NO];

        [self updateMonthLabelWithDate:[self initialDate]];
        
        [self.timeCollectionView layoutIfNeeded];
    }];
}

- (void)updateMonthLabelWithDate:(NSDate *)date {
    NSDateFormatter *monthYearFormatter = [[NSDateFormatter alloc] init];
    monthYearFormatter.dateFormat = @"MMMM' 'YYYY";
    self.monthLabel.text = [monthYearFormatter stringFromDate:date];
}


-(void)didSelectSlot:(Slot * __nonnull)slot {
    
    [self.delegate didUpdateItem:slot.startDateTime forKey:@"date"];
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


//TODO: code that needs refactoring.
- (void)addSlotToSlotData:(id)data {
    
    if (self.appointment.date) {
        
        NSMutableDictionary *slotsDictionaryWithExistingAppointmentSlot = [data mutableCopy];
        NSMutableArray *slotsForDateOfExistingAppointment = [slotsDictionaryWithExistingAppointmentSlot[[self.appointment.date leo_beginningOfDay]] mutableCopy];

        Slot *prepSlot = [Slot slotFromExistingAppointment:self.appointment];
        
        NSUInteger slotCount = [slotsForDateOfExistingAppointment count];
        
        NSArray *sortedSlots;
        
        BOOL duplicate = NO;
        
        for (NSInteger i = 0; i < slotCount; i++) {
            
            Slot *slot = slotsForDateOfExistingAppointment[i];
            
            if ([prepSlot.startDateTime isEqualToDate:slot.startDateTime]) {
                duplicate = YES;
                break;
            }
        }
        
        if (!duplicate) {
            
            [slotsForDateOfExistingAppointment insertObject:prepSlot atIndex:0];
        }
        
        NSSortDescriptor *datesAscending = [NSSortDescriptor sortDescriptorWithKey:@"startDateTime" ascending:YES];
        
        sortedSlots = [slotsForDateOfExistingAppointment sortedArrayUsingDescriptors:@[datesAscending]];
        
        [slotsDictionaryWithExistingAppointmentSlot setObject:sortedSlots forKey:[self.appointment.date leo_beginningOfDay]];
        self.slotsDictionary = [slotsDictionaryWithExistingAppointmentSlot copy];
        
    } else {
        self.slotsDictionary = data;
    }
}

@end
