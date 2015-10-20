//
//  LEOManagePatientsViewController.m
//  Leo
//
//  Created by Zachary Drossman on 9/30/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import "LEOManagePatientsViewController.h"

//TODO: Remove these from this class when possible!
#import "UIFont+LeoFonts.h"
#import "UIColor+LeoColors.h"
#import "UIImage+Extensions.h"
#import "UIViewController+Extensions.h"

#import "LEOPromptViewCell+ConfigureForCell.h"
#import "LEOBasicHeaderCell+ConfigureForCell.h"
#import "LEOReviewPatientCell+ConfigureForCell.h"
#import "LEOButtonCell.h"

#import "Patient.h"
#import "Family.h"

#import "LEOReviewOnboardingViewController.h"
#import "LEOStyleHelper.h"

static NSString *const kSignUpPatientSegue = @"SignUpPatientSegue";

typedef enum TableViewSection {
    
    TableViewSectionTitle = 0,
    TableViewSectionPatients = 1,
    TableViewSectionAddPatient = 2,
    TableViewSectionButton = 3
    
} TableViewSection;

@interface LEOManagePatientsViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) UILabel *navTitleLabel;
@property (strong, nonatomic) CAShapeLayer *pathLayer;
@property (nonatomic) BOOL breakerPreviouslyDrawn;

@end

@implementation LEOManagePatientsViewController

#pragma mark - View Controller Lifecycle and Helpers

- (void)viewDidLoad {
    
    [super viewDidLoad];

    self.view.tintColor = [LEOStyleHelper tintColorForFeature:FeatureOnboarding];
    
    [self setupBreaker];
    [self setupNavigationBar];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [self testData];

    [self setupTableView];
    [self.tableView reloadData];
    
}

- (void)viewDidAppear:(BOOL)animated {
    
    self.navigationItem.titleView.alpha = 0;
    self.navigationItem.titleView.hidden = NO;
}

- (void)setupNavigationBar {
    
    [LEOStyleHelper styleNavigationBarForFeature:FeatureOnboarding];

    self.navTitleLabel = [[UILabel alloc] init];
    self.navTitleLabel.text = @"Review children";
    
    [LEOStyleHelper styleLabel:self.navTitleLabel forFeature:FeatureOnboarding];

    self.navigationItem.titleView = self.navTitleLabel;
    self.navigationItem.titleView.hidden = YES;
     [LEOStyleHelper styleBackButtonForViewController:self];
}

- (void)setupTableView {
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;

    [self.tableView registerNib:[LEOBasicHeaderCell nib]
         forCellReuseIdentifier:kHeaderCellReuseIdentifier];
    [self.tableView registerNib:[LEOPromptViewCell nib]
         forCellReuseIdentifier:kPromptViewCellReuseIdentifier];
    [self.tableView registerNib:[LEOButtonCell nib] forCellReuseIdentifier:kButtonCellReuseIdentifier];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.tableView.estimatedRowHeight = 100.0;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    self.tableView.alwaysBounceVertical = NO;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    switch (section) {
            
        case TableViewSectionTitle:
            return 1;
            
        case TableViewSectionPatients:
            return [self.family.patients count];
            
        case TableViewSectionAddPatient:
            return 1;
            
        case TableViewSectionButton:
            return 1;
    }
    
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.section) {
            
        case TableViewSectionTitle: {

            LEOBasicHeaderCell *basicHeaderCell = [tableView dequeueReusableCellWithIdentifier:kHeaderCellReuseIdentifier];
            
            [basicHeaderCell configureWithTitle:@"Review or add more children"];
            
            return basicHeaderCell;
        }
            
        case TableViewSectionPatients: {
            
            Patient *patient = self.family.patients[indexPath.row];

            LEOPromptViewCell *cell = [tableView
                                       dequeueReusableCellWithIdentifier:kPromptViewCellReuseIdentifier
                                       forIndexPath:indexPath];

            [cell configureForPatient:patient];
            
            return cell;
        }
            
        case TableViewSectionAddPatient: {
            
            LEOPromptViewCell *cell = [tableView
                                       dequeueReusableCellWithIdentifier:kPromptViewCellReuseIdentifier
                                       forIndexPath:indexPath];

            [cell configureForNewPatient];

            return cell;
        }
            
        case TableViewSectionButton: {
            
            LEOButtonCell *buttonCell = [tableView dequeueReusableCellWithIdentifier:kButtonCellReuseIdentifier];
            
            [buttonCell.button addTarget:self action:@selector(continueTapped:) forControlEvents:UIControlEventTouchUpInside];
            
            return buttonCell;
        }
    }
    
    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.section) {
        case TableViewSectionPatients: {
            
            Patient *patient = self.family.patients[indexPath.row];
            [self performSegueWithIdentifier:kSignUpPatientSegue sender:patient];
            break;
        }
            
        case TableViewSectionAddPatient: {
            
            [self performSegueWithIdentifier:kSignUpPatientSegue sender:nil];
            break;
        }
            
        case TableViewSectionTitle:
        case TableViewSectionButton:
            break;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.section) {
        case TableViewSectionTitle:
            return 130.0;
            
        case TableViewSectionAddPatient:
        case TableViewSectionPatients:
        case TableViewSectionButton:
            return UITableViewAutomaticDimension;
    }
    
    return UITableViewAutomaticDimension;
}

