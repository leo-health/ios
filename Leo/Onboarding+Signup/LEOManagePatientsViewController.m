//
//  LEOManagePatientsViewController.m
//  Leo
//
//  Created by Zachary Drossman on 9/30/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import "LEOManagePatientsViewController.h"
#import "LEOManagePatientsView.h"
#import "LEOValidatedFloatLabeledTextField.h"
#import "UIFont+LeoFonts.h"
#import "UIColor+LeoColors.h"
#import "UIImage+Extensions.h"
#import "ArrayDataSource.h"
#import "LEOPromptViewCell+ConfigureForPatient.h"
#import "Patient.h"
#import "LEOSignUpPatientViewController.h"
#import "Family.h"
#import "UIViewController+Extensions.h"
#import "LEOReviewOnboardingViewController.h"

@interface LEOManagePatientsViewController ()

@end

@interface LEOManagePatientsViewController ()

@property (strong, nonatomic) LEOManagePatientsView *managePatientsView;
@property (weak, nonatomic) IBOutlet StickyView *stickyView;
@property (strong, nonatomic) ArrayDataSource *dataSource;

@end

@implementation LEOManagePatientsViewController

NSString *const kSignUpPatientSegue = @"SignUpPatientSegue";

#pragma mark - View Controller Lifecycle and Helpers

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self setupStickyView];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [self setupTableView];
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    [self testData];
    [[self tableView] reloadData];
    self.managePatientsView.cellCount = [self.family.patients count] + 1;

}

- (void)setupStickyView {
    
    self.stickyView.delegate = self;
    self.stickyView.tintColor = [UIColor leoOrangeRed];
    [self.stickyView reloadViews];
}

- (void)setupTableView {
    
    [self.tableView registerNib:[UINib nibWithNibName:@"LEOPromptViewCell" bundle:nil]  forCellReuseIdentifier:@"LEOPromptViewCell"];
    
    [self tableView].dataSource = self;
    [self tableView].delegate = self;
    
    [[self tableView] reloadData];
    self.managePatientsView.cellCount = [self.family.patients count] + 1;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    switch (section) {
        case 0:
            return [self.family.patients count];
            break;
            
        case 1:
            return 1;
            break;
            
        default:
            return 0;
            break;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    LEOPromptViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LEOPromptViewCell"
                                                              forIndexPath:indexPath];
    
    if (indexPath.section == 0) {
        Patient *patient = self.family.patients[indexPath.row];
        [cell configureForPatient:patient];
    }
    
    if (indexPath.section == 1) {
        [cell configureForNewPatient];
    }
    
    return cell;
}


#pragma mark - <StickyViewDelegate>

- (BOOL)scrollable {
    return YES;
}

- (BOOL)initialStateExpanded {
    return YES;
}

- (NSString *)expandedTitleViewContent {
    return @"Add or review your children's details";
}


- (NSString *)collapsedTitleViewContent {
    return @" ";
}

- (UIView *)stickyViewBody{
    return self.managePatientsView;
}

- (UIImage *)expandedGradientImage {
    
    return [UIImage imageWithColor:[UIColor leoWhite]];
}

- (UIImage *)collapsedGradientImage {
    return [UIImage imageWithColor:[UIColor leoWhite]];
}

-(UIViewController *)associatedViewController {
    return self;
}

-(LEOManagePatientsView *)managePatientsView {
    
    if (!_managePatientsView) {
        _managePatientsView = [[LEOManagePatientsView alloc] initWithCellCount:([self.family.patients count] + 1)];
        _managePatientsView.tintColor = [UIColor leoOrangeRed];
    }
    
    return _managePatientsView;
}


- (UITableView *)tableView {
    return self.managePatientsView.tableView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 68;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //MARK: Not sure I love the idea of the sender being the indexpath as opposed to the object in the row. Food for thought, but not right now.
    [self performSegueWithIdentifier:kSignUpPatientSegue sender:indexPath];
}

