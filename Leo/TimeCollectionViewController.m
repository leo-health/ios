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
#import "CollectionViewDataSource.h"
#import "LEOTimeCell+ConfigureCell.h"

@interface TimeCollectionViewController ()

@property (strong, nonatomic) LEOCoreDataManager *coreDataManager;
@property (strong, nonatomic) CollectionViewDataSource *dataSource;

@property (strong, nonatomic) NSArray *times;


#pragma mark - Properties For State
@property (nonatomic) BOOL firstPass;

@end

@implementation TimeCollectionViewController

static NSString * const timeReuseIdentifier = @"TimeCell";



#pragma mark - View Controller Lifecycle and VCL Helper Methods
- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.coreDataManager = [LEOCoreDataManager sharedManager];
    self.firstPass = YES;
    [self setupTimeCollectionView];
}

- (void)setupTimeCollectionView {
    
    self.times = [self.coreDataManager availableTimesForDate:self.selectedDate];
    
    void (^configureCell)(LEOTimeCell *, NSDate*) = ^(LEOTimeCell* cell, NSDate* dateTime) {
        [cell configureForDateTime:dateTime];
    };
    
    self.dataSource = [[CollectionViewDataSource alloc] initWithItems:self.times cellIdentifier:timeReuseIdentifier configureCellBlock:configureCell];
    
    //MARK: repetitive since in the storyboard...
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    [flowLayout setMinimumInteritemSpacing:5.0f];
    [flowLayout setMinimumLineSpacing:5.0f];
    self.collectionView.collectionViewLayout = flowLayout;
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.dataSource = self.dataSource;
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"LEOTimeCell" bundle:nil]
          forCellWithReuseIdentifier:timeReuseIdentifier];
}

-(void)setSelectedDate:(NSDate *)selectedDate {
    
    _selectedDate = selectedDate;
    NSLog(@"Selected date is  %@",selectedDate);
    [self.collectionView reloadData];
}



#pragma mark - <UICollectionViewDelegate>
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    [self.delegate didUpdateAppointmentDateTime:self.times[indexPath.row]];
    self.selectedDate = self.times[indexPath.row];
}

-(void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.firstPass) {
        [collectionView selectItemAtIndexPath:indexPath animated:NO scrollPosition:UICollectionViewScrollPositionNone];
        cell.selected = YES;
    } else {
        if ([self.selectedDate isEqualToDate:self.times[indexPath.row]]) {
            [collectionView selectItemAtIndexPath:indexPath animated:NO scrollPosition:UICollectionViewScrollPositionNone];
            cell.selected = YES;
        }
    }
    
    self.firstPass = NO;
}



#pragma mark - <UICollectionViewDelegateFlowLayout>
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return CGSizeMake(100.0, 50.0);
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    return UIEdgeInsetsMake(0, 5, 0, 5);
}


@end