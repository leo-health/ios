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

@interface LEOCalendarViewController ()

@property (weak, nonatomic) IBOutlet UICollectionView *dateCollectionView;
@property (weak, nonatomic) IBOutlet UICollectionView *timeCollectionView;
@property (weak, nonatomic) IBOutlet UILabel *monthLabel;
@property (weak, nonatomic) IBOutlet UILabel *fullDateLabel;

@property (strong, nonatomic) NSDictionary *slotsDictionary;

@property (strong, nonatomic) DateCollectionController *dateCollectionController;
@property (strong, nonatomic) TimeCollectionController *timeCollectionController;

@end

@implementation LEOCalendarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupCollectionView];
}


- (void)requestDataWithCompletion:(void (^) (id data))completionBlock {
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    self.requestOperation.requestBlock = ^(id data) {
        completionBlock(data);
    };
    
    [queue addOperation:self.requestOperation];
    
}

- (void)didScrollDateCollectionViewToDate:(NSDate *)date selectable:(BOOL)selectable {
    
    self.timeCollectionController = [[TimeCollectionController alloc] initWithCollectionView:self.timeCollectionView slots:self.slotsDictionary[date]];
    self.timeCollectionController.delegate = self;
    
    [self.timeCollectionView layoutIfNeeded];
    
    [self updateMonthLabelWithDate:date];
    
    if (selectable) {
        [self updateFullDateLabelWithDate:date];
    }
}


- (void)setupCollectionView {
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [self requestDataWithCompletion:^(id data){
        
        sleep(1.0);
        
        self.slotsDictionary = data;
        
        NSDate *initialDate;
        
        if (self.prepAppointment.date) {
            initialDate = self.prepAppointment.date;
        } else {
            initialDate = [self firstSlot].startDateTime;
        }
        
        
        self.dateCollectionController = [[DateCollectionController alloc] initWithCollectionView:self.dateCollectionView dates:self.slotsDictionary chosenDate:initialDate];
        self.dateCollectionController.delegate = self;
        
        self.timeCollectionController = [[TimeCollectionController alloc] initWithCollectionView:self.timeCollectionView slots: [(NSDate *)self.slotsDictionary[initialDate] beginningOfDay]    ];
        self.timeCollectionController.delegate = self;
        
        [self updateMonthLabelWithDate:initialDate];
        [self updateFullDateLabelWithDate:initialDate];
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        [self.dateCollectionView reloadData];
        [self.timeCollectionView reloadData];
        
        //FIXME: Don't love that I have to call this from outside of the DateCollectionController. There has got to be a better way.
        
        [self.dateCollectionView setContentOffset:[self.dateCollectionController offsetForWeekOfStartingDate] animated:NO];
    }];
}


- (void)updateMonthLabelWithDate:(NSDate *)date {
    NSDateFormatter *monthYearFormatter = [[NSDateFormatter alloc] init];
    monthYearFormatter.dateFormat = @"MMMM' 'YYYY";
    self.monthLabel.text = [monthYearFormatter stringFromDate:date];
}

- (void)updateFullDateLabelWithDate:(NSDate *)date {
    
    self.fullDateLabel.text = [NSDate stringifiedDateTime:date];
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
