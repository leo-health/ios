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

#import "LEOSignUpPatientViewController.h"
#import "LEOSignUpUserViewController.h"

#import "UIColor+LeoColors.h"
#import "UIFont+LeoFonts.h"
#import "UIView+Extensions.h"

#import "LEOStyleHelper.h"

#import "LEOFeedTVC.h"
#import "LEOWebViewController.h"

#import "UIImage+Extensions.h"

#import <MBProgressHUD/MBProgressHUD.h>

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

    [LEOApiReachability startMonitoringForController:self];
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

    self.tableView.tableFooterView = [self buildAgreeViewFromString:@"By clicking subscribe you agree to our #<ts>terms of service# and #<pp>privacy policies#."];
    self.tableView.tableFooterView.bounds = CGRectInset(self.tableView.tableFooterView.bounds, 0.0, -10.0);
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

//Adapted from http://stackoverflow.com/questions/20541676/ios-uitextview-or-uilabel-with-clickable-links-to-actions
- (UIView *)buildAgreeViewFromString:(NSString *)localizedString {

    UIView *agreeView = [UIView new];
    CGRect agreeFrame = CGRectMake(30,0,[UIScreen mainScreen].bounds.size.width - 60,74);
    agreeView.frame = agreeFrame;

    // 1. Split the localized string on the # sign:
    NSArray *localizedStringPieces = [localizedString componentsSeparatedByString:@"#"];

    // 2. Loop through all the pieces:
    NSUInteger msgChunkCount = localizedStringPieces ? localizedStringPieces.count : 0;
    CGPoint wordLocation = CGPointMake(0.0, 0.0);
    for (NSUInteger i = 0; i < msgChunkCount; i++)
    {
        NSString *chunk = [localizedStringPieces objectAtIndex:i];
        if ([chunk isEqualToString:@""])
        {
            continue;     // skip this loop if the chunk is empty
        }

        // 3. Determine what type of word this is:
        BOOL isTermsOfServiceLink = [chunk hasPrefix:@"<ts>"];
        BOOL isPrivacyPolicyLink  = [chunk hasPrefix:@"<pp>"];
        BOOL isLink = (BOOL)(isTermsOfServiceLink || isPrivacyPolicyLink);

        // 4. Create label, styling dependent on whether it's a link:
        UILabel *label = [UILabel new];
        label.font = [UIFont leo_standardFont];
        label.text = chunk;
        label.userInteractionEnabled = isLink;

        if (isLink)
        {
            label.textColor = [UIColor leo_blue];

            // 5. Set tap gesture for this clickable text:
            SEL selectorAction = isTermsOfServiceLink ? @selector(tapOnTermsOfServiceLink:) : @selector(tapOnPrivacyPolicyLink:);
            UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                         action:selectorAction];
            [label addGestureRecognizer:tapGesture];

            // Trim the markup characters from the label:
            if (isTermsOfServiceLink)
                label.text = [label.text stringByReplacingOccurrencesOfString:@"<ts>" withString:@""];
            if (isPrivacyPolicyLink)
                label.text = [label.text stringByReplacingOccurrencesOfString:@"<pp>" withString:@""];
        }
        else
        {
            label.textColor = [UIColor leo_grayStandard];
        }

        // 6. Lay out the labels so it forms a complete sentence again:

        // If this word doesn't fit at end of this line, then move it to the next
        // line and make sure any leading spaces are stripped off so it aligns nicely:

        [label sizeToFit];

        if (agreeView.frame.size.width < wordLocation.x + label.bounds.size.width)
        {
            wordLocation.x = 0.0;                       // move this word all the way to the left...
            wordLocation.y += label.frame.size.height;  // ...on the next line

            // And trim of any leading white space:
            NSRange startingWhiteSpaceRange = [label.text rangeOfString:@"^\\s*"
                                                                options:NSRegularExpressionSearch];
            if (startingWhiteSpaceRange.location == 0)
            {
                label.text = [label.text stringByReplacingCharactersInRange:startingWhiteSpaceRange
                                                                 withString:@""];
                [label sizeToFit];
            }
        }

        // Set the location for this label:
        label.frame = CGRectMake(wordLocation.x,
                                 wordLocation.y,
                                 label.frame.size.width,
                                 label.frame.size.height);


        [agreeView addSubview:label];

        // Update the horizontal position for the next word:
        wordLocation.x += label.frame.size.width;
    }

    return agreeView;
}

