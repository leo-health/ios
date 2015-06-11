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

@interface LEOSingleAppointmentSchedulerCardVC ()

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UICollectionView *timeCollectionView;
@property (strong, nonatomic) IBOutlet UICollectionView *dateCollectionView;
@property (weak, nonatomic) IBOutlet UILabel *monthLabel;

@property (strong, nonatomic) ArrayDataSource *arrayDataSource;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;

@property (strong, nonatomic) LEOCoreDataManager *coreDataManager;
@property (strong, nonatomic) NSDate *selectedDate;
@property (weak, nonatomic) IBOutlet UIView *contentView;

@property (strong, nonatomic) NSArray *dates;

@end

@implementation LEOSingleAppointmentSchedulerCardVC

static NSString * const timeReuseIdentifier = @"TimeCell";
static NSString * const dateReuseIdentifier = @"DateCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupTimeCollectionView];
    [self setupDateCollectionView];
//    [self updateConstraints];
    [self setupMonthLabel];
    self.coreDataManager = [LEOCoreDataManager sharedManager];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}


//TODO: Not currently being used, remove?
- (void)updateConstraints {
    
    [self.contentView removeConstraints:self.contentView.constraints];
    [self.timeCollectionView removeConstraints:self.timeCollectionView.constraints];
    [self.dateCollectionView removeConstraints:self.dateCollectionView.constraints];
    
    self.timeCollectionView.translatesAutoresizingMaskIntoConstraints = NO;
    self.dateCollectionView.translatesAutoresizingMaskIntoConstraints = NO;
    
    UICollectionView *timeCollectionView = self.timeCollectionView;
    UICollectionView *dateCollectionView = self.dateCollectionView;
    
    NSDictionary *viewsDictionary = NSDictionaryOfVariableBindings(timeCollectionView, dateCollectionView);
    
    NSArray *horizontalTableViewConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[dateCollectionView]|" options:0 metrics:nil views:viewsDictionary];
    
    NSLayoutConstraint *leadingTimeCollectionViewConstraint = [NSLayoutConstraint constraintWithItem:self.timeCollectionView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0 constant:15];
    
    NSLayoutConstraint *trailingTimeCollectionViewConstraint = [NSLayoutConstraint constraintWithItem:self.timeCollectionView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:-15];
    
    NSLayoutConstraint *bottomTimeCollectionViewConstraint = [NSLayoutConstraint constraintWithItem:self.timeCollectionView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0];
    
    NSLayoutConstraint *topTimeCollectionViewConstraint = [NSLayoutConstraint constraintWithItem:self.timeCollectionView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.dateCollectionView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:15];
    
    NSLayoutConstraint *topDateCollectionViewConstraint = [NSLayoutConstraint constraintWithItem:self.dateCollectionView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:35];
    
    [self.view addConstraints:@[leadingTimeCollectionViewConstraint, trailingTimeCollectionViewConstraint, topDateCollectionViewConstraint]];
    [self.contentView addConstraint:bottomTimeCollectionViewConstraint];
    [self.contentView addConstraint:topTimeCollectionViewConstraint];
    [self.contentView addConstraints:horizontalTableViewConstraints];
    
    NSLayoutConstraint *widthConstraint = [NSLayoutConstraint constraintWithItem:self.dateCollectionView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0];
    
    NSLayoutConstraint *heightConstraint = [NSLayoutConstraint constraintWithItem:self.dateCollectionView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:44];
    
    [self.dateCollectionView addConstraints:@[heightConstraint]];
    [self.view addConstraints:@[widthConstraint]];
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

- (void)setupTimeCollectionView {
    
    self.timeCollectionView.dataSource = self;
    self.timeCollectionView.delegate = self;
    self.timeCollectionView.backgroundColor = [UIColor clearColor];
    
    [self.timeCollectionView registerNib:[UINib nibWithNibName:@"LEOTimeCell" bundle:nil]
              forCellWithReuseIdentifier:timeReuseIdentifier];
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
    if (collectionView == self.timeCollectionView) {

    } else {
        
        self.selectedDate = self.dates[indexPath.row];
        [self.timeCollectionView reloadData];
        [self.dateCollectionView reloadData]; //FIXME: Smelly.
    }
}

#pragma mark <UICollectionViewDataSource>

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    if (collectionView == self.timeCollectionView) {
        return [[self dates] count];
    } else {
        return 1;
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    if (collectionView == self.timeCollectionView) {
        return [[self availableTimesForDate:self.selectedDate] count];
    } else {
        return [[self dates] count];
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (collectionView == self.timeCollectionView) {
        LEOTimeCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:timeReuseIdentifier forIndexPath:indexPath];
        
        NSDateFormatter *timeFormat = [[NSDateFormatter alloc] init];
        timeFormat.dateFormat = @"h':'mm a";
        
        cell.timeLabel.text = [[timeFormat stringFromDate:[self availableTimesForDate:self.selectedDate][indexPath.row]] lowercaseString];
        
        return cell;
        
    } else {
        
        LEODateCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:dateReuseIdentifier forIndexPath:indexPath];
        
        NSDate *date = self.dates[indexPath.row];
        
        cell.dateLabel.text = [@(date.day) stringValue];
        
        NSDateFormatter *weekdayFormatter = [[NSDateFormatter alloc] init];
        weekdayFormatter.dateFormat = @"EEE";
        
        cell.dayOfDateLabel.text = [[weekdayFormatter stringFromDate:date] uppercaseString];
        
       if (date.weekday == self.selectedDate.weekday) {
           [self.timeCollectionView reloadData]; //FIXME: Feels...smelly.
           cell.selected = YES;
           self.selectedDate = date;
       }
       else {
           cell.selected = NO;
       }
        return cell;
    }
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
    
    
    if (collectionView == self.timeCollectionView) {
        return CGSizeMake(100.0, 50.0);
    } else {
        return CGSizeMake(41.0, 41.0);
    }
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    if (collectionView == self.timeCollectionView) {
        return UIEdgeInsetsMake(0, 5, 0, 5);
    } else {
        return UIEdgeInsetsMake(0,0,0,0);
    }
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

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
