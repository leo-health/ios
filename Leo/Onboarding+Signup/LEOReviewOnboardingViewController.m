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
#import "ReviewPatientCell+ConfigureForCell.h"
#import "ReviewUserCell+ConfigureForCell.h"
#import "LEOButtonCell.h"

#import "SessionUser.h"
#import "Family.h"
#import "Patient.h"
#import "Guardian.h"
#import "InsurancePlan.h"

#import "UIViewController+Extensions.h"

#import "LEOSignUpPatientViewController.h"
#import "LEOSignUpUserViewController.h"

#import "UIColor+LeoColors.h"
#import "UIFont+LeoFonts.h"
#import "UIView+Extensions.h"

#import "UIImage+Extensions.h"

typedef enum TableViewSection {
    
    TableViewSectionTitle = 0,
    TableViewSectionGuardians = 1,
    TableViewSectionPatients = 2,
    TableViewSectionButton = 3
    
} TableViewSection;
@interface LEOReviewOnboardingViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UINavigationBar *navigationBar;

@end

@implementation LEOReviewOnboardingViewController

NSString *const kHeaderCellReuseIdentifier = @"LEOBasicHeaderCell";
NSString *const kReviewUserCellReuseIdentifer = @"ReviewUserCell";
NSString *const kReviewPatientCellReuseIdentifer = @"ReviewPatientCell";
NSString *const kButtonCellReuseIdentifier = @"ButtonCell";
NSString *const kReviewUserSegue = @"ReviewUserSegue";
NSString *const kReviewPatientSegue = @"ReviewPatientSegue";

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self setupNavigationBar];
    
}

- (void)viewWillAppear:(BOOL)animated {
    
    [self setupTableView];

    [self.tableView reloadData];
}

- (void)setupNavigationBar {

    self.navigationController.navigationBarHidden = YES;
    
    [self.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor leoWhite]]
                                forBarPosition:UIBarPositionAny
                                    barMetrics:UIBarMetricsDefault];
    
    [self.navigationBar setShadowImage:[UIImage new]];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton addTarget:self action:@selector(pop) forControlEvents:UIControlEventTouchUpInside];
    [backButton setImage:[UIImage imageNamed:@"Icon-BackArrow"] forState:UIControlStateNormal];
    [backButton sizeToFit];
    [backButton setTintColor:[UIColor leoOrangeRed]];
    
    UIBarButtonItem *backBBI = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    
    UILabel *navTitleLabel = [[UILabel alloc] init];
    navTitleLabel.text = @"Check yo' self";
    [navTitleLabel sizeToFit];
    
    UINavigationItem *item = [[UINavigationItem alloc] init];
    item.titleView = navTitleLabel;
    [self.navigationBar pushNavigationItem:item animated:NO];
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
    [self.tableView registerNib:[ReviewPatientCell nib]
         forCellReuseIdentifier:kReviewPatientCellReuseIdentifer];
    [self.tableView registerNib:[ReviewUserCell nib]
         forCellReuseIdentifier:kReviewUserCellReuseIdentifer];
    [self.tableView registerNib:[LEOButtonCell nib] forCellReuseIdentifier:kButtonCellReuseIdentifier];
}


#pragma mark - <UITableViewDataSource>

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    switch (section) {
        case TableViewSectionTitle:
            return 1;
        
        case TableViewSectionGuardians:
            return 1;
            
        case TableViewSectionPatients:
            return [self.family.patients count];
            
        case TableViewSectionButton:
            return 1;
            
        default:
            return 0;
    }
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
            
            ReviewUserCell *reviewUserCell = [tableView dequeueReusableCellWithIdentifier:kReviewUserCellReuseIdentifer];
            
            Guardian *guardian = self.family.guardians[indexPath.row];
            
            [reviewUserCell configureForGuardian:guardian];
            
            return reviewUserCell;
        }
            
        case TableViewSectionPatients: {
            
            ReviewPatientCell *reviewPatientCell = [tableView dequeueReusableCellWithIdentifier:kReviewPatientCellReuseIdentifer];
            
            Patient *patient = self.family.patients[indexPath.row];
            
            [reviewPatientCell configureForPatient:patient patientNumber:indexPath.row];
            
            return reviewPatientCell;
        }
        
        case TableViewSectionButton: {
            
            LEOButtonCell *buttonCell = [tableView dequeueReusableCellWithIdentifier:kButtonCellReuseIdentifier];
            
            [buttonCell.button addTarget:self action:@selector(continueTapped:) forControlEvents:UIControlEventTouchUpInside];

            return buttonCell;
        }
            
        default:
            return nil;
    }
}

#pragma mark - <UITableViewDelegate>

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.section) {
        case TableViewSectionGuardians: {
            
            Guardian *guardian = self.family.guardians[indexPath.row];
            [self performSegueWithIdentifier:kReviewUserSegue sender:guardian];
            
        }
            break;
        
        case TableViewSectionPatients: {
            
            Patient *patient = self.family.patients[indexPath.row];
            [self performSegueWithIdentifier:kReviewPatientSegue sender:patient];
        }
            break;
            
        case TableViewSectionTitle:
        case TableViewSectionButton:
        default:
            break;
    }
}

