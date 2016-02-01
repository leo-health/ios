//
//  LEOEHRViewController.m
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

// views
#import "LEOPHRTableViewCell.h"
#import "LEOIntrinsicSizeTableView.h"

// controllers
#import "LEORecordEditNotesViewController.h"

// model
#import "LEOHealthRecordService.h"
#import "HealthRecord.h"

@interface LEORecordViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic) BOOL alreadyUpdatedConstraints;
@property (weak, nonatomic) UITableView *tableView;
@property (copy, nonatomic) NSString *cellReuseIdentifier;
@property (copy, nonatomic) NSString *headerReuseIdentifier;
@property (strong, nonatomic) UITableViewCell *sizingCell;
@property (strong, nonatomic) UITableViewHeaderFooterView *sizingHeader;

@property (strong, nonatomic) HealthRecord *healthRecord;

@end

@implementation LEORecordViewController

NS_ENUM(NSInteger, PHRTableViewSection) {
    PHRTableViewSectionRecentVitals,
    PHRTableViewSectionAllergies,
    PHRTableViewSectionMedications,
    PHRTableViewSectionImmunizations,
    PHRTableViewSectionNotes,
    PHRTableViewSectionCount
};

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self requestHealthRecord];
}

#pragma mark - Accessors and Setup

- (UITableView *)tableView {

    if (!_tableView) {

        UITableView *strongView = [LEOIntrinsicSizeTableView new];
        [self.view addSubview:strongView];
        _tableView = strongView;

        _tableView.dataSource = self;
        _tableView.delegate = self;

        _tableView.backgroundColor = [UIColor leo_white];
        _tableView.scrollEnabled = NO;
        _tableView.separatorInset = UIEdgeInsetsMake(0, 20, 0, 20);

        _tableView.tableFooterView = [UIView new];
        _tableView.separatorColor = [UIColor leo_grayForPlaceholdersAndLines];

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

    LEOHealthRecordService *service = [LEOHealthRecordService new];

    [service getHealthRecordForPatient:self.patient withCompletion:^(HealthRecord *healthRecord, NSError *error) {

        if (error) {

            NSLog(@"ERROR: phr request - %@", error);
        }

        if (useMock) {

            healthRecord = [HealthRecord mockObject];
        }
        self.healthRecord = healthRecord;
        [self reloadData];
    }];
    
}

- (void)reloadData {

    [self.tableView reloadData];
    [self.tableView invalidateIntrinsicContentSize];
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

#pragma mark - Table View Data Source

#pragma mark - Sections
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return PHRTableViewSectionCount;
}

- (UITableViewHeaderFooterView *)sizingHeader {

    if (!_sizingHeader) {
        _sizingHeader = [UITableViewHeaderFooterView new];
    }
    return _sizingHeader;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {

    // only show header if the section has rows
    if ([self tableView:tableView numberOfRowsInSection:section] == 0) {
        return 1;
    }

    [self configureSectionHeader:self.sizingHeader forSection:section];
    CGSize size = [self.sizingHeader systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    return size.height;
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

    [sectionHeaderView setNeedsLayout];
    [sectionHeaderView layoutIfNeeded];

    return sectionHeaderView;
}

- (void)configureSectionHeader:(UITableViewHeaderFooterView *)sectionHeaderView forSection:(NSInteger)section {

    UILabel *_titleLabel = [UILabel new];
    _titleLabel.font = [UIFont leo_fieldAndUserLabelsAndSecondaryButtonsFont]; // bold 12
    _titleLabel.textColor = [UIColor leo_grayStandard];

    UIView *_separatorLine = [UIView new];
    [_separatorLine setBackgroundColor:[UIColor leo_grayStandard]];

    UIButton *_editNoteButton = [UIButton new];
    _editNoteButton.titleLabel.font = [UIFont leo_buttonLabelsAndTimeStampsFont];
    [_editNoteButton setTitleColor:[UIColor leo_orangeRed] forState:UIControlStateNormal];

    [_editNoteButton addTarget:self action:@selector(editNoteTouchedUpInside) forControlEvents:UIControlEventTouchUpInside];

    sectionHeaderView.contentView.backgroundColor = [UIColor clearColor];

    [sectionHeaderView.contentView addSubview:_titleLabel];
    [sectionHeaderView.contentView addSubview:_separatorLine];
    [sectionHeaderView.contentView addSubview:_editNoteButton];

    sectionHeaderView.backgroundView = [UIView new];

    sectionHeaderView.contentView.translatesAutoresizingMaskIntoConstraints = NO;
    _titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _separatorLine.translatesAutoresizingMaskIntoConstraints = NO;
    _editNoteButton.translatesAutoresizingMaskIntoConstraints = NO;

    NSNumber *spacing = @4;
    NSNumber *horizontalMargin = @28;
    NSNumber *topMargin = @25;
    NSNumber *bottomMargin = @13;
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
    NSString *editNoteButtonText;
    switch (section) {

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
            editNoteButtonText = self.healthRecord.notes.count ? @"EDIT" : @"ADD";
            break;
    }

    _titleLabel.text = title;
    [_editNoteButton setTitle:editNoteButtonText forState:UIControlStateNormal];
}

#pragma mark - Cells

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    NSInteger rows = 0;
    switch (section) {

        case PHRTableViewSectionRecentVitals:
            rows += self.healthRecord.bmis.count > 0;
            rows += self.healthRecord.heights.count > 0;
            rows += self.healthRecord.weights.count > 0;
            break;

        case PHRTableViewSectionAllergies:
            rows = self.healthRecord.allergies.count;
            break;

        case PHRTableViewSectionMedications:
            rows = self.healthRecord.medications.count;
            break;

        case PHRTableViewSectionImmunizations:
            rows = self.healthRecord.immunizations.count;
            break;

        case PHRTableViewSectionNotes:
            rows = self.healthRecord.notes.count ? : 1;
            break;
    };
    return rows;
}

- (UITableViewCell *)sizingCell {

    if (!_sizingCell) {
        _sizingCell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([LEOPHRTableViewCell class]) owner:nil options:nil] firstObject];
    }
    return _sizingCell;
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
    return size.height + 1; // separator line
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

     UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:self.cellReuseIdentifier forIndexPath:indexPath];

     [self configureCell:cell forIndexPath:indexPath];
     return cell;
}

