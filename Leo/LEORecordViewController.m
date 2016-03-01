//
//  LEORecordViewController.m
//  Leo
//
//  Created by Zachary Drossman on 5/26/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import "LEORecordViewController.h"
#import "LEOPHRViewController.h"

// helpers
#import "UIFont+LeoFonts.h"
#import "UIColor+LeoColors.h"
#import "LEOStyleHelper.h"
#import "LEOAlertHelper.h"

// views
#import "LEOPHRTableViewCell.h"
#import "LEOIntrinsicSizeTableView.h"
#import <MBProgressHUD.h>
#import "NSObject+TableViewAccurateEstimatedCellHeight.h"

// controllers
#import "LEORecordEditNotesViewController.h"

// model
#import "LEOHealthRecordService.h"
#import "HealthRecord.h"

@interface LEORecordViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic) BOOL alreadyUpdatedConstraints;
@property (weak, nonatomic) LEOIntrinsicSizeTableView *tableView;
@property (copy, nonatomic) NSString *cellReuseIdentifier;
@property (copy, nonatomic) NSString *headerReuseIdentifier;
@property (strong, nonatomic) UITableViewCell *sizingCell;
@property (strong, nonatomic) UITableViewHeaderFooterView *sizingHeader;

@property (strong, nonatomic) HealthRecord *healthRecord;
@property (strong, nonatomic) NSMutableArray *notes;

@end

@implementation LEORecordViewController

static NSString * const kEditButtonText = @"EDIT";

const CGFloat kPHRSectionLayoutSpacing = 4;
const CGFloat kPHRSectionLayoutHorizontalMargin = 28;
const CGFloat kPHRSectionLayoutTopMargin = 25;
const CGFloat kPHRSectionLayoutBottomMargin = 13;

static NSString * const kCopyEmptyNotesField = @"Use this area to record notes about your kids health. These notes will not be seen by your providers.";
static NSString * const kCopyEmptyImmunizationField = @"Immunization history is not available at this time.";
static NSString * const kCopyEmptyWeightField = @"Weight data unavailable.";
static NSString * const kCopyEmptyHeightField = @"Height data unavailable.";
static NSString * const kCopyEmptyBMIField = @"BMI data unavailable.";
static NSString * const kCopyEmptyAllergyField = @"No known allergies.";
static NSString * const kCopyEmptyMedicationsField = @"No active medications.";

NS_ENUM(NSInteger, PHRTableViewSection) {
    PHRTableViewSectionEmptyRecord = 0,
    PHRTableViewSectionRecentVitals,
    PHRTableViewSectionAllergies,
    PHRTableViewSectionMedications,
    PHRTableViewSectionImmunizations,
    PHRTableViewSectionNotes,
    PHRTableViewSectionCount
};

#pragma mark - Accessors and Setup

- (UITableView *)tableView {

    if (!_tableView) {

        LEOIntrinsicSizeTableView *strongView = [LEOIntrinsicSizeTableView new];
        [self.view addSubview:strongView];
        _tableView = strongView;

        _tableView.dataSource = self;
        _tableView.delegate = self;

        _tableView.backgroundColor = [UIColor leo_white];
        _tableView.scrollEnabled = NO;
        _tableView.separatorInset = UIEdgeInsetsMake(0, 20, 0, 20);

        _tableView.tableFooterView = [UIView new];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

        [_tableView registerNib:[LEOPHRTableViewCell nib] forCellReuseIdentifier:self.cellReuseIdentifier];
        [_tableView registerClass:[UITableViewHeaderFooterView class] forHeaderFooterViewReuseIdentifier:self.headerReuseIdentifier];
    }
    return _tableView;
}

- (NSString *)cellReuseIdentifier {

    if (!_cellReuseIdentifier) {
        _cellReuseIdentifier = NSStringFromClass([LEOPHRTableViewCell class]);
    }
    return _cellReuseIdentifier;
}