-(void)continueTapped:(UIButton * __nonnull)sender {
    
    [self performSegueWithIdentifier:kContinueSegue sender:sender];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    NSInteger patientIndex = 0;
    NSIndexPath *senderIndexPath;
    
    //MARK: At some point just go back and remind myself why the sender is an NSIndexPath when choosing a UITableViewCell.
    if ([sender isKindOfClass:[NSIndexPath class]]) {
        senderIndexPath = (NSIndexPath *)sender;
        patientIndex = [self tableView:[self tableView] currentRowForIndexPath:senderIndexPath];
    }
    
    if ([segue.identifier isEqualToString:kSignUpPatientSegue]) {
        
        LEOSignUpPatientViewController *signUpPatientVC = segue.destinationViewController;
        signUpPatientVC.family = self.family;
        signUpPatientVC.patient = [self.family.patients count] > patientIndex ? self.family.patients[patientIndex] : nil;
        
        if ([self isExistingPatientAtIndexPath:senderIndexPath]) {
            signUpPatientVC.managementMode = ManagementModeEdit;
        } else {
            signUpPatientVC.managementMode = ManagementModeCreate;
        }
        
        signUpPatientVC.delegate = self;
    }
    
    if ([segue.identifier isEqualToString:kContinueSegue]) {
        
        LEOReviewOnboardingViewController *reviewOnboardingVC = segue.destinationViewController;
        reviewOnboardingVC.family = self.family;
    }
}


- (BOOL)isExistingPatientAtIndexPath:(NSIndexPath *)indexPath {
    
    return indexPath.section == 0 ? YES : NO;
}

- (NSInteger)tableView:(UITableView *)tableView currentRowForIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger sumSections = 0;
    
    for (NSInteger i = 0; i < indexPath.section; i++) {
        int rowsInSection = [tableView numberOfRowsInSection:i];
        sumSections += rowsInSection;
    }
    
    return sumSections + indexPath.row;
}

- (void)addPatient:(Patient *)patient {
    
    [self.family addPatient:patient];
    [[self tableView] reloadData];
}



#pragma mark - Navigation

- (void)pop {
    
    [self.navigationController popViewControllerAnimated:YES];
    self.navigationController.navigationBarHidden = YES;
}

- (void)testData {
    
    Patient *patient = [[Patient alloc] initWithTitle:nil firstName:@"Zachary" middleInitial:@"S" lastName:@"Drossman" suffix:nil email:nil avatar:[UIImage imageNamed:@"Avatar-Emily"] dob:[NSDate date] gender:@"M" status:[@(PatientStatusInactive) stringValue]];
    
    Patient *patient2 = [[Patient alloc] initWithTitle:nil firstName:@"Zachary" middleInitial:@"S" lastName:@"Drossman" suffix:nil email:nil avatar:[UIImage imageNamed:@"Avatar-Emily"] dob:[NSDate date] gender:@"M" status:[@(PatientStatusInactive) stringValue]];
    
    Patient *patient3 = [[Patient alloc] initWithTitle:nil firstName:@"Zachary" middleInitial:@"S" lastName:@"Drossman" suffix:nil email:nil avatar:[UIImage imageNamed:@"Avatar-Emily"] dob:[NSDate date] gender:@"M" status:[@(PatientStatusInactive) stringValue]];
    
    Patient *patient4 = [[Patient alloc] initWithTitle:nil firstName:@"Zachary" middleInitial:@"S" lastName:@"Drossman" suffix:nil email:nil avatar:[UIImage imageNamed:@"Avatar-Emily"] dob:[NSDate date] gender:@"M" status:[@(PatientStatusInactive) stringValue]];
    
    Patient *patient5 = [[Patient alloc] initWithTitle:nil firstName:@"Zachary" middleInitial:@"S" lastName:@"Drossman" suffix:nil email:nil avatar:[UIImage imageNamed:@"Avatar-Emily"] dob:[NSDate date] gender:@"M" status:[@(PatientStatusInactive) stringValue]];
    
//    Patient *patient6 = [[Patient alloc] initWithTitle:nil firstName:@"Zachary" middleInitial:@"S" lastName:@"Drossman" suffix:nil email:nil avatar:[UIImage imageNamed:@"Avatar-Emily"] dob:[NSDate date] gender:@"M" status:[@(PatientStatusInactive) stringValue]];
//    
//    Patient *patient7 = [[Patient alloc] initWithTitle:nil firstName:@"Zachary" middleInitial:@"S" lastName:@"Drossman" suffix:nil email:nil avatar:[UIImage imageNamed:@"Avatar-Emily"] dob:[NSDate date] gender:@"M" status:[@(PatientStatusInactive) stringValue]];
//    
//    Patient *patient8 = [[Patient alloc] initWithTitle:nil firstName:@"Zachary" middleInitial:@"S" lastName:@"Drossman" suffix:nil email:nil avatar:[UIImage imageNamed:@"Avatar-Emily"] dob:[NSDate date] gender:@"M" status:[@(PatientStatusInactive) stringValue]];
    
    self.family.patients = @[patient, patient2, patient3, patient4, patient5]; //, patient6, patient7, patient8];
}


@end
