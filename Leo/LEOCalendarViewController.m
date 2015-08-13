//
//  ViewController.m
//  LEOCalendar
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
#import "LEOAPISlotsOperation.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import "UIColor+LeoColors.h"
#import "UIFont+LeoFonts.h"

@interface LEOCalendarViewController ()

@property (weak, nonatomic) IBOutlet UICollectionView *dateCollectionView;
@property (weak, nonatomic) IBOutlet UICollectionView *timeCollectionView;
@property (weak, nonatomic) IBOutlet UILabel *monthLabel;
@property (weak, nonatomic) IBOutlet UIView *monthView;

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
}

- (void)formatCalendar {
    
    self.monthView.backgroundColor = [UIColor leoGreen];
    self.monthLabel.font = [UIFont leoHeaderLightFont];
    self.monthLabel.textColor = [UIColor leoWhite];
    self.noSlotsLabel.text = @"We're all booked up this week!\nCheck out next week for more appointments.";
    self.noSlotsLabel.textColor = [UIColor leoGrayBodyText];
    self.noSlotsLabel.font = [UIFont leoBodyFont];
    self.noSlotsLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.noSlotsLabel.numberOfLines = 0;
}

- (void)requestDataWithCompletion:(void (^) (id data))completionBlock {
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    self.requestOperation.requestBlock = ^(id data) {
        completionBlock(data);
    };
    
    [queue addOperation:self.requestOperation];
    
}

- (void)didScrollDateCollectionViewToDate:(NSDate *)date selectable:(BOOL)selectable {
    
    if (!selectable) {
        self.timeCollectionView.hidden = YES;
        self.noSlotsLabel.hidden = NO;
    } else {
        
        self.timeCollectionController = [[TimeCollectionController alloc] initWithCollectionView:self.timeCollectionView slots:self.slotsDictionary[date]];
        self.timeCollectionController.delegate = self;

        [self.timeCollectionView layoutIfNeeded];

        self.timeCollectionView.hidden = NO;
        self.noSlotsLabel.hidden = YES;
    }
    
    
    [self updateMonthLabelWithDate:date];
}


- (void)setupCollectionView {
    
    
    NSDate *initialDate;
    
    if (self.prepAppointment.date) {
        initialDate = self.prepAppointment.date;
    } else {
        initialDate = [self firstSlot].startDateTime;
    }

    //FIXME: This is a code smell. These shouldn't be initialized just for the sake of setting up the design. Will come back to this later for speed of first module completion.
    self.dateCollectionController = [[DateCollectionController alloc] initWithCollectionView:self.dateCollectionView dates:self.slotsDictionary chosenDate:initialDate];
    self.timeCollectionController = [[TimeCollectionController alloc] initWithCollectionView:self.timeCollectionView slots:self.slotsDictionary[initialDate]];
    
    [self updateMonthLabelWithDate:initialDate];

    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [self requestDataWithCompletion:^(id data){
        
//        sleep(1.0);
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];

        self.slotsDictionary = data;
        
        self.dateCollectionController = [[DateCollectionController alloc] initWithCollectionView:self.dateCollectionView dates:self.slotsDictionary chosenDate:initialDate];
        self.dateCollectionController.delegate = self;
        
        
        self.timeCollectionController = [[TimeCollectionController alloc] initWithCollectionView:self.timeCollectionView slots:self.slotsDictionary[[(NSDate *)initialDate beginningOfDay]]];
        self.timeCollectionController.delegate = self;

        
        //FIXME: Don't love that I have to call this from outside of the DateCollectionController. There has got to be a better way.
        [self.dateCollectionView setContentOffset:[self.dateCollectionController offsetForWeekOfStartingDate] animated:NO];
        
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
    
    Slot *firstOpenSlot;
    
    for (NSDate *slotDate in dates) {
        
        firstOpenSlot = self.slotsDictionary[slotDate];
        
        if (firstOpenSlot) {
            break;
        }
    }
    
    return firstOpenSlot;
}

@end
