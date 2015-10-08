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

#import "UIImage+Extensions.h"

typedef enum TableViewSection {
    
    TableViewSectionTitle = 0,
    TableViewSectionGuardians = 1,
    TableViewSectionPatients = 2,
    TableViewSectionButton = 3
    
} TableViewSection;
@interface LEOReviewOnboardingViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UINavigationBar *navigationBar;
@property (strong, nonatomic) UILabel *navTitleLabel;
@property (strong, nonatomic) CAShapeLayer *pathLayer;
@property (nonatomic) BOOL breakerPreviouslyDrawn;

@end

@implementation LEOReviewOnboardingViewController


#pragma mark - Constants

static NSString *const kHeaderCellReuseIdentifier = @"LEOBasicHeaderCell";
static NSString *const kReviewUserCellReuseIdentifer = @"ReviewUserCell";
static NSString *const kReviewPatientCellReuseIdentifer = @"ReviewPatientCell";
static NSString *const kButtonCellReuseIdentifier = @"ButtonCell";
static NSString *const kReviewUserSegue = @"ReviewUserSegue";
static NSString *const kReviewPatientSegue = @"ReviewPatientSegue";
static CGFloat const heightOfNoReturnConstant = 0.4;
static CGFloat const speedForTitleViewAlphaChangeConstant = 4.0;


#pragma mark - View Controller Lifecycle and Helper Methods

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self setupNavigationBar];
    [self setupBreaker];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [self setupTableView];
    [self.tableView reloadData];
}

- (void)setupNavigationBar {
    
    [LEOStyleHelper styleNavigationBarForOnboarding];
    
    self.navTitleLabel = [[UILabel alloc] init];
    self.navTitleLabel.text = @"Check yo' self";
    
    [LEOStyleHelper styleLabelForNavigationHeaderForOnboarding:self.navTitleLabel];
    
    UINavigationItem *item = [[UINavigationItem alloc] init];
    item.titleView = self.navTitleLabel;
    [self.navigationBar pushNavigationItem:item animated:NO];
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

- (void)continueTapped:(UIButton *)sender {
    
    LEOUserService *userService = [[LEOUserService alloc] init];
    
    [userService createUserWithFamily:self.family withCompletion:^(BOOL success, NSError *error) {
        
        if (!error) {
            
            if ([self isModal]) {
                [self dismissViewControllerAnimated:self completion:nil];
            } else {
                UIStoryboard *feedStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                UIViewController *initialVC = [feedStoryboard instantiateInitialViewController];
                [self presentViewController:initialVC animated:NO completion:nil];
            }
        }
    }];
    
}


#pragma mark - <UIScrollViewDelegate> & Helper Methods

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (scrollView == self.tableView) {
        
        LEOBasicHeaderCell *headerCell = (LEOBasicHeaderCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        CGFloat percentHeaderCellHidden = [self tableViewVerticalContentOffset] / [self heightOfHeaderCellExcludingOverlapWithNavBar];
        
        if (percentHeaderCellHidden < 1) {
            headerCell.headerLabel.alpha = 1 - percentHeaderCellHidden * speedForTitleViewAlphaChangeConstant;
            self.navTitleLabel.alpha = percentHeaderCellHidden;
        }
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

- (void)fadeBreaker:(BOOL)shouldFade {
    
    if (shouldFade) {
        
        CABasicAnimation *fadeAnimation = [CABasicAnimation animationWithKeyPath:@"breakerFade"];
        fadeAnimation.duration = 0.3;
        fadeAnimation.fromValue = (id)[UIColor clearColor].CGColor;
        fadeAnimation.toValue = (id)[UIColor leoOrangeRed].CGColor;
        
        self.pathLayer.strokeColor = [UIColor leoOrangeRed].CGColor;
        [self.pathLayer addAnimation:fadeAnimation forKey:@"breakerFade"];
        
    } else {
        
        CABasicAnimation *fadeAnimation = [CABasicAnimation animationWithKeyPath:@"breakerFade"];
        fadeAnimation.duration = 0.3;
        fadeAnimation.fromValue = (id)[UIColor leoOrangeRed].CGColor;
        fadeAnimation.toValue = (id)[UIColor clearColor].CGColor;
        
        self.pathLayer.strokeColor = [UIColor clearColor].CGColor;
        [self.pathLayer addAnimation:fadeAnimation forKey:@"breakerFade"];
    }
}

- (void)setupBreaker {
    
    [self.navigationBar layoutIfNeeded];
    
    CGRect viewRect = self.navigationBar.bounds;
    
    CGPoint beginningOfLine = CGPointMake(viewRect.origin.x, viewRect.origin.y + viewRect.size.height);
    CGPoint endOfLine = CGPointMake(viewRect.origin.x + viewRect.size.width, viewRect.origin.y + viewRect.size.height);
    
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
            [self scrollView:scrollView snapWithNavigationTitleLabel:self.navTitleLabel];
        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    if (scrollView == self.tableView) {
        [self scrollView:scrollView snapWithNavigationTitleLabel:self.navTitleLabel];
    }
}

- (void)scrollView:(UIScrollView *)scrollView snapWithNavigationTitleLabel:(UILabel *)label {
    
    if ([self tableViewVerticalContentOffset] > [self heightOfNoReturn] & scrollView.contentOffset.y < [self heightOfHeaderCell]) {
        
        
        [UIView animateWithDuration:0.1 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            
            [scrollView layoutIfNeeded];
            label.alpha = 1;
            scrollView.contentOffset = CGPointMake(0.0, [ self heightOfHeaderCellExcludingOverlapWithNavBar]);
        } completion:nil];
        
        
    } else if ([self tableViewVerticalContentOffset] < [self heightOfNoReturn]) {
        
        
        [UIView animateWithDuration:0.1 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            
            [scrollView layoutIfNeeded];
            label.alpha = 0;
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
