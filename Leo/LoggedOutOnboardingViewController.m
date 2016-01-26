//
//  LoggedOutOnboardingViewController.m
//  Leo
//
//  Created by Adam Fanslau on 1/25/16.
//  Copyright © 2016 Leo Health. All rights reserved.
//

#import "LoggedOutOnboardingViewController.h"
#import "LEOLoggedOutSignUpCell.h"
#import "UIColor+LeoColors.h"
#import "LEOHorizontalModalTransitioningDelegate.h"

static NSString *const kLoginSegue = @"LoginSegue";
static NSString *const kSignUpSegue = @"SignUpSegue";

@interface LoggedOutOnboardingViewController () <UICollectionViewDelegateFlowLayout>

@property (strong, nonatomic) LEOHorizontalModalTransitioningDelegate *transitioningDelegate;

@end

@implementation LoggedOutOnboardingViewController

typedef NS_ENUM(NSUInteger, OnboardingCellFeature) {
    OnboardingCellFeatureLogin,
    OnboardingCellFeatureMessaging,
    OnboardingCellFeatureAppointments,
    OnboardingCellFeatureHealthRecord,
    OnboardingCellFeatureForms,
    OnboardingCellFeatureSignUp,
    count_OnboardingCellFeature
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
    return count_OnboardingCellFeature;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {


    LEOLoggedOutOnboardingCell *cell;
    NSString *imageName;

    switch (indexPath.row) {

        case OnboardingCellFeatureLogin: {

            LEOLoggedOutLoginCell *_cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifierLogin forIndexPath:indexPath];
            [_cell.loginButton addTarget:self action:@selector(loginTouchedUpInside:) forControlEvents:UIControlEventTouchUpInside];

            imageName = imageNameSignedOutLogin;

            cell = _cell;

            break;
        }

        case OnboardingCellFeatureMessaging: {

            cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifierFeature forIndexPath:indexPath];

            imageName = imageNameSignedOutMessages;
            break;
        }

        case OnboardingCellFeatureAppointments: {

            cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifierFeature forIndexPath:indexPath];

            imageName = imageNameSignedOutAppointments;
            break;
        }

        case OnboardingCellFeatureForms: {

            cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifierFeature forIndexPath:indexPath];

            imageName = imageNameSignedOutForms;
            break;
        }

        case OnboardingCellFeatureHealthRecord: {

            cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifierFeature forIndexPath:indexPath];

            imageName = imageNameSignedOutHealthRecord;
            break;
        }

        case OnboardingCellFeatureSignUp: {

            LEOLoggedOutSignUpCell *_cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifierSignup forIndexPath:indexPath];
            [_cell.loginButton addTarget:self action:@selector(loginTouchedUpInside:) forControlEvents:UIControlEventTouchUpInside];
            [_cell.signUpButton addTarget:self action:@selector(signupTouchedUpInside:) forControlEvents:UIControlEventTouchUpInside];

            imageName = imageNameSignedOutSignup;

            cell = _cell;
            
            break;
        }
            
        default:
            break;
    }

    cell.imageView.image = [UIImage imageNamed:imageName];

    return cell;
}

# pragma mark  -  Navigation

- (void)loginTouchedUpInside:(UIButton *)sender {

    [self performSegueWithIdentifier:kLoginSegue sender:self];
}

- (void)signupTouchedUpInside:(UIButton *)sender {

    [self performSegueWithIdentifier:kSignUpSegue sender:self];
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    UINavigationController *navController = segue.destinationViewController;

    self.transitioningDelegate = [[LEOHorizontalModalTransitioningDelegate alloc] init];

    navController.transitioningDelegate = self.transitioningDelegate;
    navController.modalPresentationStyle = UIModalPresentationFullScreen;
}


@end
