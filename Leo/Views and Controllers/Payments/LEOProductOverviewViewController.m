//
//  LEOProductOverviewViewController.m
//  Leo
//
//  Created by Zachary Drossman on 5/16/16.
//  Copyright © 2016 Leo Health. All rights reserved.
//

#import "LEOProductOverviewViewController.h"
#import "Family.h"
#import "LEOAnalyticSession.h"
#import "LEOProgressDotsHeaderView.h"
#import "UIColor+LeoColors.h"
#import "UIFont+LeoFonts.h"
#import "LEOPaymentViewController.h"
#import "LEOProductOverviewView.h"
#import "Guardian.h"

#import "LEOStyleHelper.h"

@interface LEOProductOverviewViewController ()

@property (weak, nonatomic) LEOProductOverviewView *productOverviewView;
@property (weak, nonatomic) LEOProgressDotsHeaderView *headerView;

@property (nonatomic) BOOL alreadyUpdatedConstraints;

@end

@implementation LEOProductOverviewViewController

NSString * const kHeaderTitleText = @"Unlimited access, simple pricing.";

- (void)viewDidLoad {

    [super viewDidLoad];

    [LEOStyleHelper styleNavigationBarForViewController:self
                                             forFeature:self.feature
                                          withTitleText:@""
                                              dismissal:NO
                                             backButton:YES];
}

- (LEOProductOverviewView *)overviewViewWithMembershipType:(MembershipType)membershipType {

    NSDictionary *firstDetailAttributes;
    NSDictionary *secondDetailAttributes;
    NSString *firstDetailString;
    NSString *secondDetailString;
    NSNumber *price;

    switch (membershipType) {

        case MembershipTypeExempted: {

            firstDetailAttributes = @{ NSForegroundColorAttributeName : [UIColor leo_orangeRed],
                                       NSFontAttributeName : [UIFont leo_ultraLight14],
                                       };


            secondDetailAttributes = @{ NSForegroundColorAttributeName : [UIColor leo_orangeRed],
                                        NSFontAttributeName : [UIFont leo_ultraLight14]
                                        };

            firstDetailString = @"per child";
            secondDetailString = @"billed monthly";

            price = @20;
        }
            break;

        default: {

            firstDetailAttributes = @{ NSForegroundColorAttributeName : [UIColor leo_orangeRed],
                                       NSFontAttributeName : [UIFont leo_ultraLight14],
                                       };


            secondDetailAttributes = @{ NSForegroundColorAttributeName : [UIColor leo_orangeRed],
                                        NSFontAttributeName : [UIFont leo_ultraLightItalic14]
                                        };

            firstDetailString = @"subscription fee waived";
            secondDetailString = @"valued at $240/yr";

            price = @0;
            
        }
            break;
    }

    NSAttributedString *firstDetailAttributedString = [[NSAttributedString alloc] initWithString:firstDetailString attributes:firstDetailAttributes];
    NSAttributedString *secondDetailAttributedString = [[NSAttributedString alloc] initWithString:secondDetailString attributes:secondDetailAttributes];

    __weak typeof(self) weakSelf = self;

    return [[LEOProductOverviewView alloc] initWithFeature:self.feature price:price firstPriceDetailAttributedString:firstDetailAttributedString secondPriceDetailAttributedString:secondDetailAttributedString continueTappedUpInsideBlock:^{

        __strong typeof(self) strongSelf = weakSelf;

        [strongSelf performSegueWithIdentifier:kSegueContinue sender:nil];
    }];

}

- (LEOProductOverviewView *)productOverviewView {

    if (!_productOverviewView) {

        Guardian *guardian = (Guardian *)self.family.guardians.firstObject;

        LEOProductOverviewView *strongView = [self overviewViewWithMembershipType:guardian.membershipType];

        _productOverviewView = strongView;

        [self.view addSubview:_productOverviewView];
    }

    return _productOverviewView;
}

- (UIView *)headerView {

    if (!_headerView) {

        LEOProgressDotsHeaderView *strongView = [[LEOProgressDotsHeaderView alloc] initWithTitleText:kHeaderTitleText numberOfCircles:kNumberOfProgressDots currentIndex:4 fillColor:[UIColor leo_orangeRed]];

        _headerView = strongView;

        [LEOStyleHelper styleExpandedTitleLabel:_headerView.titleLabel
                                        feature:self.feature];

        [self.view addSubview:_headerView];
    }

    return _headerView;
}

- (void)updateViewConstraints {

    if (!self.alreadyUpdatedConstraints) {

        self.headerView.translatesAutoresizingMaskIntoConstraints = NO;
        self.productOverviewView.translatesAutoresizingMaskIntoConstraints = NO;

        NSDictionary *bindings = NSDictionaryOfVariableBindings(_headerView, _productOverviewView);

        NSArray *horizontalConstraintsForHeaderView = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_headerView]|" options:0 metrics:nil views:bindings];

        NSArray *horizontalConstraintsForProductOverviewView = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(15)-[_productOverviewView]-(15)-|" options:0 metrics:nil views:bindings];

        NSDictionary *metrics = @{ @"headerHeight" : @(kHeightOnboardingHeaders)};

        NSArray *verticalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_headerView(headerHeight)]-(30)-[_productOverviewView]|" options:0 metrics:metrics views:bindings];

        [self.view addConstraints:horizontalConstraintsForHeaderView];
        [self.view addConstraints:horizontalConstraintsForProductOverviewView];
        [self.view addConstraints:verticalConstraints];

        self.alreadyUpdatedConstraints = YES;
    }

    [super updateViewConstraints];
}

- (void)pop {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    if ([segue.identifier isEqualToString:kSegueContinue]) {
        
        LEOPaymentViewController *paymentVC = segue.destinationViewController;
        paymentVC.family = self.family;
        paymentVC.analyticSession = self.analyticSession;
        paymentVC.feature = FeatureOnboarding;
        paymentVC.managementMode = ManagementModeCreate;
    }
}

@end
