//
//  LEOReviewOnboardingViewController.m
//  Leo
//
//  Created by Zachary Drossman on 10/5/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import "LEOReviewOnboardingViewController.h"

#import "LEOUserService.h"

#import "LEOBasicHeaderCell+ConfigureForCell.h"
#import "LEOReviewPatientCell+ConfigureForCell.h"
#import "LEOReviewUserCell+ConfigureForCell.h"
#import "LEOButtonCell.h"

#import "SessionUser.h"
#import "Family.h"
#import "Patient.h"
#import "Guardian.h"
#import "InsurancePlan.h"

#import "UIViewController+Extensions.h"

#import "LEOSignUpPatientViewController.h"
#import "LEOSignUpUserViewController.h"

#import "UIColor+LeoColors.h"
#import "UIFont+LeoFonts.h"
#import "UIView+Extensions.h"

#import "LEOStyleHelper.h"

#import "LEOFeedTVC.h"

#import "UIImage+Extensions.h"

typedef NS_ENUM(NSUInteger, TableViewSection) {
    
    TableViewSectionTitle = 0,
    TableViewSectionGuardians = 1,
    TableViewSectionPatients = 2,
    TableViewSectionButton = 3
    
};

@interface LEOReviewOnboardingViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) CAShapeLayer *pathLayer;
@property (nonatomic) BOOL breakerPreviouslyDrawn;

@end

@implementation LEOReviewOnboardingViewController


#pragma mark - Constants

static NSString *const kReviewUserSegue = @"ReviewUserSegue";
static NSString *const kReviewPatientSegue = @"ReviewPatientSegue";


#pragma mark - View Controller Lifecycle and Helper Methods

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self setupNavigationBar];
    [self setupBreaker];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [self setupTableView];
    [self.tableView reloadData];
    
    self.navigationItem.titleView.hidden = YES;
}

- (void)viewDidAppear:(BOOL)animated {
    
    [self toggleNavigationBarTitleView];
    
}

- (void)setupNavigationBar {
    
    self.view.tintColor = [LEOStyleHelper tintColorForFeature:FeatureOnboarding];
    
    [LEOStyleHelper styleNavigationBarForFeature:FeatureOnboarding];
    UILabel *navTitleLabel = [[UILabel alloc] init];
    navTitleLabel.text = @"Check yo' self";
    
    [LEOStyleHelper styleLabel:navTitleLabel forFeature:FeatureOnboarding];
    
    self.navigationItem.titleView = navTitleLabel;
    
    [self.navigationItem setHidesBackButton:YES];
}

- (void)toggleNavigationBarTitleView {
    
    self.navigationItem.titleView.hidden = NO;
    self.navigationItem.titleView.alpha = self.tableView.contentOffset.y == 0 ? 0:1;
}

- (void)setupTableView {
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.tableView.estimatedRowHeight = 100.0;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    self.tableView.alwaysBounceVertical = NO;
    
    [self.tableView registerNib:[LEOBasicHeaderCell nib]
         forCellReuseIdentifier:kHeaderCellReuseIdentifier];
    [self.tableView registerNib:[LEOReviewPatientCell nib]
         forCellReuseIdentifier:kReviewPatientCellReuseIdentifer];
    [self.tableView registerNib:[LEOReviewUserCell nib]
         forCellReuseIdentifier:kReviewUserCellReuseIdentifer];
    [self.tableView registerNib:[LEOButtonCell nib] forCellReuseIdentifier:kButtonCellReuseIdentifier];
}


#pragma mark - <UITableViewDataSource>

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSInteger rows = 0;
    
    switch (section) {
        case TableViewSectionTitle:
            rows = 1;
            break;
            
        case TableViewSectionGuardians:
            rows = 1;
            break;
            
        case TableViewSectionPatients:
            rows = [self.family.patients count];
            break;
            
        case TableViewSectionButton:
            rows = 1;
            break;
    }
    
    return rows;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.section) {
            
        case TableViewSectionTitle: {
            
            LEOBasicHeaderCell *basicHeaderCell = [tableView dequeueReusableCellWithIdentifier:kHeaderCellReuseIdentifier];
            
            [basicHeaderCell configureWithTitle:@"Finally, please confirm your information"];
            
            return basicHeaderCell;
        }
            
        case TableViewSectionGuardians: {
            
            LEOReviewUserCell *reviewUserCell = [tableView dequeueReusableCellWithIdentifier:kReviewUserCellReuseIdentifer];
            
            Guardian *guardian = self.family.guardians[indexPath.row];
            
            [reviewUserCell configureForGuardian:guardian];
            
            return reviewUserCell;
        }
            
        case TableViewSectionPatients: {
            
            LEOReviewPatientCell *reviewPatientCell = [tableView dequeueReusableCellWithIdentifier:kReviewPatientCellReuseIdentifer];
            
            Patient *patient = self.family.patients[indexPath.row];
            
            [reviewPatientCell configureForPatient:patient patientNumber:indexPath.row];
            
            return reviewPatientCell;
        }
            
        case TableViewSectionButton: {
            
            LEOButtonCell *buttonCell = [tableView dequeueReusableCellWithIdentifier:kButtonCellReuseIdentifier];
            
            [buttonCell.button addTarget:self action:@selector(continueTapped:) forControlEvents:UIControlEventTouchUpInside];
            
            return buttonCell;
        }
    }
    
    return nil;
}


