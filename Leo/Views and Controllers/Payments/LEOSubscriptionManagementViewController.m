//
//  LEOSubscriptionManagementViewController.m
//  Leo
//
//  Created by Zachary Drossman on 5/6/16.
//  Copyright © 2016 Leo Health. All rights reserved.
//

#import "LEOSubscriptionManagementViewController.h"
#import "UIFont+LeoFonts.h"
#import "UIColor+LeoColors.h"
#import "LEOStyleHelper.h"
#import "LEOPromptView.h"
#import "LEOPaymentViewController.h"

@interface LEOSubscriptionManagementViewController () <LEOPromptDelegate>

@property (weak, nonatomic) UILabel *editPaymentsTitleLabel;
@property (weak, nonatomic) LEOPromptView *editPaymentsPromptView;
@property (weak, nonatomic) UILabel *contactUsTitleLabel;
@property (weak, nonatomic) UITextView *contactUsDetailTextView;

@property (nonatomic) BOOL alreadyUpdatedConstraints;

@end

@implementation LEOSubscriptionManagementViewController


NSString *const kCopyContactUsTitle = @"Contact Us";
NSString *const kCopyManagePaymentTitle = @"Manage Payment";

NSString *const kContactUsDetailForPaidMembers = @"Please contact us to make changes to your account or cancel your membership\n\nPlease email\nsupport@leohealth.com\n\nLive support available at leohealth.com\npowered by intercom";

NSString *const kContactUsDetailForExemptedMembers = @"As a pre-existing customer of Flatiron Pediatrics, your membership fee has been waived. However, if you have any questions or concerns about your account or to cancel your membership, please email us at:\n\nsupport@leohealth.com\n\nLive support available at leohealth.com\npowered by intercom";

- (void)viewDidLoad {

    [super viewDidLoad];

    [self setupNavigationBar];
}

- (UITextView *)contactUsDetailTextView {

    if (!_contactUsDetailTextView) {

        UITextView *strongTextView = [UITextView new];

        _contactUsDetailTextView = strongTextView;

        _contactUsDetailTextView.font = [UIFont leo_standardFont];
        _contactUsDetailTextView.textColor = [UIColor leo_grayStandard];

        switch (self.membershipType) {
            case MembershipTypeExempted:
                _contactUsDetailTextView.text = kContactUsDetailForExemptedMembers;
                break;

            default:
                _contactUsDetailTextView.text = kContactUsDetailForPaidMembers;
                break;
        }

        _contactUsDetailTextView.dataDetectorTypes = UIDataDetectorTypeAll;
        _contactUsDetailTextView.editable = NO;

        _contactUsDetailTextView.linkTextAttributes =
        @{
          NSForegroundColorAttributeName : [UIColor leo_grayStandard],
          NSUnderlineStyleAttributeName : @(NSUnderlineStyleSingle),
          NSFontAttributeName : [UIFont leo_standardFont]
          };
        [self.view addSubview:_contactUsDetailTextView];
    }

    return _contactUsDetailTextView;
}

- (UILabel *)contactUsTitleLabel {

    if (!_contactUsTitleLabel) {

        UILabel *strongLabel = [UILabel new];

        _contactUsTitleLabel = strongLabel;

        _contactUsTitleLabel.font = [UIFont leo_expandedCardHeaderFont];
        _contactUsTitleLabel.textColor = [UIColor leo_grayStandard];
        _contactUsTitleLabel.text = kCopyContactUsTitle;

        [self.view addSubview:_contactUsTitleLabel];
    }

    return _contactUsTitleLabel;
}

- (UILabel *)editPaymentsTitleLabel {

    if (!_editPaymentsTitleLabel) {

        UILabel *strongLabel = [UILabel new];

        _editPaymentsTitleLabel = strongLabel;

        _editPaymentsTitleLabel.font = [UIFont leo_expandedCardHeaderFont];
        _editPaymentsTitleLabel.textColor = [UIColor leo_grayStandard];
        _editPaymentsTitleLabel.text = kCopyManagePaymentTitle;

        if (self.membershipType != MembershipTypeExempted) {
            [self.view addSubview:_editPaymentsTitleLabel];
        }
    }
    
    return _editPaymentsTitleLabel;
}


