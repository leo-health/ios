//
//  LEOLoggedOutOnboardingViewController.m
//  Leo
//
//  Created by Adam Fanslau on 1/25/16.
//  Copyright © 2016 Leo Health. All rights reserved.
//

#import "LEOLoggedOutOnboardingViewController.h"
#import "LEOLoggedOutSignUpCell.h"
#import "UIColor+LeoColors.h"
#import "LEOHorizontalModalTransitioningDelegate.h"
#import "LEOSettingsService.h"
#import "Configuration.h"
#import "LEOAlertHelper.h"
#import "LEOAnalytic.h"

static NSString *const kSegueSignUp = @"SignUpSegue";

@interface LEOLoggedOutOnboardingViewController () <UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource, LEOLoginViewDelegate>

@property (weak, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) LEOHorizontalModalTransitioningDelegate *transitioningDelegate;
@property (nonatomic) BOOL alreadyUpdatedConstraints;

@end

@implementation LEOLoggedOutOnboardingViewController

typedef NS_ENUM(NSUInteger, OnboardingCellFeature) {
    OnboardingCellFeatureLogin,
    OnboardingCellFeatureAppointments,
    OnboardingCellFeatureHealthRecord,
    OnboardingCellFeatureMessaging,
    OnboardingCellFeatureForms,
    OnboardingCellFeatureSignUp,
    OnboardingCellFeatureCount
};

static NSString * const imageNameSignedOutLogin = @"Signed-Out-Login";
static NSString * const imageNameSignedOutMessages = @"Signed-Out-Messaging";
static NSString * const imageNameSignedOutAppointments = @"Signed-Out-Appointments";
static NSString * const imageNameSignedOutForms = @"Signed-Out-Forms";
static NSString * const imageNameSignedOutHealthRecord = @"Signed-Out-Health-Record";
static NSString * const imageNameSignedOutSignup = @"Signed-Out-Signup";

static NSString * const reuseIdentifierLogin = @"reuseIdentifierLogin";
static NSString * const reuseIdentifierSignup = @"reuseIdentifierSignup";
static NSString * const reuseIdentifierFeature = @"reuseIdentifierFeature";

- (void)viewDidLoad {
    [super viewDidLoad];

    [LEOAnalytic tagType:LEOAnalyticTypeScreen
                    name:kAnalyticScreenProductPreview];

    // NOTE: AF
    // reset configuration to ensure that we don't attempt to re-use a vendor ID
    // I don't think we actually need this (it only gets called once), but keeping it here to be safe
    [Configuration resetConfiguration];
}

- (UICollectionView *)collectionView {

    if (!_collectionView) {

        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        layout.minimumInteritemSpacing = 0;
        layout.minimumLineSpacing = 0;

        UICollectionView *collectionView = [[UICollectionView alloc]
                                            initWithFrame:CGRectZero
                                            collectionViewLayout:layout];
        _collectionView = collectionView;

        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.pagingEnabled = YES;
        _collectionView.bounces = YES;
        _collectionView.backgroundColor = [UIColor leo_white];

        [_collectionView registerNib:[LEOLoggedOutLoginCell nib]
          forCellWithReuseIdentifier:reuseIdentifierLogin];
        [_collectionView registerNib:[LEOLoggedOutSignUpCell nib]
          forCellWithReuseIdentifier:reuseIdentifierSignup];
        [_collectionView registerNib:[LEOLoggedOutOnboardingCell nib]
          forCellWithReuseIdentifier:reuseIdentifierFeature];

        [self.view addSubview:_collectionView];
    }

    return _collectionView;
}

- (void)updateViewConstraints {

    if (!self.alreadyUpdatedConstraints) {

        self.collectionView.translatesAutoresizingMaskIntoConstraints = NO;
        NSDictionary *views = NSDictionaryOfVariableBindings(_collectionView);
        [self.view addConstraints:
         [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_collectionView]|"
                                                 options:0
                                                 metrics:nil views:views]];
        [self.view addConstraints:
         [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_collectionView]|"
                                                 options:0
                                                 metrics:nil
                                                   views:views]];

        self.alreadyUpdatedConstraints = YES;
    }

    [super updateViewConstraints];
}

- (void)scrollToBottom {

    NSInteger section =
    [self numberOfSectionsInCollectionView:self.collectionView] - 1;

    NSInteger item = [self collectionView:self.collectionView
                   numberOfItemsInSection:section] - 1;

    NSIndexPath *lastIndexPath = [NSIndexPath indexPathForItem:item
                                                     inSection:section];

    [self.collectionView scrollToItemAtIndexPath:lastIndexPath
                                atScrollPosition:UICollectionViewScrollPositionBottom
                                        animated:YES];

}

