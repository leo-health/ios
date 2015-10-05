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

#import "Family.h"
#import "Patient.h"
#import "Guardian.h"

#import "UIViewController+Extensions.h"

#import "LEOSignUpPatientViewController.h"
#import "LEOSignUpUserViewController.h"

#import "UIColor+LeoColors.h"
#import "UIFont+LeoFonts.h"
#import "UIView+Extensions.h"

typedef enum TableViewSection {
    
    TableViewSectionTitle = 0,
    TableViewSectionGuardians = 1,
    TableViewSectionPatients = 2,
    
} TableViewSection;
@interface LEOReviewOnboardingViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation LEOReviewOnboardingViewController

NSString *const kHeaderCellReuseIdentifier = @"LEOBasicHeaderCell";
NSString *const kReviewUserCellReuseIdentifer = @"ReviewUserCell";
NSString *const kReviewPatientCellReuseIdentifer = @"ReviewPatientCell";
NSString *const kReviewUserSegue = @"ReviewUserSegue";
NSString *const kReviewPatientSegue = @"ReviewPatientSegue";

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    
    [self setupTableView];

    [self.tableView reloadData];
}

- (void)setupTableView {
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.tableView.estimatedRowHeight = 100.0;
    self.tableView.rowHeight = UITableViewAutomaticDimension;

    [self.tableView registerNib:[LEOBasicHeaderCell nib]
         forCellReuseIdentifier:kHeaderCellReuseIdentifier];
    [self.tableView registerNib:[ReviewPatientCell nib]
         forCellReuseIdentifier:kReviewPatientCellReuseIdentifer];
    [self.tableView registerNib:[ReviewUserCell nib]
         forCellReuseIdentifier:kReviewUserCellReuseIdentifer];
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
            
        default:
            return 0;
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
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
            
        default:
            return nil;
    }
}

#pragma mark - <UITableViewDelegate>

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
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
        default:
            break;
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
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

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    if (section == TableViewSectionPatients) {
        
        UIView *footerView = [[UIView alloc] init];
        
        
        UIButton *continueButton = [UIButton buttonWithType:UIButtonTypeCustom];

        [continueButton setTitleColor:[UIColor leoWhite] forState:UIControlStateNormal];
        [continueButton setTitle:@"SUBSCRIBE TO LEO" forState:UIControlStateNormal];
        
        continueButton.titleLabel.font = [UIFont leoButtonLabelsAndTimeStampsFont];
        continueButton.backgroundColor = [UIColor leoOrangeRed];
        
        [continueButton addTarget:self action:@selector(continueTapped:) forControlEvents:UIControlEventTouchUpInside];
        
        NSDictionary *bindings = NSDictionaryOfVariableBindings(continueButton);
        
        
        continueButton.translatesAutoresizingMaskIntoConstraints = NO;
        
        [footerView addSubview:continueButton];
        
        [footerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(40)-[continueButton(==54)]|" options:0 metrics:nil views:bindings]];
        [footerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(30)-[continueButton]-(30)-|" options:0 metrics:nil views:bindings]];
        
        return footerView;
    }
    
    return nil;
}


    
    
- (void)continueTapped:(UIButton *)sender {
    
    if ([self isModal]) {
        [self dismissViewControllerAnimated:self completion:nil];
    } else {
        UIStoryboard *feedStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UIViewController *initialVC = [feedStoryboard instantiateInitialViewController];
        [self presentViewController:initialVC animated:NO completion:nil];
    }

}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    if (section == TableViewSectionPatients) {
        return 94.0;
    }
    
    return 0.0;
}



@end