- (LEOPromptView *)editPaymentsPromptView {

    if (!_editPaymentsPromptView) {

        LEOPromptView *strongView = [LEOPromptView new];

        _editPaymentsPromptView = strongView;

        _editPaymentsPromptView.tapGestureEnabled = YES;
        _editPaymentsPromptView.accessoryImage = [UIImage imageNamed:@"Icon-ForwardArrow"];
        _editPaymentsPromptView.textView.text = @"Edit my card";
        _editPaymentsPromptView.textView.editable = NO;
        _editPaymentsPromptView.textView.selectable = NO;
        _editPaymentsPromptView.tintColor = [UIColor leo_orangeRed];
        _editPaymentsPromptView.accessoryImageViewVisible = YES;
        _editPaymentsPromptView.delegate = self;

        [self.view addSubview:_editPaymentsPromptView];
    }

    return _editPaymentsPromptView;
}

- (void)updateViewConstraints {

    if (!self.alreadyUpdatedConstraints) {

        self.contactUsTitleLabel.translatesAutoresizingMaskIntoConstraints = NO;
        self.contactUsDetailTextView.translatesAutoresizingMaskIntoConstraints = NO;

        NSDictionary *bindings;
        if (self.membershipType == MembershipTypeExempted) {

            bindings = NSDictionaryOfVariableBindings(_contactUsTitleLabel, _contactUsDetailTextView);
        } else {

            self.editPaymentsTitleLabel.translatesAutoresizingMaskIntoConstraints = NO;
            self.editPaymentsPromptView.translatesAutoresizingMaskIntoConstraints = NO;
            bindings = NSDictionaryOfVariableBindings(_editPaymentsTitleLabel, _editPaymentsPromptView, _contactUsTitleLabel, _contactUsDetailTextView);
        }


        NSArray *verticalLayoutConstraints;
        switch (self.membershipType) {
            case MembershipTypeExempted: {
                verticalLayoutConstraints =
                [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(37)-[_contactUsTitleLabel]-(17)-[_contactUsDetailTextView(==300)]"
                                                        options:0
                                                        metrics:nil
                                                          views:bindings];
            }
                break;
                
            default: {
                NSArray *horizontalLayoutConstraintsForEditPaymentsTitleLabel =
                [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(28)-[_editPaymentsTitleLabel]-(53)-|"
                                                        options:0
                                                        metrics:nil
                                                          views:bindings];

                NSArray *horizontalLayoutConstraintsForEditPaymentsPromptView =
                [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(28)-[_editPaymentsPromptView]-(28)-|"
                                                        options:0
                                                        metrics:nil
                                                          views:bindings];


                verticalLayoutConstraints =
                [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(37)-[_editPaymentsTitleLabel]-(17)-[_editPaymentsPromptView(==58)]-(58)-[_contactUsTitleLabel]-(17)-[_contactUsDetailTextView(==300)]"
                                                        options:0
                                                        metrics:nil
                                                          views:bindings];

                [self.view addConstraints:horizontalLayoutConstraintsForEditPaymentsTitleLabel];
                [self.view addConstraints:horizontalLayoutConstraintsForEditPaymentsPromptView];
            }
                break;
        }

        NSArray *horizontalLayoutConstraintsForContactUsTitleLabel =
        [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(28)-[_contactUsTitleLabel]-(53)-|"
                                                options:0
                                                metrics:nil
                                                  views:bindings];

        NSArray *horizontalLayoutConstraintsForContactUsDetailLabel =
        [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(28)-[_contactUsDetailTextView]-(53)-|"
                                                options:0
                                                metrics:nil
                                                  views:bindings];

        [self.view addConstraints:horizontalLayoutConstraintsForContactUsTitleLabel];
        [self.view addConstraints:horizontalLayoutConstraintsForContactUsDetailLabel];
        [self.view addConstraints:verticalLayoutConstraints];

        self.alreadyUpdatedConstraints = YES;
    }

    [super updateViewConstraints];
}

- (void)setupNavigationBar {

    [LEOStyleHelper styleNavigationBar:self.navigationController.navigationBar
                            forFeature:FeatureSettings];
    [LEOStyleHelper styleBackButtonForViewController:self
                                          forFeature:FeatureSettings];

    UILabel *navigationLabel = [UILabel new];
    navigationLabel.text = @"Manage Membership";
    
    [LEOStyleHelper styleLabel:navigationLabel forFeature:FeatureSettings];
    
    self.navigationItem.titleView = navigationLabel;
}

- (void)respondToPrompt:(id)sender {

    LEOPaymentViewController *paymentVC = [LEOPaymentViewController new];
    paymentVC.family = self.family;
    paymentVC.feature = FeatureSettings;
    paymentVC.managementMode = ManagementModeEdit;
    [self.navigationController pushViewController:paymentVC animated:YES];
}


@end
