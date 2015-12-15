//
//  LEOSIgnUpUserViewController.m
//  Leo
//
//  Created by Zachary Drossman on 9/2/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import "LEOSignUpUserViewController.h"

#import "UIImage+Extensions.h"


//TODO: Eventually remove these and the code related to them from this VC!
#import "UIFont+LeoFonts.h"
#import "UIColor+LeoColors.h"

#import "LEOSignUpUserView.h"
#import "LEOPromptView.h"

#import "LEOBasicSelectionViewController.h"
#import "InsurancePlanCell+ConfigureCell.h"
#import "InsurancePlan.h"
#import "Insurer.h"
#import "LEOAPIInsuranceOperation.h"

#import "LEOValidationsHelper.h"
#import "LEOPromptView.h"

#import "LEOManagePatientsViewController.h"

#import "Guardian.h"
#import "LEOUserService.h"
#import "LEOStyleHelper.h"
#import "UIView+Extensions.h"
#import <TPKeyboardAvoidingScrollView.h>

@interface LEOSignUpUserViewController ()

@property (weak, nonatomic) LEOSignUpUserView *signUpUserView;
@property (nonatomic) BOOL breakerPreviouslyDrawn;
@property (strong, nonatomic) CAShapeLayer *pathLayer;

@end

@implementation LEOSignUpUserViewController

@synthesize guardian = _guardian;

#pragma mark - View Controller Lifecycle & Helper Methods

- (void)viewDidLoad {
    [super viewDidLoad];

    [LEOStyleHelper tintColorForFeature:FeatureOnboarding];

    [self setupBreaker];
    [self setupNavigationBar];
    [self setupButton];

    self.signUpUserView.guardian = self.guardian;
    self.signUpUserView.insurancePlan = self.guardian.insurancePlan;
    self.signUpUserView.scrollView.delegate = self;
    self.signUpUserView.insurerPromptView.delegate = self;

    [LEOApiReachability startMonitoringForController:self];
}

- (void)viewWillAppear:(BOOL)animated {

    self.navigationItem.titleView.hidden = YES;
}

- (void)viewDidAppear:(BOOL)animated {

    [self toggleNavigationBarTitleView];
}



- (void)setupNavigationBar {

    self.view.tintColor = [LEOStyleHelper tintColorForFeature:FeatureOnboarding];
    [LEOStyleHelper styleNavigationBarForFeature:FeatureOnboarding];

    UILabel *navTitleLabel = [[UILabel alloc] init];
    //    navTitleLabel.text = @"About Me";

    [LEOStyleHelper styleLabel:navTitleLabel forFeature:FeatureOnboarding];

    self.navigationItem.titleView = navTitleLabel;
    [LEOStyleHelper styleBackButtonForViewController:self forFeature:FeatureOnboarding];
}

- (void)toggleNavigationBarTitleView {

    self.navigationItem.titleView.hidden = NO;
    self.navigationItem.titleView.alpha = (self.scrollView.contentOffset.y == 0) ? 0:1;
}


- (void)setupButton {

    [LEOStyleHelper styleButton:self.signUpUserView.continueButton forFeature:FeatureOnboarding];

    [self.signUpUserView.continueButton addTarget:self action:@selector(continueTapped:) forControlEvents:UIControlEventTouchUpInside];
}

- (Family *)family {

    if (!_family) {
        _family = [Family new];
    }

    return _family;
}

-(LEOSignUpUserView *)signUpUserView {

    if (!_signUpUserView) {

        LEOSignUpUserView *strongView = [LEOSignUpUserView new];

        _signUpUserView = strongView;

        [self.view removeConstraints:self.view.constraints];
        self.signUpUserView.translatesAutoresizingMaskIntoConstraints = NO;

        [self.view addSubview:_signUpUserView];

        NSDictionary *bindings = NSDictionaryOfVariableBindings(_signUpUserView);

        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_signUpUserView]|" options:0 metrics:nil views:bindings]];
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_signUpUserView]|" options:0 metrics:nil views:bindings]];
    }

    return _signUpUserView;
}

#pragma mark - <LEOPromptDelegate>

- (void)respondToPrompt:(id)sender {

    if (sender == self.signUpUserView.insurerPromptView) {

        [self performSegueWithIdentifier:kSeguePlan sender:nil];
    }
}


#pragma mark - Navigation & Helper Methods

- (void)continueTapped:(UIButton *)sender {

    if ([self.signUpUserView validView]) {

        [self updateGuardian];

        switch (self.managementMode) {
            case ManagementModeCreate:
                [self.family addGuardian:self.guardian];
                [self performSegueWithIdentifier:kSegueContinue sender:sender];
                break;

            case ManagementModeEdit:
                [self pop];
                break;

            case ManagementModeUndefined:
                break;
        }
    }
}

- (void)updateGuardian {

    _guardian.firstName = self.signUpUserView.guardian.firstName;
    _guardian.lastName = self.signUpUserView.guardian.lastName;
    _guardian.insurancePlan = self.signUpUserView.guardian.insurancePlan;
    _guardian.phoneNumber = self.signUpUserView.guardian.phoneNumber;
}

