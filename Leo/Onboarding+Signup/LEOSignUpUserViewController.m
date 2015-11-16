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
#import "LEOApiReachability.h"

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

@property (strong, nonatomic) LEOSignUpUserView *signUpUserView;
@property (nonatomic) BOOL breakerPreviouslyDrawn;
@property (strong, nonatomic) CAShapeLayer *pathLayer;

@end

@implementation LEOSignUpUserViewController



#pragma mark - View Controller Lifecycle & Helper Methods

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [LEOStyleHelper tintColorForFeature:FeatureOnboarding];
    
    [self setupSignUpUserView];
    [self setupBreaker];
    [self setupNavigationBar];
    [self setupFirstNameField];
    [self setupLastNameField];
    [self setupPhoneNumberField];
    [self setupInsurerPromptView];
    [self setupButton];
    
    
}

- (void)viewWillAppear:(BOOL)animated {
    
    self.navigationItem.titleView.hidden = YES;
}

- (void)viewDidAppear:(BOOL)animated {
    
    [self toggleNavigationBarTitleView];
    
}

- (void)setupSignUpUserView {
    
    [self.view addSubview:self.signUpUserView];
    
    [self.view removeConstraints:self.view.constraints];
    self.signUpUserView.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSDictionary *bindings = NSDictionaryOfVariableBindings(_signUpUserView);
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_signUpUserView]|" options:0 metrics:nil views:bindings]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_signUpUserView]|" options:0 metrics:nil views:bindings]];

    
    self.signUpUserView.scrollView.delegate = self;
}