#pragma mark - <UITableViewDelegate>

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.section) {
        case TableViewSectionGuardians: {
            
            Guardian *guardian = self.family.guardians[indexPath.row];
            [self performSegueWithIdentifier:kReviewUserSegue sender:guardian];
            break;
        }
            
        case TableViewSectionPatients: {
            
            Patient *patient = self.family.patients[indexPath.row];
            [self performSegueWithIdentifier:kReviewPatientSegue sender:patient];
            break;
        }
            
        case TableViewSectionTitle:
        case TableViewSectionButton:
            break;
    }
    
}

- (void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section {
    
    view.tintColor = [UIColor leoWhite];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    switch (section) {
        case TableViewSectionTitle:
            return 20.0;
            break;
            
        case TableViewSectionPatients:
        case TableViewSectionGuardians:
        case TableViewSectionButton:
            return 0.0;
            break;
    }
    
    return 0.0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.section) {
        case TableViewSectionTitle:
            return 130.0;
            
        case TableViewSectionGuardians:
        case TableViewSectionPatients:
        case TableViewSectionButton:
            return UITableViewAutomaticDimension;
    }
    
    return UITableViewAutomaticDimension;
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:kReviewUserSegue]) {
        
        LEOSignUpUserViewController *signUpUserVC = segue.destinationViewController;
        signUpUserVC.family = self.family;
        signUpUserVC.guardian = sender;
        signUpUserVC.managementMode = ManagementModeEdit;
    }
    
    if ([segue.identifier isEqualToString:kReviewPatientSegue]) {
        
        LEOSignUpPatientViewController *signUpPatientVC = segue.destinationViewController;
        signUpPatientVC.family = self.family;
        signUpPatientVC.patient = sender;
        signUpPatientVC.managementMode = ManagementModeEdit;
    }
}

- (void)navigateToFeed {
    
    UIStoryboard *feedStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UINavigationController *initialVC = [feedStoryboard instantiateInitialViewController];
    LEOFeedTVC *feedTVC = initialVC.viewControllers[0];
    feedTVC.family = self.family;
    
    [self presentViewController:initialVC animated:NO completion:nil];
}

- (void)continueTapped:(UIButton *)sender {
    
    NSArray *patients = [self.family.patients copy];
    self.family.patients = @[];
    
    LEOUserService *userService = [[LEOUserService alloc] init];
    [userService createGuardian:self.family.guardians[0] withCompletion:^(Guardian *guardian, NSError *error) {
        
        //The guardian that is created should technically take the place of the original, given it will have an id and family_id.
        self.family.guardians = @[guardian];
        
        if (!error) {
            
            [self createPatients:patients withCompletion:^(BOOL success) {
                [self navigateToFeed];
            }];
        }
    }];
}

- (void)createPatients:(NSArray *)patients withCompletion:( void (^) (BOOL success))completionBlock {
    
    __block NSInteger counter = 0;
    
    LEOUserService *userService = [[LEOUserService alloc] init];
    
    [patients enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        [userService createPatient:obj withCompletion:^(Patient *patient, NSError *error) {
            
            if (!error) {
                
                [self.family addPatient:patient];
                
                counter++;
                
                [userService postAvatarForUser:patient withCompletion:^(BOOL success, NSError *error) {
                    
                    if (!error) {
                        
                        NSLog(@"Avatar upload occured successfully!");
                    }
                    
                }];
                
                if (counter == [patients count]) {
                    completionBlock(YES);
                }
            }
        }];
    }];
}

#pragma mark - <UIScrollViewDelegate> & Helper Methods

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (scrollView == self.tableView) {
        
        [self headerCell].headerLabel.alpha = 1 - [self percentHeaderCellHidden] * speedForTitleViewAlphaChangeConstant;
        self.navigationItem.titleView.alpha = [self percentHeaderCellHidden];
        
        if ([self tableViewVerticalContentOffset] >= [self heightOfHeaderCellExcludingOverlapWithNavBar]) {
            
            if (!self.breakerPreviouslyDrawn) {
                
                [self fadeBreaker:YES];
                self.breakerPreviouslyDrawn = YES;
            }
            
        } else {
            
            self.breakerPreviouslyDrawn = NO;
            [self fadeBreaker:NO];
        }
    }
}

- (CGFloat)percentHeaderCellHidden {
    
    return MIN([self tableViewVerticalContentOffset] / [self heightOfHeaderCellExcludingOverlapWithNavBar], 1.0);
}

