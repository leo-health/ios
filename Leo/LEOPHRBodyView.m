//
//  LEOPHRBodyView.m
//  Leo
//
//  Created by Zachary Drossman on 5/26/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import "LEOPHRBodyView.h"
#import "LEOPHRViewController.h"

// helpers
#import "UIFont+LeoFonts.h"
#import "UIColor+LeoColors.h"
#import "LEOStyleHelper.h"
#import "LEOAlertHelper.h"
#import <NSDate+DateTools.h>

// views
#import "LEOPHRTableViewCell.h"
#import "LEOPHRVitalsCell+ConfigureForCell.h"

#import "LEOIntrinsicSizeTableView.h"
#import <MBProgressHUD.h>
#import "NSObject+TableViewAccurateEstimatedCellHeight.h"
#import "NSString+Extensions.h"

// controllers
#import "LEORecordEditNotesViewController.h"

// model
#import "LEOHealthRecordService.h"
#import "HealthRecord.h"
#import "PatientNote.h"

@interface LEOPHRBodyView () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic) BOOL alreadyUpdatedConstraints;
@property (weak, nonatomic) LEOIntrinsicSizeTableView *tableView;
@property (copy, nonatomic) NSString *headerReuseIdentifier;
@property (strong, nonatomic) UITableViewCell *sizingCell;
@property (strong, nonatomic) UITableViewHeaderFooterView *sizingHeader;

@property (strong, nonatomic) LEOVitalGraphViewController *graphViewController;

@end

@implementation LEOPHRBodyView

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

NS_ENUM(NSInteger, TableViewSection) {
    TableViewSectionRecentVitals = 0,
    TableViewSectionEmptyRecord = 1,
    TableViewSectionAllergies,
    TableViewSectionMedications,
    TableViewSectionImmunizations,
    TableViewSectionNotes,
    TableViewSectionCount
};

NS_ENUM(NSInteger, TableViewRow) {
    TableViewRowVitalHeight,
    TableViewRowVitalWeight,
    TableViewRowVitalBMI,
};

#pragma mark - Accessors and Setup

- (void)reloadDataForPatient {

    [self.tableView reloadData];
    [self.graphViewController reloadWithUIUpdates];
}

- (UITableView *)tableView {

    if (!_tableView) {

        LEOIntrinsicSizeTableView *strongView = [LEOIntrinsicSizeTableView new];
        [self addSubview:strongView];
        _tableView = strongView;

        _tableView.dataSource = self;
        _tableView.delegate = self;

        _tableView.backgroundColor = [UIColor leo_white];
        _tableView.scrollEnabled = NO;
        _tableView.separatorInset = UIEdgeInsetsMake(0, 20, 0, 20);

        _tableView.tableFooterView = [UIView new];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.rowHeight = UITableViewAutomaticDimension;

        [_tableView registerNib:[LEOPHRTableViewCell nib] forCellReuseIdentifier:NSStringFromClass([LEOPHRTableViewCell class])];
        [_tableView registerNib:[LEOPHRVitalsCell nib] forCellReuseIdentifier:NSStringFromClass([LEOPHRVitalsCell class])];
        [_tableView registerClass:[UITableViewHeaderFooterView class] forHeaderFooterViewReuseIdentifier:@"headerView"];
    }

    return _tableView;
}

- (void)setPatient:(Patient *)patient {

    _patient = patient;

    [self.graphViewController reloadWithUIUpdates];
    [self.tableView reloadData];
}

#pragma mark - Layout

- (void)updateConstraints {

    if (!self.alreadyUpdatedConstraints) {

        self.translatesAutoresizingMaskIntoConstraints = NO;
        self.tableView.translatesAutoresizingMaskIntoConstraints = NO;

        NSDictionary *viewsDictionary = NSDictionaryOfVariableBindings(_tableView);

        NSArray *tableViewHorizontalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_tableView]|" options:0 metrics:nil views:viewsDictionary];
        NSArray *tableViewVerticalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_tableView]|" options:0 metrics:nil views:viewsDictionary];

        [self addConstraints:tableViewHorizontalConstraints];
        [self addConstraints:tableViewVerticalConstraints];

        self.alreadyUpdatedConstraints = YES;
    }

    [super updateConstraints];
}

#pragma mark - <UITableViewDataSource>

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return TableViewSectionCount;
}

- (HealthRecord *)healthRecord {

//Commented out because this is just temp testing code. Should remove before code review.
//    HealthRecord *record = _patient.healthRecord;
//
//    PatientVitalMeasurement *weight = [[PatientVitalMeasurement alloc] initWithTakenAt:[NSDate date] value:@48 percentile:@95 unit:@"pounds" measurementType:PatientVitalMeasurementTypeWeight valueAndUnitFormatted:@"48 pounds"];
//
//    record.weights = @[weight];
//    record.heights = @[weight];
//    record.bmis = @[weight];

//    return record;

    return _patient.healthRecord;
}