-(NSString *)headerReuseIdentifier {

    if (!_headerReuseIdentifier) {
        _headerReuseIdentifier = @"headerView";
    }
    return _headerReuseIdentifier;
}

- (void)requestHealthRecord {

    BOOL useMock = NO;

    if (!self.healthRecord) {
    __block BOOL readyToHideHUD = NO;

        LEOHealthRecordService *service = [LEOHealthRecordService new];

        [service getNotesForPatient:self.patient withCompletion:^(NSArray<PatientNote *> *notes, NSError *error) {

            if (error) {
                [LEOAlertHelper alertForViewController:self error:error];
            } else {

                self.notes = [notes mutableCopy];

                [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:PHRTableViewSectionNotes] withRowAnimation:UITableViewRowAnimationFade];
                [self.view setNeedsLayout];
                [self.view layoutIfNeeded];
            }
            
        if (readyToHideHUD) {
            [MBProgressHUD hideHUDForView:self.view.window animated:YES];
        }

        readyToHideHUD = YES;
    }];

        [service getHealthRecordForPatient:self.patient withCompletion:^(HealthRecord *healthRecord, NSError *error) {

            if (error) {

                [LEOAlertHelper alertForViewController:self error:error];
            } else {

                if (error) {

                    NSLog(@"ERROR: phr request - %@", error);
                }

                //TODO: This should be converted to work in a scheme only, and not be available in all versions of the app.
                if (useMock) {
                    healthRecord = [HealthRecord mockObject];
                }

                self.healthRecord = healthRecord;

                //MARK: May be an issue if tableview is reloading at the same time as when the notes field updates. Watch for crashes.
                [self reloadData];
            }

            if (readyToHideHUD) {
                [MBProgressHUD hideHUDForView:self.view.window animated:YES];
            }
            
            readyToHideHUD = YES;
        }];
    }
}

- (void)reloadData {

    [self.tableView reloadData];

    //TODO: ZSD - @afanslau - is this necessary and why?
    [self.view setNeedsLayout];
    [self.view layoutIfNeeded];
}

#pragma mark - Layout

- (void)updateViewConstraints {

    if (!self.alreadyUpdatedConstraints) {

        self.view.translatesAutoresizingMaskIntoConstraints = NO;
        self.tableView.translatesAutoresizingMaskIntoConstraints = NO;

        NSDictionary *viewsDictionary = NSDictionaryOfVariableBindings(_tableView);

        NSArray *tableViewHorizontalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_tableView]|" options:0 metrics:nil views:viewsDictionary];
        NSArray *tableViewVerticalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_tableView]|" options:0 metrics:nil views:viewsDictionary];

        [self.view addConstraints:tableViewHorizontalConstraints];
        [self.view addConstraints:tableViewVerticalConstraints];

        self.alreadyUpdatedConstraints = YES;
    }

    [super updateViewConstraints];
}

#pragma mark - <UITableViewDataSource>

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return PHRTableViewSectionCount;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    NSInteger rows = 0;

    if ([self healthRecordExists]) {
        switch (section) {

            case PHRTableViewSectionRecentVitals:
                rows += [self healthRecordExists] ? 3 : 0; //one for each of the vitals: height, weight, bmi;
                break;

            case PHRTableViewSectionAllergies:
                rows = [self healthRecordExists] ? self.healthRecord.allergies.count ?: 1 : 0;
                break;

            case PHRTableViewSectionMedications:
                rows = [self healthRecordExists] ? self.healthRecord.medications.count ? : 1 : 0;
                break;

            case PHRTableViewSectionImmunizations:
                rows = [self healthRecordExists] ? self.healthRecord.immunizations.count ? : 1 : 0;
                break;

            case PHRTableViewSectionNotes:
                rows += 1;
                break;
        }
    } else if (self.healthRecord) {

        switch (section) {

            case PHRTableViewSectionEmptyRecord:
                rows += ![self healthRecordExists];
                break;


            case PHRTableViewSectionNotes:
                
                self.notes? rows += 1 : 0;
                break;
        }
        
    }
    
    return rows;
}

