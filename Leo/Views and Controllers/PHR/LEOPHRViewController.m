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

#import "GNZSegmentedControl.h"
#import "GNZSlidingSegmentView.h"
#import "UISegmentedControl+GNZCompatibility.h"

#import "Patient.h"
#import "LEOPHRBodyView.h"
#import <MBProgressHUD/MBProgressHUD.h>

#import "LEOHealthRecordService.h"

#import "UIColor+LeoColors.h"
#import "LEOAlertHelper.h"
#import "LEORecordEditNotesViewController.h"

static CGFloat const kHeightOfHeaderPHR = 200;

@interface LEOPHRViewController () <LEOStickyHeaderDataSource, LEOStickyHeaderDelegate>

@property (weak, nonatomic) LEOPHRHeaderView *headerView;

@property (nonatomic) BOOL alreadyUpdatedConstraints;

@property (strong, nonatomic) NSArray *patients;
@property (strong, nonatomic) NSArray *healthRecords;
@property (strong, nonatomic) NSArray *notes;

@property (strong, nonatomic) LEOAnalyticSession *analyticSession;

@property (strong, nonatomic) LEOPHRBodyView *bodyView;

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

    self.analyticSession = [LEOAnalyticSession startSessionWithSessionEventName:kAnalyticSessionHealthRecord];

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

    [Localytics tagScreen:kAnalyticScreenHealthRecord];

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

        NSMutableArray *mutableNotes = [NSMutableArray new];
        NSMutableArray *mutableHealthRecords = [NSMutableArray new];

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

                if (i == [self selectedPatient]) {
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
                if (i == [self selectedPatient]) {
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

- (NSInteger)selectedPatient {
    return self.headerView.selectedSegment;
}

-(void)setupNavigationBar {

    [LEOStyleHelper styleBackButtonForViewController:self forFeature:FeatureSettings];

    self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationBar.translucent = YES;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.tintColor = [UIColor leo_white];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
}

#pragma mark - Accessors

-(LEOPHRHeaderView *)headerView {

    if (!_headerView) {

        LEOPHRHeaderView *strongHeaderView = [[LEOPHRHeaderView alloc] initWithPatients:self.patients];
        _headerView = strongHeaderView;
        _headerView.backgroundColor = [UIColor leo_white];


        __weak typeof(self) weakSelf = self;

        _headerView.segmentDidChangeBlock = ^ {

            __strong typeof(self) strongSelf = weakSelf;

            strongSelf.bodyView.patient = strongSelf.patients[[strongSelf selectedPatient]];
        };

        // TODO: Remove when subview content is available to size view
        [_headerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_headerView(height)]" options:0 metrics:@{@"height":@(kHeightOfHeaderPHR)} views:NSDictionaryOfVariableBindings(_headerView)]];
    }

    return _headerView;
}

-(LEOPHRBodyView *)bodyView {

    if (!_bodyView) {

        _bodyView = [LEOPHRBodyView new];

        _bodyView.patient = self.patients[[self selectedPatient]];

        __weak typeof(self) weakSelf = self;

        _bodyView.editNoteTouchedUpInsideBlock = ^(NSArray *notes) {

            __strong typeof(self) strongSelf = weakSelf;

            PatientNote* note;

            if (strongSelf.notes.count > 0) {
                note = notes.lastObject; // TODO: update to handle multiple notes
            }

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

    [self.analyticSession completeSession];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Actions

- (void)presentEditNotesViewControllerWithNote:(PatientNote*)note {

    LEORecordEditNotesViewController *vc = [LEORecordEditNotesViewController new];
    vc.patient = self.patients[[self selectedPatient]];
    vc.note = note;

    __weak typeof(self) weakSelf = self;

    vc.editNoteCompletionBlock = ^(PatientNote *updatedNote) {

        __strong typeof(self) strongSelf = weakSelf;

        [strongSelf updateNote:updatedNote];
        strongSelf.bodyView.notes = self.notes[[self selectedPatient]];
    };
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)updateNote:(PatientNote *)updatedNote {
    
    int i = 0;
    
    NSMutableArray *notes =  self.notes[[self selectedPatient]];
    
    for (PatientNote *note in notes) {
        if ([note.objectID isEqualToString:updatedNote.objectID] || (!note.objectID && !updatedNote.objectID) ) {
            
            [notes[i] updateWithPatientNote:updatedNote];
            return;
        }
        i++;
    }
    
    // if not found, this is a newly created note.
    [notes addObject:updatedNote];
}

@end
