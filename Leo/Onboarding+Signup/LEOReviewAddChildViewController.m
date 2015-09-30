//
//  LEOReviewAddChildViewController.m
//  Leo
//
//  Created by Zachary Drossman on 9/30/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import "LEOReviewAddChildViewController.h"
#import "LEOReviewAndAddChildView.h"
#import "LEOValidatedFloatLabeledTextField.h"
#import "UIFont+LeoFonts.h"
#import "UIColor+LeoColors.h"
#import "UIImage+Extensions.h"
#import "ArrayDataSource.h"
#import "LEOPromptViewCell+ConfigureForPatient.h"
#import "Patient.h"

@interface LEOReviewAddChildViewController ()

@end

@interface LEOReviewAddChildViewController ()

@property (strong, nonatomic) LEOReviewAndAddChildView *reviewAddChildView;
@property (weak, nonatomic) IBOutlet StickyView *stickyView;
@property (strong, nonatomic) ArrayDataSource *dataSource;

@end

@implementation LEOReviewAddChildViewController

#pragma mark - View Controller Lifecycle and Helpers

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self setupStickyView];
    [self setupTableView];
}

- (void)setupStickyView {
    
    self.stickyView.delegate = self;
    self.stickyView.tintColor = [UIColor leoOrangeRed];
    [self.stickyView reloadViews];
}

- (void)setupTableView {
    
    [self.tableView registerNib:[UINib nibWithNibName:@"LEOPromptViewCell" bundle:nil]  forCellReuseIdentifier:@"LEOPromptViewCell"];
    
    BOOL (^configureCellBlock)(id cell, id data) = ^(LEOPromptViewCell *cell, Patient *patient) {
        
        [cell configureForPatient:patient];
        
        return YES;
    };
    
    self.dataSource = [[ArrayDataSource alloc] initWithItems:self.childData cellIdentifier:@"LEOPromptViewCell" configureCellBlock:configureCellBlock selectionCriteriaBlock:nil];
    
    [self tableView].dataSource = self.dataSource;
    [self tableView].delegate = self;
    
    [[self tableView] reloadData];
}


-(NSArray *)childData {
    
    if (!_childData) {
        
        _childData = [[NSMutableArray alloc] init];
        
        Patient *patient = [[Patient alloc] initWithTitle:nil firstName:@"Zachary" middleInitial:@"S" lastName:@"Drossman" suffix:nil email:nil avatar:[UIImage imageNamed:@"background-original"] dob:[NSDate date] gender:@"Male" status:[@(PatientStatusInactive) stringValue]];
        
        Patient *patient2 = [[Patient alloc] initWithTitle:nil firstName:@"Zachary" middleInitial:@"S" lastName:@"Drossman" suffix:nil email:nil avatar:[UIImage imageNamed:@"background-original"] dob:[NSDate date] gender:@"Male" status:[@(PatientStatusInactive) stringValue]];

        Patient *patient3 = [[Patient alloc] initWithTitle:nil firstName:@"Zachary" middleInitial:@"S" lastName:@"Drossman" suffix:nil email:nil avatar:[UIImage imageNamed:@"background-original"] dob:[NSDate date] gender:@"Male" status:[@(PatientStatusInactive) stringValue]];

        Patient *patient4 = [[Patient alloc] initWithTitle:nil firstName:@"Zachary" middleInitial:@"S" lastName:@"Drossman" suffix:nil email:nil avatar:[UIImage imageNamed:@"background-original"] dob:[NSDate date] gender:@"Male" status:[@(PatientStatusInactive) stringValue]];

        _childData = @[patient, patient2, patient3, patient4];
    }
    
    return _childData;
}



#pragma mark - <StickyViewDelegate>

- (BOOL)scrollable {
    return YES;
}

- (BOOL)initialStateExpanded {
    return YES;
}

- (NSString *)expandedTitleViewContent {
    return @"Add or review your children's details";
}


- (NSString *)collapsedTitleViewContent {
    return @" ";
}

- (UIView *)stickyViewBody{
    return self.reviewAddChildView;
}

- (UIImage *)expandedGradientImage {
    
    return [UIImage imageWithColor:[UIColor leoWhite]];
}

- (UIImage *)collapsedGradientImage {
    return [UIImage imageWithColor:[UIColor leoWhite]];
}

-(UIViewController *)associatedViewController {
    return self;
}

-(LEOReviewAndAddChildView *)reviewAddChildView {
    
    if (!_reviewAddChildView) {
        _reviewAddChildView = [[LEOReviewAndAddChildView alloc] initWithCellCount:[self.childData count]];
        _reviewAddChildView.tintColor = [UIColor leoOrangeRed];
    }
    
    return _reviewAddChildView;
}


- (UITableView *)tableView {
    return self.reviewAddChildView.tableView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 68;
}

#pragma mark - Navigation

- (void)pop {
    
    [self.navigationController popViewControllerAnimated:YES];
    self.navigationController.navigationBarHidden = YES;
}
@end
