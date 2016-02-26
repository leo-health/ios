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

static NSString *const kSegueLogin = @"LoginSegue";
static NSString *const kSegueSignUp = @"SignUpSegue";

@interface LEOLoggedOutOnboardingViewController () <UICollectionViewDelegateFlowLayout>

@property (strong, nonatomic) LEOHorizontalModalTransitioningDelegate *transitioningDelegate;

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

    [self.collectionView registerNib:[LEOLoggedOutLoginCell nib] forCellWithReuseIdentifier:reuseIdentifierLogin];
    [self.collectionView registerNib:[LEOLoggedOutSignUpCell nib] forCellWithReuseIdentifier:reuseIdentifierSignup];
    [self.collectionView registerNib:[LEOLoggedOutOnboardingCell nib] forCellWithReuseIdentifier:reuseIdentifierFeature];

    self.collectionView.pagingEnabled = YES;
    self.collectionView.bounces = NO;
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 0;

    self.collectionView.backgroundColor = [UIColor leo_white];
}

#pragma mark <UICollectionViewDataSource>

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
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
            [_cell.loginButton addTarget:self action:@selector(loginTouchedUpInside:) forControlEvents:UIControlEventTouchUpInside];

            cell = _cell;

            break;
        }

        case OnboardingCellFeatureMessaging: {

            cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifierFeature forIndexPath:indexPath];

            cell.backgroundImageView.image = [UIImage imageNamed:@"Signed Out 1.1 - Background"];
            cell.mainTitleLabel.text = @"Message your care team directly";
            cell.detailLabel.text = @"We’re here to help when you need it";
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
            cell.detailLabel.text = @"Access to your child health data when you want it and need it";
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

# pragma mark  -  Navigation

- (void)loginTouchedUpInside:(UIButton *)sender {

    [self performSegueWithIdentifier:kSegueLogin sender:self];
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