- (NSArray *)notes {
    return self.patient.notes;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    NSInteger rows = 0;

    if (self.healthRecord) {

        switch (section) {

            case TableViewSectionAllergies:
                rows = [self healthRecordContainsData] ? self.healthRecord.allergies.count ?: 1 : 0;
                break;

            case TableViewSectionMedications:
                rows = [self healthRecordContainsData] ? self.healthRecord.medications.count ? : 1 : 0;
                break;

            case TableViewSectionImmunizations:
                rows = [self healthRecordContainsData] ? self.healthRecord.immunizations.count ? : 1 : 0;
                break;

            case TableViewSectionNotes:
                rows = 1;
                break;

            case TableViewSectionEmptyRecord:

                rows = [self healthRecordContainsData] ? 0 : 1;
                break;
        }
    }

    if (section == TableViewSectionRecentVitals) {

        if ([self shouldDisplayGraphOfVitals]) {
            rows = 1;
        }

        else if ([self shouldDisplayLastVitalsOnly]) {
            rows = 3;
        }
    }


    return rows;
}

- (BOOL)shouldDisplayLastVitalsOnly {
    return self.healthRecord.weights.count == 1;
}

- (BOOL)shouldDisplayGraphOfVitals {
    return self.healthRecord.weights.count > 1;
}

/**
 *  If any data fields comes back from the API, the health record exists.
 *
 *  @return BOOL existence of health record
 */
- (BOOL)healthRecordContainsData {

    return (self.healthRecord.weights.count || self.healthRecord.heights.count || self.healthRecord.bmis.count || self.healthRecord.allergies.count || self.healthRecord.medications.count || self.healthRecord.immunizations.count);
}

- (BOOL)healthRecordContainsNoData {
    return !(self.healthRecord.weights.count || self.healthRecord.heights.count || self.healthRecord.bmis.count || self.healthRecord.allergies.count || self.healthRecord.medications.count || self.healthRecord.immunizations.count) && self.healthRecord;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell *cell;

    if (indexPath.section == TableViewSectionRecentVitals && [self shouldDisplayGraphOfVitals]) {


            LEOPHRVitalsCell *graphCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([LEOPHRVitalsCell class]) forIndexPath:indexPath];

            graphCell.hostedGraphView = self.graphViewController.view;

            return graphCell;

    } else {
        cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([LEOPHRTableViewCell class]) forIndexPath:indexPath];
        [self configureTextCell:cell forIndexPath:indexPath];
    }


    return cell;
}

-(LEOVitalGraphViewController *)graphViewController {

    if (!_graphViewController) {

        LEOVitalGraphViewController *viewController = [[LEOVitalGraphViewController alloc] initWithPatient:self.patient];

        _graphViewController = viewController;
    }

    return _graphViewController;
}

- (void)configureTextCell:(UITableViewCell *)cell forIndexPath:(NSIndexPath*)indexPath {

    LEOPHRTableViewCell *textCell = (LEOPHRTableViewCell *)cell;

    // MARK: IOS8 only
    // get margins from the nib to determine the preferred max layout width
    // ????: HAX: is there a less hacky way of doing this?
    UILabel *growingLabel = textCell.recordMainDetailLabel;
    CGFloat margins = CGRectGetWidth(textCell.contentView.bounds) - CGRectGetWidth(growingLabel.bounds);
    CGFloat finalWidth = CGRectGetWidth(self.tableView.bounds) - margins;
    [growingLabel setPreferredMaxLayoutWidth:finalWidth];

    UILabel *othergrowingLabel = textCell.recordTitleLabel;
    CGFloat othermargins = CGRectGetWidth(textCell.contentView.bounds) - CGRectGetWidth(othergrowingLabel.bounds);
    CGFloat otherfinalWidth = CGRectGetWidth(self.tableView.bounds) - othermargins;
    [othergrowingLabel setPreferredMaxLayoutWidth:otherfinalWidth];

    switch (indexPath.section) {

        case TableViewSectionEmptyRecord:
            [textCell configureCellForEmptyRecordWithPatient:self.patient];
            break;


        case TableViewSectionRecentVitals: {
            [self configureCellForVital:textCell atIndexPath:indexPath];
            break;
        }

        case TableViewSectionAllergies:
            [self configureCell:textCell atIndexPath:indexPath forAllergies:self.healthRecord.allergies];
            break;

        case TableViewSectionMedications:
            [self configureCell:textCell atIndexPath:indexPath forMedications:self.healthRecord.medications];
            break;

        case TableViewSectionImmunizations:
            [self configureCell:textCell atIndexPath:indexPath forImmunizations:self.healthRecord.immunizations];
            break;

        case TableViewSectionNotes:
            [self configureCell:textCell atIndexPath:indexPath forNotes:self.notes];
            break;
    }
}