- (void)configureCell:(UITableViewCell *)cell forIndexPath:(NSIndexPath*)indexPath {

    LEOPHRTableViewCell *_cell = (LEOPHRTableViewCell *)cell;

    switch (indexPath.section) {

        case PHRTableViewSectionRecentVitals:
            [_cell configureCellWithBMI:self.healthRecord.bmis[0]];
            break;

        case PHRTableViewSectionAllergies:
            [_cell configureCellWithAllergy:self.healthRecord.allergies[indexPath.row]];
            break;

        case PHRTableViewSectionMedications:
            [_cell configureCellWithMedication:self.healthRecord.medications[indexPath.row]];
            break;

        case PHRTableViewSectionImmunizations:
            [_cell configureCellWithImmunization:self.healthRecord.immunizations[indexPath.row]];
            break;

        case PHRTableViewSectionNotes: {
            PatientNote *note;
            if (indexPath.row < self.healthRecord.notes.count) {
                note = self.healthRecord.notes[indexPath.row];
            }
            [_cell configureCellWithNote:note];
            break;
        }
    }
}

- (void)editNoteTouchedUpInside {

    PatientNote* note;
    if (self.healthRecord.notes.count > 0) {
        note = [self.healthRecord.notes lastObject]; // TODO: update to handle multiple notes
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

    NSArray *notesCopy = [self.healthRecord.notes copy];
    int i = 0;
    for (PatientNote *note in notesCopy) {
        if ([note.objectID isEqualToString:updatedNote.objectID] || (!note.objectID && !updatedNote.objectID) ) {
            self.healthRecord.notes[i] = updatedNote;
            return;
        }
        i++;
    }
    // if not found, this is a newly created note.
    [self.healthRecord.notes addObject:updatedNote];
}


@end