/**
 *  If any data fields comes back from the API, the health record exists.
 *
 *  @return BOOL existence of health record
 */
- (BOOL)healthRecordExists {

    return (self.healthRecord.weights.count || self.healthRecord.heights.count || self.healthRecord.bmis.count || self.healthRecord.allergies.count || self.healthRecord.medications.count || self.healthRecord.immunizations.count) && self.healthRecord;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:self.cellReuseIdentifier forIndexPath:indexPath];

    [self configureCell:cell forIndexPath:indexPath];
    return cell;
}

- (void)configureCell:(UITableViewCell *)cell forIndexPath:(NSIndexPath*)indexPath {

    LEOPHRTableViewCell *_cell = (LEOPHRTableViewCell *)cell;

    switch (indexPath.section) {

        case PHRTableViewSectionEmptyRecord:
            [_cell configureCellForEmptyRecordWithPatient:self.patient];
            break;

        case PHRTableViewSectionRecentVitals: {

            switch (indexPath.row) {
                case 0:
                    [self configureCell:_cell atIndexPath:indexPath forHeights:self.healthRecord.heights];
                    break;

                case 1:
                    [self configureCell:_cell atIndexPath:indexPath forWeights:self.healthRecord.weights];
                    break;

                case 2:
                    [self configureCell:_cell atIndexPath:indexPath forBMIs:self.healthRecord.bmis];
                    break;
            }
        }
            break;

        case PHRTableViewSectionAllergies:
            [self configureCell:_cell atIndexPath:indexPath forAllergies:self.healthRecord.allergies];
            break;

        case PHRTableViewSectionMedications:
            [self configureCell:_cell atIndexPath:indexPath forMedications:self.healthRecord.medications];
            break;

        case PHRTableViewSectionImmunizations:
            [self configureCell:_cell atIndexPath:indexPath forImmunizations:self.healthRecord.immunizations];
            break;

        case PHRTableViewSectionNotes:
            [self configureCell:_cell atIndexPath:indexPath forNotes:self.notes];
            break;
    }
}