- (void)configureChartCell:(UITableViewCell *)cell forIndexPath:(NSIndexPath *)indexPath {

    LEOPHRVitalsCell *chartCell = (LEOPHRVitalsCell *)cell;

    [chartCell configureCellWithData:nil];
}

- (void)configureCellForVital:(LEOPHRTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {

    switch (indexPath.row) {

        case 0:
            [self configureCell:cell atIndexPath:indexPath forWeights:self.healthRecord.weights];
            break;

        case 1:
            [self configureCell:cell atIndexPath:indexPath forHeights:self.healthRecord.heights];
            break;

        case 2:
            [self configureCell:cell atIndexPath:indexPath forBMIs:self.healthRecord.bmis];
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

    if (weights.count > 0) {
        [cell configureCellWithVital:weights.lastObject title:@"Weight"];
    } else {
        [cell configureCellForEmptySectionWithMessage:kCopyEmptyWeightField];
    }

    return cell;
}

- (UITableViewCell *)configureCell:(LEOPHRTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath forHeights:(NSArray <PatientVitalMeasurement *>*)heights {

    if (heights.count > 0) {
        [cell configureCellWithVital:heights.lastObject title:@"Height"];
    } else {
        [cell configureCellForEmptySectionWithMessage:kCopyEmptyHeightField];
    }

    return cell;
}

- (UITableViewCell *)configureCell:(LEOPHRTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath forBMIs:(NSArray <PatientVitalMeasurement *>*)bmis {

    if (bmis.count > 0) {
        [cell configureCellWithVital:bmis.lastObject title:@"BMI"];
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

    PatientNote *note = indexPath.row < notes.count ? notes[indexPath.row] : nil;

    if (note && ![note.text leo_isWhitespace]) {
        [cell configureCellWithNote:notes[indexPath.row]];
    } else {
        [cell configureCellForEmptySectionWithMessage:kCopyEmptyNotesField];
    }

    return cell;
}


#pragma mark - <UITableViewDelegate>

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {

    // only show header if the section has rows
    if ([self tableView:tableView numberOfRowsInSection:section] == 0 || section == TableViewSectionRecentVitals) {
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

    if (section != TableViewSectionRecentVitals) {
        
        // only show header if the section has rows
        if ([self tableView:tableView numberOfRowsInSection:section] == 0) {
            return nil;
        }

        UITableViewHeaderFooterView *sectionHeaderView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"headerView"];

        [sectionHeaderView.contentView removeConstraints:sectionHeaderView.contentView.constraints];
        for (UIView *subview in sectionHeaderView.contentView.subviews) {
            [subview removeFromSuperview];
        }

        [self configureSectionHeader:sectionHeaderView forSection:section];

        return sectionHeaderView;
    }

    return nil;
}

- (void)configureSectionHeader:(UITableViewHeaderFooterView *)sectionHeaderView forSection:(NSInteger)section {

    //TODO: This is a patch; at the very least this should be refactored so objects aren't being created and added as subviews every single time this method gets run.
    for (UIView *subview in sectionHeaderView.contentView.subviews) {
        [subview removeFromSuperview];
    }

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
    _editNoteButton.hidden = section != TableViewSectionNotes;

    if (section != TableViewSectionNotes) {
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

        case TableViewSectionEmptyRecord:
            title = nil;
            break;

        case TableViewSectionRecentVitals:
            title = @"RECENT VITALS";
            break;

        case TableViewSectionAllergies:
            title = @"ALLERGIES";
            break;

        case TableViewSectionMedications:
            title = @"MEDICATIONS";
            break;

        case TableViewSectionImmunizations:
            title = @"IMMUNIZATIONS";
            break;

        case TableViewSectionNotes:
            title = @"NOTES";
            break;
    }

    _titleLabel.text = title;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.section == TableViewSectionRecentVitals) {

        if ([self shouldDisplayGraphOfVitals]) {
            return 100.0;
        }

        if ([self shouldDisplayLastVitalsOnly]) {
            [self configureTextCell:self.sizingCell forIndexPath:indexPath];
        }

    } else {
        [self configureTextCell:self.sizingCell forIndexPath:indexPath];
    }

    CGSize size = [self.sizingCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];

    return size.height;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.section == TableViewSectionRecentVitals && [self shouldDisplayGraphOfVitals]) {
            return 200.0;

    } else {
        return UITableViewAutomaticDimension;
    }
}

- (UITableViewCell *)sizingCell {

    if (!_sizingCell) {
        _sizingCell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([LEOPHRTableViewCell class]) owner:nil options:nil] firstObject];
    }

    return _sizingCell;
}


- (void)editNoteTouchedUpInside {

    if (self.editNoteTouchedUpInsideBlock) {
        self.editNoteTouchedUpInsideBlock(self.notes);
    }
}


@end