- (void)setGuardian:(Guardian *)guardian {

    _guardian = guardian;
    self.signUpUserView.guardian = [guardian copy];
    self.signUpUserView.insurancePlan = [guardian.insurancePlan copy];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    if ([segue.identifier isEqualToString:kSeguePlan]) {

        LEOBasicSelectionViewController *insurancePlanSelectionVC = segue.destinationViewController;

        [self setupInsurancePlanVC:insurancePlanSelectionVC];
    }

    if ([segue.identifier isEqualToString:kSegueContinue]) {

        LEOManagePatientsViewController *manageChildrenVC = segue.destinationViewController;

        manageChildrenVC.family = self.family;
        manageChildrenVC.enrollmentToken = self.enrollmentToken;
    }

    [self.view endEditing:YES];
}

- (void)setupInsurancePlanVC:(LEOBasicSelectionViewController *)insurancePlanVC {

    __block BOOL shouldSelect = NO;

    insurancePlanVC.key = @"name";
    insurancePlanVC.reuseIdentifier = @"InsurancePlanCell";
    insurancePlanVC.titleText = @"Who is your insurer?";
    insurancePlanVC.feature = FeatureOnboarding;

    insurancePlanVC.configureCellBlock = ^(InsurancePlanCell *cell, InsurancePlan *plan) {

        cell.selectedColor = [UIColor leo_orangeRed];

        shouldSelect = NO;

        [cell configureForPlan:plan];

        if ([plan.objectID isEqualToString:self.guardian.insurancePlan.combinedName]) {
            shouldSelect = YES;
        }

        return shouldSelect;
    };

    insurancePlanVC.requestOperation = [[LEOAPIInsuranceOperation alloc] init];
    insurancePlanVC.delegate = self;
}

- (void)pop {

    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - <SingleSelectionProtocol>

-(void)didUpdateItem:(id)item forKey:(NSString *)key {
    self.signUpUserView.insurancePlan = (InsurancePlan *)item;
}


//TODO: ZSD - All the below code will be moved out into helper methods eventually, so do not try to optimize juuuust yet.

#pragma mark - <UIScrollViewDelegate> & Helper Methods

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {

    if (scrollView == [self scrollView]) {

        [self headerView].alpha = 1 - [self percentHeaderViewHidden] * kSpeedForTitleViewAlphaChangeConstant;
        self.navigationItem.titleView.alpha = [self percentHeaderViewHidden];

        if ([self scrollViewVerticalContentOffset] >= [self heightOfHeaderView]) {

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

- (CGFloat)percentHeaderViewHidden {

    return MIN([self scrollViewVerticalContentOffset] / [self heightOfHeaderView], 1.0);
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


    if (scrollView == [self scrollView]) {

        if (!decelerate) {
            [self navigationTitleViewSnapsForScrollView:scrollView];
        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {

    if (scrollView == [self scrollView]) {
        [self navigationTitleViewSnapsForScrollView:scrollView];
    }
}

- (void)navigationTitleViewSnapsForScrollView:(UIScrollView *)scrollView {

    if ([self scrollViewVerticalContentOffset] > [self heightOfNoReturn] & scrollView.contentOffset.y < [self heightOfHeaderView]) {


        [UIView animateWithDuration:0.1 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{

            [scrollView layoutIfNeeded];
            self.navigationItem.titleView.alpha = 1;
            scrollView.contentOffset = CGPointMake(0.0, [ self heightOfHeaderView]);
        } completion:nil];


    } else if ([self scrollViewVerticalContentOffset] < [self heightOfNoReturn]) {


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
    [[self scrollView] layoutIfNeeded];

    CGFloat heightWeWouldLikeTheScrollViewContentAreaToBe = [self heightOfScrollViewFrame] + [self heightOfHeaderView];

    if ([self totalHeightOfScrollViewContentArea] > [self heightOfScrollViewFrame] && [self totalHeightOfScrollViewContentArea] < heightWeWouldLikeTheScrollViewContentAreaToBe) {

        CGFloat bottomInsetWeNeedToGetToHeightWeWouldLikeTheScrollViewContentAreaToBe = heightWeWouldLikeTheScrollViewContentAreaToBe - [self totalHeightOfScrollViewContentArea];
        [self scrollView].contentInset = UIEdgeInsetsMake(0, 0, bottomInsetWeNeedToGetToHeightWeWouldLikeTheScrollViewContentAreaToBe, 0);
    }

    [[self scrollView] layoutIfNeeded];

    return [self scrollView].contentSize;
}


#pragma mark - Shorthand Helpers

- (CGFloat)heightOfScrollViewFrame {
    return [self scrollView].frame.size.height;
}

- (CGFloat)totalHeightOfScrollViewContentArea {
    return [self scrollView].contentSize.height + [self scrollView].contentInset.bottom;
}

- (CGFloat)heightOfNoReturn {
    return [self heightOfHeaderView] * kHeightOfNoReturnConstant;
}

- (CGFloat)heightOfHeaderCellExcludingOverlapWithNavBar {
    
    return [self heightOfHeaderView] - [self navBarHeight];
}

- (CGFloat)heightOfHeaderView {
    return [self headerView].bounds.size.height;
}

- (CGFloat)navBarHeight {
    return self.navigationController.navigationBar.frame.size.height;
}

- (CGFloat)scrollViewVerticalContentOffset {
    return [self scrollView].contentOffset.y;
}

- (UIView *)headerView {
    return self.signUpUserView.headerView;
}
- (UIScrollView *)scrollView {
    return self.signUpUserView.scrollView;
}

@end
