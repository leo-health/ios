//
//  LEOPHRViewController.m
//  Leo
//
//  Created by Zachary Drossman on 12/27/15.
//  Copyright © 2015 Leo Health. All rights reserved.
//

#import "LEOPHRViewController.h"
#import "LEOPHRHeaderView.h"
#import "LEOPHRBodyView.h"
#import "LEOStyleHelper.h"
#import "LEOAnalyticSession.h"
#import "LEOAnalyticSessionManager.h"

#import "GNZSegmentedControl.h"
#import "GNZSlidingSegmentView.h"
#import "UISegmentedControl+GNZCompatibility.h"

#import "Patient.h"
#import <MBProgressHUD/MBProgressHUD.h>

#import "LEOHealthRecordService.h"

#import "UIColor+LeoColors.h"
#import "LEOAlertHelper.h"
#import "LEORecordEditNotesViewController.h"
#import "LEOAnalytic.h"

static CGFloat const kHeightOfHeaderPHR = 97;

@interface LEOPHRViewController () <LEOStickyHeaderDataSource, LEOStickyHeaderDelegate>

@property (weak, nonatomic) LEOPHRHeaderView *headerView;
@property (strong, nonatomic) LEOPHRBodyView *bodyView;

@property (nonatomic) BOOL alreadyUpdatedConstraints;

@property (copy, nonatomic) NSArray *patients;
@property (copy, nonatomic) NSArray *healthRecords;
@property (copy, nonatomic) NSArray *notes;

@property (strong, nonatomic) LEOAnalyticSessionManager *analyticSessionManager;


@end

@implementation LEOPHRViewController

#pragma mark - VCL & Helper

- (instancetype)initWithPatients:(NSArray *)patients {

    self = [super init];
    if (self) {
        _patients = patients;
    }
    return self;
}

- (void)viewDidLoad {

    [super viewDidLoad];

    self.analyticSessionManager = [LEOAnalyticSessionManager new];
    [self.analyticSessionManager startMonitoringWithName:kAnalyticSessionHealthRecord];

    self.automaticallyAdjustsScrollViewInsets = NO;
    self.stickyHeaderView.delegate = self;
    self.stickyHeaderView.datasource = self;

    [LEOApiReachability startMonitoringForController:self];
}

- (LEOStickyHeaderView *)stickyHeaderView {

    if (!_stickyHeaderView) {

        _stickyHeaderView = [super stickyHeaderView];
        _stickyHeaderView.headerShouldNotBounceOnScroll = YES;
        _stickyHeaderView.breakerHidden = YES;
    }

    return _stickyHeaderView;
}

- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];
    [self setupNavigationBar];
}

- (void)viewDidAppear:(BOOL)animated {

    [super viewDidAppear:animated];

    [LEOAnalytic tagType:LEOAnalyticTypeScreen
                    name:kAnalyticScreenHealthRecord];

    [self requestHealthRecord];
}

- (void)requestHealthRecord {

    if (!self.healthRecords) {

        // only show one HUD at a time
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];

        __block BOOL readyToHideHUD = NO;

        LEOHealthRecordService *service = [LEOHealthRecordService new];

        __block NSInteger notesCounter = 0;
        __block NSInteger healthRecordCounter = 0;

        for (NSInteger i = 0; i < [self.patients count]; i++) {

            Patient *patient = self.patients[i];

            [service getNotesForPatient:patient withCompletion:^(NSArray<PatientNote *> *notes, NSError *error) {

                if (error) {

                    [LEOAlertHelper alertForViewController:self
                                                     error:error
                                               backupTitle:kErrorDefaultTitle
                                             backupMessage:kErrorDefaultMessage];
                    return;
                } else {
                    patient.notes = notes;
                }

                notesCounter++;

                //TODO: This should be done with KVO etc.
                if (i == [self selectedPatientIndex]) {
                    [self.bodyView reloadDataForPatient];
                }

                if (healthRecordCounter == [self.patients count] && notesCounter == [self.patients count]) {
                    readyToHideHUD = YES;
                }

                if (readyToHideHUD) {
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                }
            }];

            [service getHealthRecordForPatient:patient withCompletion:^(HealthRecord *healthRecord, NSError *error) {

                if (error) {

                    [LEOAlertHelper alertForViewController:self
                                                     error:error
                                               backupTitle:kErrorDefaultTitle
                                             backupMessage:kErrorDefaultMessage];
                    return;
                } else {
                    patient.healthRecord = healthRecord;
                }

                healthRecordCounter++;

                //TODO: This should be done with KVO etc.
                if (i == [self selectedPatientIndex]) {
                    [self.bodyView reloadDataForPatient];
                }
                
                if (healthRecordCounter == [self.patients count] && notesCounter == [self.patients count]) {
                    readyToHideHUD = YES;
                }

                if (readyToHideHUD) {
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                }
            }];
        }
    }
}