- (LEOBasicHeaderCell *)headerCell {
    return (LEOBasicHeaderCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
}

- (void)fadeBreaker:(BOOL)shouldFade {
    
    CABasicAnimation *fadeAnimation = [CABasicAnimation animationWithKeyPath:@"breakerFade"];
    fadeAnimation.duration = 0.3;
    
    if (shouldFade) {
        
        [self fadeAnimation:fadeAnimation fromColor:[UIColor clearColor] toColor:[UIColor leoOrangeRed] withStrokeColor:[UIColor leoOrangeRed]];
        
    } else {
        
        [self fadeAnimation:fadeAnimation fromColor:[UIColor clearColor] toColor:[UIColor leoOrangeRed] withStrokeColor:[UIColor leoOrangeRed]];
    }
    
    [self.pathLayer addAnimation:fadeAnimation forKey:@"breakerFade"];
    
}

- (void)fadeAnimation:(CABasicAnimation *)fadeAnimation fromColor:(UIColor *)fromColor toColor:(UIColor *)toColor withStrokeColor:(UIColor *)strokeColor {
    
    fadeAnimation.fromValue = (id)fromColor.CGColor;
    fadeAnimation.toValue = (id)toColor.CGColor;
    
    self.pathLayer.strokeColor = strokeColor.CGColor;
}

- (void)setupBreaker {
    
    CGRect viewRect = self.navigationController.navigationBar.bounds;
    
    CGPoint beginningOfLine = CGPointMake(viewRect.origin.x, 0.0);
    CGPoint endOfLine = CGPointMake(viewRect.origin.x + viewRect.size.width, 0.0);
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:beginningOfLine];
    [path addLineToPoint:endOfLine];
    
    self.pathLayer = [CAShapeLayer layer];
    self.pathLayer.frame = self.view.bounds;
    self.pathLayer.path = path.CGPath;
    self.pathLayer.strokeColor = [UIColor clearColor].CGColor;
    self.pathLayer.lineWidth = 1.0f;
    self.pathLayer.lineJoin = kCALineJoinBevel;
    
    [self.view.layer addSublayer:self.pathLayer];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    
    
    if (scrollView == self.tableView) {
        
        if (!decelerate) {
            [self navigationTitleViewSnapsForScrollView:scrollView];
        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    if (scrollView == self.tableView) {
        [self navigationTitleViewSnapsForScrollView:scrollView];
    }
}

- (void)navigationTitleViewSnapsForScrollView:(UIScrollView *)scrollView {
    
    if ([self tableViewVerticalContentOffset] > [self heightOfNoReturn] & scrollView.contentOffset.y < [self heightOfHeaderCell]) {
        
        
        [UIView animateWithDuration:0.1 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            
            [scrollView layoutIfNeeded];
            self.navigationItem.titleView.alpha = 1;
            scrollView.contentOffset = CGPointMake(0.0, [ self heightOfHeaderCellExcludingOverlapWithNavBar]);
        } completion:nil];
        
        
    } else if ([self tableViewVerticalContentOffset] < [self heightOfNoReturn]) {
        
        
        [UIView animateWithDuration:0.1 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            
            [scrollView layoutIfNeeded];
            self.navigationItem.titleView.alpha = 0;
            scrollView.contentOffset = CGPointMake(0.0, 0.0);
        } completion:nil];
    }
}


#pragma mark - Layout

- (CGSize)preferredContentSize
{
    // Force the table view to calculate its height
    [self.tableView layoutIfNeeded];
    
    CGFloat heightWeWouldLikeTheTableViewContentAreaToBe = [self heightOfTableViewFrame] + [self heightOfHeaderCellExcludingOverlapWithNavBar];
    
    if ([self totalHeightOfTableViewContentArea] > [self heightOfTableViewFrame] && [self totalHeightOfTableViewContentArea] < heightWeWouldLikeTheTableViewContentAreaToBe) {
        
        CGFloat bottomInsetWeNeedToGetToHeightWeWouldLikeTheTableViewContentAreaToBe = heightWeWouldLikeTheTableViewContentAreaToBe - [self totalHeightOfTableViewContentArea];
        self.tableView.contentInset = UIEdgeInsetsMake(0, 0, bottomInsetWeNeedToGetToHeightWeWouldLikeTheTableViewContentAreaToBe, 0);
    }
    
    [self.tableView layoutIfNeeded];
    
    return self.tableView.contentSize;
}


#pragma mark - Shorthand Helpers

- (CGFloat)heightOfTableViewFrame {
    return self.tableView.frame.size.height;
}

- (CGFloat)totalHeightOfTableViewContentArea {
    return self.tableView.contentSize.height + self.tableView.contentInset.bottom;
}

- (CGFloat)heightOfNoReturn {
    return [self heightOfHeaderCell] * heightOfNoReturnConstant;
}

- (CGFloat)heightOfHeaderCellExcludingOverlapWithNavBar {
    
    return [self heightOfHeaderCell] - [self navBarHeight];
}

- (CGFloat)heightOfHeaderCell {
    return [self.tableView rectForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]].size.height;
}

- (CGFloat)navBarHeight {
    return self.navigationController.navigationBar.frame.size.height;
}

- (CGFloat)tableViewVerticalContentOffset {
    return self.tableView.contentOffset.y;
}

@end
