//
//  TimeCollectionViewController.m
//  Leo
//
//  Created by Zachary Drossman on 6/4/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import "TimeCollectionViewController.h"
#import "LEOCoreDataManager.h"
#import <NSDate+DateTools.h>
#import "LEOTimeCell.h"

@interface TimeCollectionViewController ()

@property (strong, nonatomic) LEOCoreDataManager *coreDataManager;

@end

@implementation TimeCollectionViewController

static NSString * const timeReuseIdentifier = @"TimeCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.coreDataManager = [LEOCoreDataManager sharedManager];
    [self setupTimeCollectionView];

    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Register cell classes
//    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:timeReuseIdentifier];
    // Do any additional setup after loading the view.
}

- (void)setupTimeCollectionView {
    
    //repetitive since in the storyboard...
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    [flowLayout setMinimumInteritemSpacing:5.0f];
    [flowLayout setMinimumLineSpacing:5.0f];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.collectionViewLayout = flowLayout;
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"LEOTimeCell" bundle:nil]
              forCellWithReuseIdentifier:timeReuseIdentifier];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [[self availableTimesForDate:self.selectedDate] count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    LEOTimeCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:timeReuseIdentifier forIndexPath:indexPath];
    
    NSDateFormatter *timeFormat = [[NSDateFormatter alloc] init];
    timeFormat.dateFormat = @"h':'mm a";
    
    cell.timeLabel.text = [[timeFormat stringFromDate:[self availableTimesForDate:self.selectedDate][indexPath.row]] lowercaseString];
    
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

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
        return CGSizeMake(100.0, 50.0);
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
        return UIEdgeInsetsMake(0, 5, 0, 5);
  
}

@end