- (NSInteger)selectedPatientIndex {
    return self.headerView.selectedSegment;
}

-(void)setupNavigationBar {

    [LEOStyleHelper styleBackButtonForViewController:self
                                          forFeature:FeatureSettings];


    self.navigationController.navigationBarHidden = NO;

    //FIXME: When we replace the LEOPHRHeaderView with a subclass of LEOGradientView, set this to YES, and update the size of everything to reflect the additional 64 points (or as needed).

    UINavigationBar *navBar = self.navigationController.navigationBar;

    navBar.translucent = NO;
    navBar.backgroundColor = [UIColor clearColor];
    navBar.tintColor = [UIColor leo_white];
    navBar.shadowImage = [UIImage new];
}

#pragma mark - Accessors

-(LEOPHRHeaderView *)headerView {

    if (!_headerView) {

        LEOPHRHeaderView *strongHeaderView =
        [[LEOPHRHeaderView alloc] initWithPatients:self.patients];

        _headerView = strongHeaderView;
        _headerView.backgroundColor = [UIColor leo_white];

        __weak typeof(self) weakSelf = self;

        _headerView.segmentDidChangeBlock = ^ {

            __strong typeof(self) strongSelf = weakSelf;

            strongSelf.bodyView.patient = strongSelf.patients[[strongSelf selectedPatientIndex]];
        };

        NSDictionary *metrics = @{@"height":@(kHeightOfHeaderPHR)};

        // TODO: Remove when subview content is available to size view
        [_headerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_headerView]"
                                                                            options:0
                                                                            metrics:metrics
                                                                              views:NSDictionaryOfVariableBindings(_headerView)]];
    }

    return _headerView;
}

//- (NSNumber *)heightOfHeaderPHR {
//
//    if (self.patients.count == 1) {
//        return @96;
//    } else {
//        return @(kHeightOfHeaderPHR);
//    }
//}

-(LEOPHRBodyView *)bodyView {

    if (!_bodyView) {

        _bodyView = [LEOPHRBodyView new];

        _bodyView.patient = self.patients[[self selectedPatientIndex]];

        __weak typeof(self) weakSelf = self;

        _bodyView.editNoteTouchedUpInsideBlock = ^(NSArray *notes) {

            __strong typeof(self) strongSelf = weakSelf;

            PatientNote* note;

            note = notes.lastObject; // TODO: update to handle multiple notes

            [strongSelf presentEditNotesViewControllerWithNote:note];
        };
    }

    return _bodyView;
}

#pragma mark - Sticky Header View DataSource

-(UIView *)injectBodyView {
    return self.bodyView;
}

-(UIView *)injectTitleView {
    return self.headerView;
}

- (void)pop {

    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Actions

- (void)presentEditNotesViewControllerWithNote:(PatientNote*)note {

    LEORecordEditNotesViewController *recordEditNotesVC = [LEORecordEditNotesViewController new];
    recordEditNotesVC.patient = self.patients[[self selectedPatientIndex]];
    recordEditNotesVC.note = note;

    __weak typeof(self) weakSelf = self;

    recordEditNotesVC.editNoteCompletionBlock = ^(PatientNote *updatedNote) {

        __strong typeof(self) strongSelf = weakSelf;

        [strongSelf updateNote:updatedNote];
        strongSelf.bodyView.notes = strongSelf.notes[[self selectedPatientIndex]];
    };

    UINavigationController *navController =
    [[UINavigationController alloc] initWithRootViewController:recordEditNotesVC];
    
    [self presentViewController:navController animated:YES completion:nil];
}

- (void)updateNote:(PatientNote *)updatedNote {
    
    int i = 0;
    
    NSMutableArray *notesForPatient =  self.notes[[self selectedPatientIndex]];
    
    for (PatientNote *note in notesForPatient) {

        if ([note.objectID isEqualToString:updatedNote.objectID] ||
            (!note.objectID && !updatedNote.objectID) ) {
            
            [notesForPatient[i] updateWithPatientNote:updatedNote];
            return;
        }

        i++;
    }
    
    // if not found, this is a newly created note.
    [notesForPatient addObject:updatedNote];
    [self.analyticSessionManager stopMonitoring];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
