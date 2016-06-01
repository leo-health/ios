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


@interface LEOSubscriptionManagementViewController ()

@property (weak, nonatomic) UILabel *contactUsTitleLabel;
@property (weak, nonatomic) UITextView *contactUsDetailTextView;

@property (nonatomic) BOOL alreadyUpdatedConstraints;

@end

@implementation LEOSubscriptionManagementViewController

NSString *const kContactUsDetailForPaidMembers = @"Please contact us to make changes to your account or unsubscribe\n\nPlease email\nsupport@leohealth.com\n\nLive support available at leohealth.com\npowered by intercom";

NSString *const kContactUsDetailForExemptedMembers = @"As a pre-existing customer of Flatiron Pediatrics, your subscription fee has been waived. However, if you have any questions or concerns about your account or to unsubscribe, please email us at:\n\nsupport@leohealth.com\n\nLive support available at leohealth.com\npowered by intercom";

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
        _contactUsTitleLabel.text = @"Contact Us";

        [self.view addSubview:_contactUsTitleLabel];
    }

    return _contactUsTitleLabel;
}

- (void)updateViewConstraints {

    if (!self.alreadyUpdatedConstraints) {

        self.contactUsTitleLabel.translatesAutoresizingMaskIntoConstraints = NO;
        self.contactUsDetailTextView.translatesAutoresizingMaskIntoConstraints = NO;

        NSDictionary *bindings = NSDictionaryOfVariableBindings(_contactUsTitleLabel, _contactUsDetailTextView);

        NSArray *horizontalLayoutConstraintsForDetailLabel =
        [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(28)-[_contactUsDetailTextView]-(53)-|"
                                                options:0
                                                metrics:nil
                                                  views:bindings];

        NSArray *horizontalLayoutConstraintsForTitleLabel =
        [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(28)-[_contactUsTitleLabel]-(53)-|"
                                                options:0
                                                metrics:nil
                                                  views:bindings];


        NSArray *verticalLayoutConstraints =
        [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(58)-[_contactUsTitleLabel]-(17)-[_contactUsDetailTextView(==300)]"
                                                options:0
                                                metrics:nil
                                                  views:bindings];

        [self.view addConstraints:horizontalLayoutConstraintsForTitleLabel];
        [self.view addConstraints:horizontalLayoutConstraintsForDetailLabel];
        [self.view addConstraints:verticalLayoutConstraints];

        self.alreadyUpdatedConstraints = YES;
    }

    [super updateViewConstraints];
}

- (void)setupNavigationBar {

    [LEOStyleHelper styleNavigationBar:self.navigationController.navigationBar forFeature:FeatureSettings];
    [LEOStyleHelper styleBackButtonForViewController:self forFeature:FeatureSettings];

    UILabel *navigationLabel = [UILabel new];
    navigationLabel.text = @"Manage Subscription";

    [LEOStyleHelper styleLabel:navigationLabel forFeature:FeatureSettings];

    self.navigationItem.titleView = navigationLabel;
}


@end