-(void)continueTapped:(UIButton * __nonnull)sender {
    
    [self performSegueWithIdentifier:kSegueContinue sender:sender];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:kSignUpPatientSegue]) {
        
        LEOSignUpPatientViewController *signUpPatientVC = segue.destinationViewController;
        signUpPatientVC.family = self.family;
        signUpPatientVC.patient = (Patient *)sender;
        
        if (sender) {
            signUpPatientVC.managementMode = ManagementModeEdit;
        } else {
            signUpPatientVC.managementMode = ManagementModeCreate;
        }
        
        signUpPatientVC.view.tintColor = [LEOStyleHelper tintColorForFeature:FeatureOnboarding];
        
        signUpPatientVC.delegate = self;
    }
    
    if ([segue.identifier isEqualToString:kSegueContinue]) {
        
        LEOReviewOnboardingViewController *reviewOnboardingVC = segue.destinationViewController;
        reviewOnboardingVC.family = self.family;
    }
}

- (NSInteger)tableView:(UITableView *)tableView currentRowForIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger sumSections = 0;
    
    for (NSInteger i = 0; i < indexPath.section; i++) {
        NSInteger rowsInSection = [tableView numberOfRowsInSection:i];
        sumSections += rowsInSection;
    }
    
    return sumSections + indexPath.row;
}

- (void)addPatient:(Patient *)patient {
    
    [self.family addPatient:patient];
    [self.tableView reloadData];
}

#pragma mark - Navigation

- (void)pop {
    
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - <UIScrollViewDelegate> & Helper Methods

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (scrollView == self.tableView) {
        
        LEOBasicHeaderCell *headerCell = (LEOBasicHeaderCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        CGFloat percentHeaderCellHidden = [self tableViewVerticalContentOffset] / [self heightOfHeaderCell];
        
        if (percentHeaderCellHidden < 1) {
            headerCell.headerLabel.alpha = 1 - percentHeaderCellHidden * speedForTitleViewAlphaChangeConstant;
            self.navTitleLabel.alpha = percentHeaderCellHidden;
        }
        
        if ([self tableViewVerticalContentOffset] >= [self heightOfHeaderCell]) {
            
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
    
    
    CGRect viewRect = self.navigationController.navigationBar.bounds;
    
    CGPoint beginningOfLine = CGPointMake(viewRect.origin.x, 0.0f);
    CGPoint endOfLine = CGPointMake(viewRect.origin.x + viewRect.size.width, 0.0f);
    
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
            scrollView.contentOffset = CGPointMake(0.0, [ self heightOfHeaderCell]);
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
    
    CGFloat heightWeWouldLikeTheTableViewContentAreaToBe = [self heightOfTableViewFrame] + [self heightOfHeaderCell];
    
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

#pragma mark - Test Data

- (void)testData {
    
    Patient *patient = [[Patient alloc] initWithTitle:nil firstName:@"Zachary" middleInitial:@"S" lastName:@"Drossman" suffix:nil email:nil avatar:[UIImage imageNamed:@"Avatar-Emily"] dob:[NSDate date] gender:@"M" status:[@(PatientStatusInactive) stringValue]];
    
    Patient *patient2 = [[Patient alloc] initWithTitle:nil firstName:@"Zachary" middleInitial:@"S" lastName:@"Drossman" suffix:nil email:nil avatar:[UIImage imageNamed:@"Avatar-Emily"] dob:[NSDate date] gender:@"M" status:[@(PatientStatusInactive) stringValue]];
    
    Patient *patient3 = [[Patient alloc] initWithTitle:nil firstName:@"Zachary" middleInitial:@"S" lastName:@"Drossman" suffix:nil email:nil avatar:[UIImage imageNamed:@"Avatar-Emily"] dob:[NSDate date] gender:@"M" status:[@(PatientStatusInactive) stringValue]];
    
    Patient *patient4 = [[Patient alloc] initWithTitle:nil firstName:@"Zachary" middleInitial:@"S" lastName:@"Drossman" suffix:nil email:nil avatar:[UIImage imageNamed:@"Avatar-Emily"] dob:[NSDate date] gender:@"M" status:[@(PatientStatusInactive) stringValue]];
    
    Patient *patient5 = [[Patient alloc] initWithTitle:nil firstName:@"Zachary" middleInitial:@"S" lastName:@"Drossman" suffix:nil email:nil avatar:[UIImage imageNamed:@"Avatar-Emily"] dob:[NSDate date] gender:@"M" status:[@(PatientStatusInactive) stringValue]];
    
//    Patient *patient6 = [[Patient alloc] initWithTitle:nil firstName:@"Zachary" middleInitial:@"S" lastName:@"Drossman" suffix:nil email:nil avatar:[UIImage imageNamed:@"Avatar-Emily"] dob:[NSDate date] gender:@"M" status:[@(PatientStatusInactive) stringValue]];
//    
//    Patient *patient7 = [[Patient alloc] initWithTitle:nil firstName:@"Zachary" middleInitial:@"S" lastName:@"Drossman" suffix:nil email:nil avatar:[UIImage imageNamed:@"Avatar-Emily"] dob:[NSDate date] gender:@"M" status:[@(PatientStatusInactive) stringValue]];
//    
//    Patient *patient8 = [[Patient alloc] initWithTitle:nil firstName:@"Zachary" middleInitial:@"S" lastName:@"Drossman" suffix:nil email:nil avatar:[UIImage imageNamed:@"Avatar-Emily"] dob:[NSDate date] gender:@"M" status:[@(PatientStatusInactive) stringValue]];
    
    self.family.patients = @[patient, patient2, patient3, patient4, patient5]; //, patient6, patient7, patient8];
}


@end