- (void)viewTapped {
    
    [self.view endEditing:YES];
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

- (void)setupFirstNameField {
    
    [self firstNameTextField].delegate = self;
    [self firstNameTextField].standardPlaceholder = @"first name";
    [self firstNameTextField].validationPlaceholder = @"please enter your first name";
    [[self firstNameTextField] sizeToFit];
    
    [self firstNameTextField].text = [self guardian].firstName;
}

- (void)setupLastNameField {
    
    [self lastNameTextField].delegate = self;
    [self lastNameTextField].standardPlaceholder = @"last name";
    [self lastNameTextField].validationPlaceholder = @"please enter your last name";
    [[self lastNameTextField] sizeToFit];
    
    [self lastNameTextField].text = [self guardian].lastName;
}

- (void)setupPhoneNumberField {
    
    [self phoneNumberTextField].delegate = self;
    [self phoneNumberTextField].standardPlaceholder = @"phone number";
    [self phoneNumberTextField].validationPlaceholder = @"invalid phone number";
    [self phoneNumberTextField].keyboardType = UIKeyboardTypePhonePad;
    [[self phoneNumberTextField] sizeToFit];
    
    [self phoneNumberTextField].text = [self guardian].phoneNumber;
}

- (void)setupInsurerPromptView {
    
    [self insurerTextField].delegate = self;
    [self insurerTextField].standardPlaceholder = @"insurer";
    [self insurerTextField].validationPlaceholder = @"choose an insurer";
    [self insurerTextField].enabled = NO;
    [[self insurerTextField] sizeToFit];
    
    if ([self guardian].insurancePlan) {
        [self insurerTextField].text = [NSString stringWithFormat:@"%@ %@",[self guardian].insurancePlan.insurerName, [self guardian].insurancePlan.name];
    }
    
    self.signUpUserView.insurerPromptView.accessoryImageViewVisible = YES;
    self.signUpUserView.insurerPromptView.delegate = self;
}

- (void)setupButton {
    
    [LEOStyleHelper styleButton:[self continueButton] forFeature:FeatureOnboarding];
    
    [[self continueButton] addTarget:self action:@selector(continueTapped:) forControlEvents:UIControlEventTouchUpInside];
}

- (Family *)family {
    
    if (!_family) {
        _family = [[Family alloc] init];
    }
    
    return _family;
}

-(LEOSignUpUserView *)signUpUserView {
    
    if (!_signUpUserView) {
        _signUpUserView = [[LEOSignUpUserView alloc] init];
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
    

    if ([self validatePage]) {
        [self addOnboardingData];
        
        switch (self.managementMode) {
            case ManagementModeCreate:
                [self performSegueWithIdentifier:kSegueContinue sender:sender];
                break;
                
            case ManagementModeEdit:
                [self pop];
                break;
        }
    }
}

- (void)addOnboardingData {
    
    NSString *firstName = [self firstNameTextField].text;
    NSString *lastName = [self lastNameTextField].text;
    NSString *phoneNumber = [self phoneNumberTextField].text;
    
    self.guardian = [[Guardian alloc] initWithObjectID:nil familyID:nil title:nil firstName:firstName middleInitial:nil lastName:lastName suffix:nil email:self.guardian.email avatarURL:nil avatar:nil phoneNumber:phoneNumber insurancePlan:self.guardian.insurancePlan primary:YES membershipType:MembershipTypeIncomplete];

    //InsurancePlan onboarding data provided as part of the delegate method upon return from the BasicSelectionViewController. Not in love with this implementation but it will suffice for the time-being.
    
    if (self.managementMode == ManagementModeCreate) {
        [self.family addGuardian:self.guardian];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    __block BOOL shouldSelect = NO;
    
    if ([segue.identifier isEqualToString:kSeguePlan]) {
        
        LEOBasicSelectionViewController *selectionVC = segue.destinationViewController;
        
        selectionVC.key = @"name";
        selectionVC.reuseIdentifier = @"InsurancePlanCell";
        selectionVC.titleText = @"Who is your insurer?";
        selectionVC.feature = FeatureOnboarding;
        
        selectionVC.configureCellBlock = ^(InsurancePlanCell *cell, InsurancePlan *plan) {
            
            cell.selectedColor = [UIColor leoOrangeRed];
            
            shouldSelect = NO;
            
            [cell configureForPlan:plan];
            
            if ([plan.objectID isEqualToString:[self insurerTextField].text]) {
                shouldSelect = YES;
            }
            
            return shouldSelect;
        };
        
        selectionVC.requestOperation = [[LEOAPIInsuranceOperation alloc] init];
        selectionVC.delegate = self;
    }
    
    if ([segue.identifier isEqualToString:kSegueContinue]) {
        
        LEOManagePatientsViewController *manageChildrenVC = segue.destinationViewController;
        
        manageChildrenVC.family = self.family;
        manageChildrenVC.enrollmentToken = self.enrollmentToken;
    }
    
    [self.view endEditing:YES];
}

- (void)pop {
    
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - Validation

- (BOOL)validatePage {
    
    BOOL validFirstName = [LEOValidationsHelper isValidFirstName:[self firstNameTextField].text];
    BOOL validLastName = [LEOValidationsHelper isValidLastName:[self lastNameTextField].text];
    BOOL validPhoneNumber = [LEOValidationsHelper isValidPhoneNumberWithFormatting:[self phoneNumberTextField].text];
    BOOL validInsurer = [LEOValidationsHelper isValidInsurer:[self insurerTextField].text];
    
    [self firstNameTextField].valid = validFirstName;
    [self lastNameTextField].valid = validLastName;
    [self phoneNumberTextField].valid = validPhoneNumber;
    [self insurerTextField].valid = validInsurer;
    
    return validFirstName && validLastName && validPhoneNumber && validInsurer;
}


#pragma mark - <UITextFieldDelegate>
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSMutableAttributedString *mutableText = [[NSMutableAttributedString alloc] initWithString:textField.text];
    
    [mutableText replaceCharactersInRange:range withString:string];
    
    if (textField == [self firstNameTextField] && ![self firstNameTextField].valid) {
        
        self.firstNameTextField.valid = [LEOValidationsHelper isValidFirstName:mutableText.string];
    }
    
    if (textField == self.lastNameTextField && ![self lastNameTextField].valid) {
        
        self.lastNameTextField.valid = [LEOValidationsHelper isValidLastName:mutableText.string];
    }
    
    if (textField == [self phoneNumberTextField]) {
        
        if (![self phoneNumberTextField].valid) {
            [self phoneNumberTextField].valid = [LEOValidationsHelper isValidPhoneNumberWithFormatting:mutableText.string];
        }
        
        return [LEOValidationsHelper phoneNumberTextField:textField shouldUpdateCharacters:string inRange:range];
    }
    
    return YES;
}


#pragma mark - <SingleSelectionProtocol>

-(void)didUpdateItem:(id)item forKey:(NSString *)key {
    
    NSString *insurancePlanString = [NSString stringWithFormat:@"%@ %@",((InsurancePlan *)item).insurerName,((InsurancePlan *)item).name];
    [self insurerTextField].text = insurancePlanString;
    
    self.guardian = [[Guardian alloc] initWithObjectID:self.guardian.objectID familyID:self.guardian.familyID title:self.guardian.title firstName:self.guardian.firstName middleInitial:self.guardian.middleInitial lastName:self.guardian.lastName suffix:self.guardian.suffix email:self.guardian.email avatarURL:nil avatar:nil phoneNumber:self.guardian.phoneNumber insurancePlan:self.guardian.insurancePlan primary:self.guardian.primary membershipType:self.guardian.membershipType];
}


#pragma mark - Shorthand Helpers

- (LEOValidatedFloatLabeledTextField *)firstNameTextField {
    return self.signUpUserView.firstNamePromptView.textField;
}

- (LEOValidatedFloatLabeledTextField *)lastNameTextField {
    return self.signUpUserView.lastNamePromptView.textField;
}

- (LEOValidatedFloatLabeledTextField *)phoneNumberTextField {
    return self.signUpUserView.phoneNumberPromptView.textField;
}

- (LEOValidatedFloatLabeledTextField *)insurerTextField {
    return self.signUpUserView.insurerPromptView.textField;
}

- (UIButton *)continueButton {
    return self.signUpUserView.continueButton;
}


#pragma mark - Debugging
- (void)testData {
    [self firstNameTextField].text = @"Sally";
    [self lastNameTextField].text = @"Carmichael";
    [self insurerTextField].text = @"Aetna PPO";
    [self phoneNumberTextField].text = @"(555) 555-5555";
    
    InsurancePlan *insurancePlan = [[InsurancePlan alloc] initWithObjectID:nil insurerID:@"1" insurerName:@"Aetna" name:@"PPO"];

    Guardian *guardian1 = [[Guardian alloc] initWithObjectID:nil title:@"Mrs" firstName:@"Sally" middleInitial:nil lastName:@"Carmichael" suffix:nil email:@"sally.carmichael@gmail.com" avatarURL:nil avatar:nil];
    
    self.family.guardians = @[guardian1];
}


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