- (void)tapOnTermsOfServiceLink:(UITapGestureRecognizer *)tapGesture {

    if (tapGesture.state == UIGestureRecognizerStateEnded) {
        [self performSegueWithIdentifier:kSegueTermsAndConditions sender:nil];
    }
}


- (void)tapOnPrivacyPolicyLink:(UITapGestureRecognizer *)tapGesture {

    if (tapGesture.state == UIGestureRecognizerStateEnded) {
        [self performSegueWithIdentifier:kSeguePrivacyPolicy sender:nil];
    }
}

- (void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section {

    view.tintColor = [UIColor leo_white];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {

    switch (section) {
        case TableViewSectionTitle:
            return 20.0;
            break;

        case TableViewSectionPatients:
        case TableViewSectionGuardians:
        case TableViewSectionButton:
            return CGFLOAT_MIN;
            break;
    }

    return CGFLOAT_MIN;
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
        signUpPatientVC.feature = FeatureOnboarding;
        signUpPatientVC.managementMode = ManagementModeEdit;
    }

    if ([segue.identifier isEqualToString:kSegueTermsAndConditions]) {

        LEOWebViewController *webVC = (LEOWebViewController *)segue.destinationViewController;
        webVC.urlString = kURLTermsAndConditions;
        webVC.titleString = @"Terms & Conditions";
        webVC.feature = FeatureOnboarding;

    }

    if ([segue.identifier isEqualToString:kSeguePrivacyPolicy]) {

        LEOWebViewController *webVC = (LEOWebViewController *)segue.destinationViewController;
        webVC.urlString = kURLPrivacyPolicy;
        webVC.titleString = @"Privacy Policy";
        webVC.feature = FeatureOnboarding;

    }
}

- (void)navigateToFeed {

    UIStoryboard *feedStoryboard = [UIStoryboard storyboardWithName:kStoryboardFeed bundle:nil];
    UINavigationController *initialVC = [feedStoryboard instantiateInitialViewController];
    LEOFeedTVC *feedTVC = initialVC.viewControllers[0];
    feedTVC.family = self.family;

    [self presentViewController:initialVC animated:NO completion:nil];
}

- (void)continueTapped:(UIButton *)sender {

    __block UIButton *button = ((LEOButtonCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:4]]).button;

    button.userInteractionEnabled = NO;

    NSArray *patients = [self.family.patients copy];
    self.family.patients = @[];

    [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    LEOUserService *userService = [[LEOUserService alloc] init];
    [userService createGuardian:self.family.guardians[0] withCompletion:^(Guardian *guardian, NSError *error) {

        if (!error && guardian) {

            //The guardian that is created should technically take the place of the original, given it will have an id and family_id.t
            self.family.guardians = @[guardian];


            [self createPatients:patients withCompletion:^(BOOL success) {

                if (success) {
                    [self navigateToFeed];
                }

                [MBProgressHUD hideHUDForView:self.view animated:YES];
                button.userInteractionEnabled = YES;

            }];
        }

        button.userInteractionEnabled = YES;
        [MBProgressHUD hideHUDForView:self.view animated:YES];

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

        [self headerCell].headerLabel.alpha = 1 - [self percentHeaderCellHidden] * kSpeedForTitleViewAlphaChangeConstant;
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

        [self fadeAnimation:fadeAnimation fromColor:[UIColor clearColor] toColor:[UIColor leo_orangeRed] withStrokeColor:[UIColor leo_orangeRed]];

    } else {

        [self fadeAnimation:fadeAnimation fromColor:[UIColor clearColor] toColor:[UIColor leo_orangeRed] withStrokeColor:[UIColor leo_orangeRed]];
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
    return [self heightOfHeaderCell] * kHeightOfNoReturnConstant;
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