//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
//    
//    if (section == TableViewSectionPatients) {
//        
//        UIView *footerView = [[UIView alloc] init];
//        
//        UIButton *continueButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        
//        [continueButton setTitleColor:[UIColor leoWhite] forState:UIControlStateNormal];
//        [continueButton setTitle:@"SUBSCRIBE TO LEO" forState:UIControlStateNormal];
//        
//        continueButton.titleLabel.font = [UIFont leoButtonLabelsAndTimeStampsFont];
//        continueButton.backgroundColor = [UIColor leoOrangeRed];
//        
//        [continueButton addTarget:self action:@selector(continueTapped:) forControlEvents:UIControlEventTouchUpInside];
//        
//        NSDictionary *bindings = NSDictionaryOfVariableBindings(continueButton);
//        
//        
//        continueButton.translatesAutoresizingMaskIntoConstraints = NO;
//        
//        [footerView addSubview:continueButton];
//        
//        [footerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(40)-[continueButton(==54)]|" options:0 metrics:nil views:bindings]];
//        [footerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(30)-[continueButton]-(30)-|" options:0 metrics:nil views:bindings]];
//        
//        return footerView;
//    }
//    
//    return nil;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
//    
//    if (section == TableViewSectionPatients) {
//        return 94.0;
//    }
//    
//    return 0.0;
//}

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
        signUpPatientVC.managementMode = ManagementModeEdit;
    }
}

- (void)continueTapped:(UIButton *)sender {
    
    LEOUserService *userService = [[LEOUserService alloc] init];
    
    [userService createUserWithFamily:self.family withCompletion:^(BOOL success, NSError *error) {
        
        if (!error) {
                        
            if ([self isModal]) {
                [self dismissViewControllerAnimated:self completion:nil];
            } else {
                UIStoryboard *feedStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                UIViewController *initialVC = [feedStoryboard instantiateInitialViewController];
                [self presentViewController:initialVC animated:NO completion:nil];
            }
        }
    }];
    
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
//    if (scrollView == self.tableView) {
    
//        CGFloat navBarHeight = self.navigationController.navigationBar.frame.size.height;
//        LEOBasicHeaderCell *headerCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
//        CGFloat heightOfHeaderCell = headerCell.frame.size.height;
//        CGFloat heightOfHeaderCellExcludingOverlapWithNavBar = heightOfHeaderCell - navBarHeight;
//        CGFloat percentHeaderCellHidden = (self.tableView.contentOffset.y - navBarHeight) / heightOfHeaderCellExcludingOverlapWithNavBar;
//        
//        if (percentHeaderCellHidden < 1) {
//            headerCell.headerLabel.alpha = 1 - percentHeaderCellHidden * 3; //FIXME: Magic number
//        }
//        
//        if (scrollView.contentOffset.y >= navBarHeight) {
//            if (self.collapsedGradientImageView.hidden == YES) {
//                [self drawBorders:YES];
//            }
//            self.collapsedGradientImageView.hidden = NO;
//            
//        } else {
//            
//            
//            if (self.collapsedGradientImageView.hidden == NO) {
//                [self drawBorders:NO];
//            }
//            
//            self.collapsedGradientImageView.hidden = YES;
        }
//    }
//}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    
    
    if (scrollView == self.tableView) {
        
    if (!decelerate) {
        NSLog(@"DidEndDragging!");
        [self snapTable];
    }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    if (scrollView == self.tableView) {
        NSLog(@"DidEndDecelerating!");
        [self snapTable];
    }
}

- (void)snapTable {
    
    CGFloat navBarHeight = self.navigationController.navigationBar.frame.size.height;
    CGFloat heightOfHeaderCell = [self.tableView rectForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]].size.height;
    CGFloat heightOfHeaderCellExcludingOverlapWithNavBar = heightOfHeaderCell - navBarHeight;
    CGFloat centerOfHeaderCellExcludingOverlapWithNavBar = heightOfHeaderCellExcludingOverlapWithNavBar / 2 + navBarHeight;
    
    NSIndexPath *pathForCenterCell = [self.tableView indexPathForRowAtPoint:CGPointMake(CGRectGetMidX(self.tableView.bounds), centerOfHeaderCellExcludingOverlapWithNavBar)];
    
    if (pathForCenterCell.row > 0 && self.tableView.contentOffset.y < heightOfHeaderCell) {
        
        self.tableView.contentOffset = CGPointMake(0.0, heightOfHeaderCellExcludingOverlapWithNavBar);
        
        [UIView animateWithDuration:0.2 animations:^{
            [self.tableView layoutIfNeeded];
        }];
        
        
    } else if (pathForCenterCell.row == 0) {
        
        self.tableView.contentOffset = CGPointMake(0.0, 0.0);
        
        [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            [self.tableView layoutIfNeeded];
        } completion:nil];
    }
}

- (CGSize)preferredContentSize
{
    // Force the table view to calculate its height
    [self.tableView layoutIfNeeded];
    
    CGFloat totalHeightOfTableViewContentArea = self.tableView.contentSize.height + self.tableView.contentInset.bottom;
    CGFloat navBarHeight = self.navigationController.navigationBar.frame.size.height;
    CGFloat heightOfHeaderCellExcludingOverlapWithNavBar = [self.tableView rectForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]].size.height - navBarHeight;

    CGFloat heightOfTableViewFrame = self.tableView.frame.size.height;
    CGFloat heightWeWouldLikeTheTableViewContentAreaToBe = heightOfTableViewFrame + heightOfHeaderCellExcludingOverlapWithNavBar;
    
    if (totalHeightOfTableViewContentArea > heightOfTableViewFrame && totalHeightOfTableViewContentArea < heightWeWouldLikeTheTableViewContentAreaToBe) {
        
        CGFloat bottomInsetWeNeedToGetToHeightWeWouldLikeTheTableViewContentAreaToBe = heightWeWouldLikeTheTableViewContentAreaToBe - totalHeightOfTableViewContentArea;
        self.tableView.contentInset = UIEdgeInsetsMake(0, 0, bottomInsetWeNeedToGetToHeightWeWouldLikeTheTableViewContentAreaToBe, 0);
    }
    
    [self.tableView layoutIfNeeded];
    
    return self.tableView.contentSize;
}


@end