#pragma mark UICollectionViewDataSource

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return collectionView.bounds.size;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return OnboardingCellFeatureCount;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {

    LEOLoggedOutOnboardingCell *cell;

    switch (indexPath.row) {

        case OnboardingCellFeatureLogin: {

            LEOLoggedOutLoginCell *_cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifierLogin forIndexPath:indexPath];
            _cell.contentViewController.loginView.delegate = self;
            cell = _cell;
            break;
        }

        case OnboardingCellFeatureMessaging: {

            cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifierFeature forIndexPath:indexPath];

            cell.backgroundImageView.image = [UIImage imageNamed:@"Signed Out 1.1 - Background"];
            cell.mainTitleLabel.text = @"Message your care team directly";
            cell.detailLabel.text = @"We’re here to help when you need it.";
            cell.contentImageView.image = [UIImage imageNamed:@"Chat Content"];
            break;
        }

        case OnboardingCellFeatureAppointments: {

            cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifierFeature forIndexPath:indexPath];

            cell.backgroundImageView.image = [UIImage imageNamed:@"Signed Out 1.2 - Background"];
            cell.mainTitleLabel.text = @"Book visits on your schedule";
            cell.detailLabel.text = @"Gone are the days of negotiating for an appointment. Find a time that works for you.";
            cell.contentImageView.image = [UIImage imageNamed:@"Schedule Content"];
            break;
        }

        case OnboardingCellFeatureForms: {

            cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifierFeature forIndexPath:indexPath];

            cell.backgroundImageView.image = [UIImage imageNamed:@"Signed Out 1.3 - Background"];
            cell.mainTitleLabel.text = @"Submit forms digitally";
            cell.detailLabel.text = @"Cut the wait time by using your phone's\ncamera to easily submit documents.";
            cell.contentImageView.image = [UIImage imageNamed:@"Form Content"];
            break;
        }

        case OnboardingCellFeatureHealthRecord: {

            cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifierFeature forIndexPath:indexPath];

            cell.backgroundImageView.image = [UIImage imageNamed:@"Signed Out 1.4 - Background"];
            cell.mainTitleLabel.text = @"Your child’s information at your fingertips";
            cell.detailLabel.text = @"Access your child's health data when you want it and need it.";
            cell.contentImageView.image = [UIImage imageNamed:@"Health Record Content"];
            break;
        }

        case OnboardingCellFeatureSignUp: {

            LEOLoggedOutSignUpCell *_cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifierSignup forIndexPath:indexPath];
            [_cell.loginButton addTarget:self action:@selector(loginTouchedUpInside:) forControlEvents:UIControlEventTouchUpInside];
            [_cell.signUpButton addTarget:self action:@selector(signupTouchedUpInside:) forControlEvents:UIControlEventTouchUpInside];

            return _cell;
            
            break;
        }
            
        default:
            break;
    }

    return cell;
}

#pragma mark UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {

    if ([cell isKindOfClass:[LEOLoggedOutLoginCell class]]) {
        
        [(LEOLoggedOutLoginCell *)cell addViewControllerToParentViewController:self];

        // MARK: neccessary only on IOS 8
        [cell.contentView setNeedsUpdateConstraints];
        [cell.contentView updateConstraintsIfNeeded];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
}

# pragma mark  -  Navigation

- (void)didTapArrowView:(id)sender {

    NSIndexPath *path = [NSIndexPath indexPathForRow:1 inSection:0];
    [self.collectionView scrollToItemAtIndexPath:path
                                atScrollPosition:UICollectionViewScrollPositionTop
                                        animated:YES];
}

- (void)loginTouchedUpInside:(UIButton *)sender {

    [LEOBreadcrumb crumbWithFunction:__PRETTY_FUNCTION__];

    [self.collectionView setContentOffset:CGPointZero animated:YES];
}

- (void)signupTouchedUpInside:(UIButton *)sender {

    [self performSegueWithIdentifier:kSegueSignUp sender:self];
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    UINavigationController *navController = segue.destinationViewController;

    self.transitioningDelegate = [[LEOHorizontalModalTransitioningDelegate alloc] init];

    navController.transitioningDelegate = self.transitioningDelegate;
    navController.modalPresentationStyle = UIModalPresentationFullScreen;
}


@end