- (UITableViewCell *)configureCell:(LEOPHRTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath forAllergies:(NSArray <Allergy *>*)allergies {

    if (self.healthRecord.allergies.count > 0) {
        [cell configureCellWithAllergy:allergies[indexPath.row]];
    } else {
        [cell configureCellForEmptySectionWithMessage:kCopyEmptyAllergyField];
    }

    return cell;
}

- (UITableViewCell *)configureCell:(LEOPHRTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath forWeights:(NSArray <PatientVitalMeasurement *>*)weights {

    if (weights.count) {
        [cell configureCellWithVital:weights.firstObject title:@"Weight"];
    } else {
        [cell configureCellForEmptySectionWithMessage:kCopyEmptyWeightField];
    }

    return cell;
}

- (UITableViewCell *)configureCell:(LEOPHRTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath forHeights:(NSArray <PatientVitalMeasurement *>*)heights {

    if (heights.count) {
        [cell configureCellWithVital:heights.firstObject title:@"Height"];
    } else {
        [cell configureCellForEmptySectionWithMessage:kCopyEmptyHeightField];
    }

    return cell;
}

- (UITableViewCell *)configureCell:(LEOPHRTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath forBMIs:(NSArray <PatientVitalMeasurement *>*)bmis {

    if (bmis.count) {
        [cell configureCellWithVital:bmis.firstObject title:@"BMI"];
    } else {
        [cell configureCellForEmptySectionWithMessage:kCopyEmptyBMIField];
    }

    return cell;
}

- (UITableViewCell *)configureCell:(LEOPHRTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath forMedications:(NSArray <Medication *>*)medications {

    if (medications.count > 0) {
        [cell configureCellWithMedication:medications[indexPath.row]];
    } else {
        [cell configureCellForEmptySectionWithMessage:kCopyEmptyMedicationsField];
    }

    return cell;
}

- (UITableViewCell *)configureCell:(LEOPHRTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath forImmunizations:(NSArray <Immunization *>*)immunizations {

    if (immunizations.count > 0) {
        [cell configureCellWithImmunization:immunizations[indexPath.row]];
    } else {
        [cell configureCellForEmptySectionWithMessage:kCopyEmptyImmunizationField];
    }

    return cell;
}

- (UITableViewCell *)configureCell:(LEOPHRTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath forNotes:(NSArray <PatientNote *>*)notes {

    if (indexPath.row < self.notes.count) {
        [cell configureCellWithNote:self.notes[indexPath.row]];
    } else {
        [cell configureCellForEmptySectionWithMessage:kCopyEmptyNotesField];
    }

    return cell;
}


#pragma mark - <UITableViewDelegate>

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {

    // only show header if the section has rows
    if ([self tableView:tableView numberOfRowsInSection:section] == 0) {
        return CGFLOAT_MIN;
    }

    [self configureSectionHeader:self.sizingHeader forSection:section];
    CGSize size = [self.sizingHeader systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    return size.height;
}


- (UITableViewHeaderFooterView *)sizingHeader {

    if (!_sizingHeader) {
        _sizingHeader = [UITableViewHeaderFooterView new];
    }

    return _sizingHeader;
}

- (UITableViewHeaderFooterView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {

    // only show header if the section has rows
    if ([self tableView:tableView numberOfRowsInSection:section] == 0) {
        return nil;
    }

    UITableViewHeaderFooterView *sectionHeaderView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:self.headerReuseIdentifier];

    [sectionHeaderView.contentView removeConstraints:sectionHeaderView.contentView.constraints];
    for (UIView *subview in sectionHeaderView.contentView.subviews) {
        [subview removeFromSuperview];
    }

    [self configureSectionHeader:sectionHeaderView forSection:section];

    return sectionHeaderView;
}

- (void)configureSectionHeader:(UITableViewHeaderFooterView *)sectionHeaderView forSection:(NSInteger)section {

    UILabel *_titleLabel = [UILabel new];
    _titleLabel.font = [UIFont leo_fieldAndUserLabelsAndSecondaryButtonsFont];
    _titleLabel.textColor = [UIColor leo_grayStandard];

    UIView *_separatorLine = [UIView new];
    [_separatorLine setBackgroundColor:[UIColor leo_grayStandard]];

    UIButton *_editNoteButton = [UIButton new];
    [_editNoteButton setTitle:kEditButtonText forState:UIControlStateNormal];
    _editNoteButton.titleLabel.font = [UIFont leo_buttonLabelsAndTimeStampsFont];
    [_editNoteButton setTitleColor:[UIColor leo_orangeRed] forState:UIControlStateNormal];
    [_editNoteButton addTarget:self action:@selector(editNoteTouchedUpInside) forControlEvents:UIControlEventTouchUpInside];
    _editNoteButton.hidden = section != PHRTableViewSectionNotes;

    if (section != PHRTableViewSectionNotes) {
        _editNoteButton.hidden = YES;
    }

    sectionHeaderView.contentView.backgroundColor = [UIColor clearColor];

    [sectionHeaderView.contentView addSubview:_titleLabel];
    [sectionHeaderView.contentView addSubview:_separatorLine];
    [sectionHeaderView.contentView addSubview:_editNoteButton];

    sectionHeaderView.backgroundView = [UIView new];

    sectionHeaderView.contentView.translatesAutoresizingMaskIntoConstraints = NO;
    _titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _separatorLine.translatesAutoresizingMaskIntoConstraints = NO;
    _editNoteButton.translatesAutoresizingMaskIntoConstraints = NO;

    NSNumber *spacing = @(kPHRSectionLayoutSpacing);
    NSNumber *horizontalMargin = @(kPHRSectionLayoutHorizontalMargin);
    NSNumber *topMargin = @(kPHRSectionLayoutTopMargin);
    NSNumber *bottomMargin = @(kPHRSectionLayoutBottomMargin);
    UIView* _contentView = sectionHeaderView.contentView;
    NSDictionary *views = NSDictionaryOfVariableBindings(_titleLabel, _separatorLine, _editNoteButton, _contentView);
    NSDictionary *metrics = NSDictionaryOfVariableBindings(spacing, horizontalMargin, topMargin, bottomMargin);

    [sectionHeaderView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_contentView]|" options:0 metrics:nil views:views]];
    [sectionHeaderView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_contentView]|" options:0 metrics:nil views:views]];
    [sectionHeaderView.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(topMargin)-[_editNoteButton]-(spacing)-[_separatorLine]" options:0 metrics:metrics views:views]];
    [sectionHeaderView.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(topMargin)-[_titleLabel]-(spacing)-[_separatorLine(1)]-(bottomMargin)-|" options:0 metrics:metrics views:views]];
    [sectionHeaderView.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(horizontalMargin)-[_titleLabel]-(>=horizontalMargin)-[_editNoteButton]-(horizontalMargin)-|" options:0 metrics:metrics views:views]];
    [sectionHeaderView.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(horizontalMargin)-[_separatorLine]-(horizontalMargin)-|" options:0 metrics:metrics views:views]];

    NSString *title;

    switch (section) {

        case PHRTableViewSectionEmptyRecord:
            title = nil;
            break;

        case PHRTableViewSectionRecentVitals:
            title = @"RECENT VITALS";
            break;

        case PHRTableViewSectionAllergies:
            title = @"ALLERGIES";
            break;

        case PHRTableViewSectionMedications:
            title = @"MEDICATIONS";
            break;

        case PHRTableViewSectionImmunizations:
            title = @"IMMUNIZATIONS";
            break;

        case PHRTableViewSectionNotes:
            title = @"NOTES";
            break;
    }

    _titleLabel.text = title;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    [self configureCell:self.sizingCell forIndexPath:indexPath];

    // get margins from the nib to determine the preferred max layout width
    // ????: HAX: is there a less hacky way of doing this?
    UILabel *growingLabel = [(LEOPHRTableViewCell *)self.sizingCell recordMainDetailLabel];
    CGFloat margins = CGRectGetWidth(self.sizingCell.contentView.bounds) - CGRectGetWidth(growingLabel.bounds);
    CGFloat finalWidth = CGRectGetWidth(tableView.bounds) - margins;
    [growingLabel setPreferredMaxLayoutWidth:finalWidth];

    CGSize size = [self.sizingCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    return size.height;
}

- (UITableViewCell *)sizingCell {

    if (!_sizingCell) {
        _sizingCell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([LEOPHRTableViewCell class]) owner:nil options:nil] firstObject];
    }

    return _sizingCell;
}

#pragma mark - Actions

- (void)editNoteTouchedUpInside {
    
    PatientNote* note;

    if (self.notes.count > 0) {
        note = [self.notes lastObject]; // TODO: update to handle multiple notes
    }
    
    [self presentEditNotesViewControllerWithNote:note];
}

- (void)presentEditNotesViewControllerWithNote:(PatientNote*)note {
    
    LEORecordEditNotesViewController *vc = [LEORecordEditNotesViewController new];
    vc.patient = self.patient;
    vc.note = note;

    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    [self.phrViewController presentViewController:nav animated:YES completion:nil];
    
    vc.editNoteCompletionBlock = ^(PatientNote *updatedNote) {
        // update the in memory note
        [self updateNote:updatedNote];
        [self reloadData];
    };
}

- (void)updateNote:(PatientNote *)updatedNote {
    
    int i = 0;

    for (PatientNote *note in self.notes) {
        if ([note.objectID isEqualToString:updatedNote.objectID] || (!note.objectID && !updatedNote.objectID) ) {
            
            [self.notes[i] updateWithPatientNote:updatedNote];
            return;
        }
        i++;
    }

    // if not found, this is a newly created note.
    [self.notes addObject:updatedNote];
}


@end
