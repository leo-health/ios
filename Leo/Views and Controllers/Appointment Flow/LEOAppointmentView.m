//
//  LEOAppointmentView.m
//  Leo
//
//  Created by Zachary Drossman on 11/23/15.
//  Copyright © 2015 Leo Health. All rights reserved.
//

#import "LEOAppointmentView.h"
#import "UIView+Extensions.h"
#import "JVFloatLabeledTextView.h"
#import "UIFont+LeoFonts.h"
#import "UIColor+LeoColors.h"
#import "PrepAppointment.h"
#import "LEOPromptView.h"
#import "NSDate+Extensions.h"
#import "Patient.h"
#import "AppointmentType.h"
#import "Provider.h"
#import "Practice.h"
#import "Appointment.h"
#import "PrepAppointment.h"
#import "LEOPromptView.h"
#import "LEOValidatedFloatLabeledTextView.h" //Reason why I need to rebuild LEOPromptView / Field
#import "LEOValidationsHelper.h"
#import "LEOInputAccessoryView.h"
#import "NSObject+XibAdditions.h"
#import "NSString+Extensions.h"

@interface LEOAppointmentView ()

@property (strong, nonatomic) PrepAppointment *prepAppointment;

@property (weak, nonatomic) IBOutlet LEOPromptView *visitTypePromptView;
@property (weak, nonatomic) IBOutlet LEOPromptView *patientPromptView;
@property (weak, nonatomic) IBOutlet JVFloatLabeledTextView *notesTextView;
@property (weak, nonatomic) IBOutlet LEOPromptView *staffPromptView;
@property (weak, nonatomic) IBOutlet LEOPromptView *schedulePromptView;

@end

@implementation LEOAppointmentView

IB_DESIGNABLE

static NSString * const kQuestionVisitType = @"What brings you in?";
static NSString * const kQuestionPatient = @"Who is this visit for?";
static NSString * const kQuestionReasonForVisit = @"What would you like to cover?";
static NSString * const kQuestionDateTimeOfVisit = @"When would you like to be seen?";
static NSString * const kQuestionProvider = @"Who would you like to see?";
static NSString * const kValidationDateTimeOfVisit = @"Please complete the fields above to select a date and time";

@synthesize prepAppointment = _prepAppointment;
@synthesize appointment = _appointment;

#pragma mark - Initialization
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];

    if (self) {
        [self commonInit];
    }

    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {

    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"You must initialize %@ with initWithNibName:.", NSStringFromSelector(_cmd)]
                                 userInfo:nil];
}

- (void)commonInit {

    [self setupTouchEventForDismissingKeyboard];
    [self enableSchedulingIfNeeded];
}

#pragma mark - Accessors

- (void)setNotesTextView:(JVFloatLabeledTextView *)notesTextView {

    _notesTextView = notesTextView;
    _notesTextView.text = self.note;
    _notesTextView.delegate = self;
    _notesTextView.scrollEnabled = NO;
    _notesTextView.placeholder = kQuestionReasonForVisit;
    _notesTextView.floatingLabelFont = [UIFont leo_standardFont];
    _notesTextView.placeholderLabel.font = [UIFont leo_standardFont];
    _notesTextView.font = [UIFont leo_standardFont];
    _notesTextView.floatingLabelActiveTextColor = [UIColor leo_grayForPlaceholdersAndLines]; //TODO: Check *again* this color is right.
    _notesTextView.textColor = [UIColor leo_green];
    _notesTextView.tintColor = [UIColor leo_green];

    LEOInputAccessoryView *accessoryView = [self leo_loadViewFromNibForClass:[LEOInputAccessoryView class]];
    accessoryView.feature = FeatureAppointmentScheduling;
    [accessoryView.doneButton addTarget:self action:@selector(endEditing:) forControlEvents:UIControlEventTouchUpInside];
    _notesTextView.inputAccessoryView = accessoryView;
}

-(void)setPatientPromptView:(LEOPromptView *)patientPromptView {

    _patientPromptView = patientPromptView;

    _patientPromptView.textView.editable = NO;
    _patientPromptView.textView.scrollEnabled = NO;
    _patientPromptView.textView.selectable = NO;
    _patientPromptView.textView.validationPlaceholder = @"";
    _patientPromptView.accessoryImage = [UIImage imageNamed:@"Icon-ForwardArrow"];
    _patientPromptView.accessoryImageViewVisible = YES;
    _patientPromptView.textView.font = [UIFont leo_standardFont];
    _patientPromptView.tintColor = [UIColor leo_green];
}

- (void)setStaffPromptView:(LEOPromptView *)staffPromptView {

    _staffPromptView = staffPromptView;

    _staffPromptView.textView.editable = NO;
    _staffPromptView.textView.scrollEnabled = NO;
    _staffPromptView.textView.selectable = NO;
    _staffPromptView.textView.validationPlaceholder = @"";
    _staffPromptView.accessoryImage = [UIImage imageNamed:@"Icon-ForwardArrow"];
    _staffPromptView.accessoryImageViewVisible = YES;
    _staffPromptView.textView.font = [UIFont leo_standardFont];
    _staffPromptView.tintColor = [UIColor leo_green];
}

-(void)setSchedulePromptView:(LEOPromptView *)schedulePromptView {

    _schedulePromptView = schedulePromptView;

    _schedulePromptView.textView.editable = NO;
    _schedulePromptView.textView.scrollEnabled = NO;
    _schedulePromptView.textView.selectable = NO;
    _schedulePromptView.textView.validationPlaceholder = @"";
    _schedulePromptView.accessoryImage =  [UIImage imageNamed:@"Icon-ForwardArrow"];
    _schedulePromptView.accessoryImageViewVisible = YES;
    _schedulePromptView.textView.font = [UIFont leo_standardFont];
}

-(void)setVisitTypePromptView:(LEOPromptView *)visitTypePromptView {

    _visitTypePromptView = visitTypePromptView;

    _visitTypePromptView.textView.editable = NO;
    _visitTypePromptView.textView.scrollEnabled = NO;
    _visitTypePromptView.textView.validationPlaceholder = @"";
    _visitTypePromptView.accessoryImage = [UIImage imageNamed:@"Icon-ForwardArrow"];
    _visitTypePromptView.accessoryImageViewVisible = YES;
    _visitTypePromptView.textView.font = [UIFont leo_standardFont];
    _visitTypePromptView.tintColor = [UIColor leo_green];
}

-(void)setTintColor:(UIColor *)tintColor {
    _visitTypePromptView.tintColor = tintColor;
}

- (void)setProvider:(Provider *)provider {

    _provider = provider;
    self.prepAppointment.provider = provider;

    if (provider) {
        [self updatePromptView:self.staffPromptView withBaseString:@"We will be seen by" variableStrings:@[provider.firstAndLastName]];
        [self enableSchedulingIfNeeded];
    } else {
        self.staffPromptView.textView.text = kQuestionProvider;
    }
}

- (void)setPatient:(Patient *)patient {

    _patient = patient;
    self.prepAppointment.patient = patient;

    if (patient) {

        [self updatePromptView:self.patientPromptView withBaseString:@"This appointment is for" variableStrings:@[patient.firstName]];
        [self enableSchedulingIfNeeded];
    } else {

        [self updatePromptView:self.patientPromptView withBaseString:kQuestionPatient variableStrings:nil];
    }
}

-(void)setAppointmentType:(AppointmentType *)appointmentType {

    _appointmentType = appointmentType;
    self.prepAppointment.appointmentType = appointmentType;

    if (appointmentType) {

        [self updatePromptView:self.visitTypePromptView withBaseString:@"I'm scheduling a" variableStrings:@[self.appointmentType.name]];
        [self enableSchedulingIfNeeded];
    } else {

        [self updatePromptView:self.visitTypePromptView withBaseString:kQuestionVisitType variableStrings:nil];
    }
}

-(void)setDate:(NSDate *)date {

    _date = date;

    self.prepAppointment.date = date;

    [self enableSchedulingIfNeeded];
}

- (void)setNote:(NSString *)note {

    _note = note;
    self.prepAppointment.note = note;
    self.notesTextView.text = note;
}

#pragma mark - Drill Button Formatting
//TODO: This method is not ideal, but it is working for the time-being; would like to replace with something that's actually flexible.
- (void)updatePromptView:(LEOPromptView *)promptView withBaseString:(NSString *)baseString variableStrings:(NSArray *)variableStrings {

    NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    [style setAlignment:NSTextAlignmentLeft];
    [style setLineBreakMode:NSLineBreakByWordWrapping];

    UIFont *baseFont = [UIFont leo_standardFont];
    UIFont *variableFont = [UIFont leo_menuOptionsAndSelectedTextInFormFieldsAndCollapsedNavigationBarsFont];

    UIColor *baseColor = [UIColor leo_grayStandard];
    UIColor *variableColor = [UIColor leo_green];

    NSDictionary *baseDictionary = @{NSForegroundColorAttributeName:baseColor,
                                     NSFontAttributeName:baseFont,
                                     NSParagraphStyleAttributeName:style};

    NSDictionary *variableDictionary = @{NSForegroundColorAttributeName:variableColor,
                                         NSFontAttributeName:variableFont,
                                         NSParagraphStyleAttributeName:style};

    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] init];


    [attrString appendAttributedString:[[NSAttributedString alloc] initWithString:baseString
                                                                       attributes:baseDictionary]];

    for (NSString *varString in variableStrings) {

        [attrString appendAttributedString:[[NSAttributedString alloc] initWithString:@" "
                                                                           attributes:baseDictionary]];

        [attrString appendAttributedString:[[NSAttributedString alloc] initWithString:varString
                                                                           attributes:variableDictionary]];

    }

    promptView.textView.attributedText = attrString;
}

- (void)enableSchedulingIfNeeded {

    LEOPromptView *promptView = self.schedulePromptView;

    if (self.prepAppointment.isValidForBooking) {

        NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
        [style setAlignment:NSTextAlignmentLeft];
        [style setLineBreakMode:NSLineBreakByWordWrapping];

        UIFont *baseFont = [UIFont leo_standardFont];
        UIFont *variableFont = [UIFont leo_menuOptionsAndSelectedTextInFormFieldsAndCollapsedNavigationBarsFont];

        UIColor *baseColor = [UIColor leo_grayStandard];
        UIColor *variableColor = [UIColor leo_green];

        NSDictionary *baseDictionary = @{NSForegroundColorAttributeName:baseColor,
                                         NSFontAttributeName:baseFont,
                                         NSParagraphStyleAttributeName:style};

        NSDictionary *variableDictionary = @{NSForegroundColorAttributeName:variableColor,
                                             NSFontAttributeName:variableFont,
                                             NSParagraphStyleAttributeName:style};

        NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] init];


        [attrString appendAttributedString:[[NSAttributedString alloc] initWithString:@"My visit is at "
                                                                           attributes:baseDictionary]];

        [attrString appendAttributedString:[[NSAttributedString alloc] initWithString:[NSDate leo_stringifiedTimeWithEasternTimeZoneWithPeriod:self.prepAppointment.date]
                                                                           attributes:variableDictionary]];

        [attrString appendAttributedString:[[NSAttributedString alloc] initWithString:@" on "
                                                                           attributes:baseDictionary]];

        [attrString appendAttributedString:[[NSAttributedString alloc] initWithString:[NSDate leo_stringifiedDateWithCommas:self.prepAppointment.date]
                                                                           attributes:variableDictionary]];

        [attrString appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString leo_numericSuffix:self.prepAppointment.date.day]
                                                                           attributes:variableDictionary]];

        promptView.textView.attributedText = attrString;
        promptView.tintColor = [UIColor leo_green];

    } else if (self.prepAppointment.isValidForScheduling) {

        self.schedulePromptView.userInteractionEnabled = YES;
        self.schedulePromptView.tintColor = [UIColor leo_green];
        [self updatePromptView:self.schedulePromptView withBaseString:kQuestionDateTimeOfVisit variableStrings:nil];

    } else {

        [self updatePromptView:promptView withBaseString:kValidationDateTimeOfVisit variableStrings:nil];
        promptView.tintColor = [UIColor leo_grayForPlaceholdersAndLines];
        promptView.userInteractionEnabled = NO;
    }
}

- (void)setAppointment:(Appointment *)appointment {

    _appointment = appointment;

    if (!self.prepAppointment) {

        self.prepAppointment = [[PrepAppointment alloc] initWithAppointment:appointment];
    }
}

-(void)setDelegate:(id)delegate {

    _delegate = delegate;

    self.schedulePromptView.delegate = self;
    self.visitTypePromptView.delegate = self;
    self.patientPromptView.delegate = self;
    self.staffPromptView.delegate = self;
}

-(void)respondToPrompt:(id)sender {

    if (sender == self.visitTypePromptView) {
        [self.delegate leo_performSegueWithIdentifier:@"VisitTypeSegue"];
    }

    if (sender == self.patientPromptView) {
        [self.delegate leo_performSegueWithIdentifier:@"PatientSegue"];
    }

    if (sender == self.staffPromptView) {
        [self.delegate leo_performSegueWithIdentifier:@"StaffSegue"];
    }

    if (sender == self.schedulePromptView) {
        [self.delegate leo_performSegueWithIdentifier:@"ScheduleSegue"];
    }
}

//TODO: Check this isn't resulting in an infinite loop with setters of date, patient, apptType, etc.
-(void)setPrepAppointment:(PrepAppointment *)prepAppointment {

    _prepAppointment = prepAppointment;

    _date = prepAppointment.date;

    self.patient = prepAppointment.patient;
    self.provider = prepAppointment.provider;
    self.appointmentType = prepAppointment.appointmentType;
    self.note = prepAppointment.note;

    // FIXME: there is probably a better way to trigger side effects here to avoid this weird necessary ordering
    // self.date must be set last here because self setProvider will reset prepAppointment.provider, which will in turn set prepAppointment.date to nil

    self.date = _date;
}

- (Appointment *)appointment {

    if (_prepAppointment) {
        return [[Appointment alloc] initWithPrepAppointment:_prepAppointment];
    } else {
        return _appointment;
    }
}

#pragma mark - <UITextViewDelegate>
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{

    return [LEOValidationsHelper fieldText:textView.text
            shouldChangeTextInRange:range
                    replacementText:text
           toValidateCharacterLimit:kCharacterLimitAppointmentNotes];
}

- (void)textViewDidChange:(UITextView *)textView {

    self.note = textView.text;
}


#pragma mark - Autolayout

- (void)setupTouchEventForDismissingKeyboard {

    UITapGestureRecognizer *tapGestureForTextFieldDismissal = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(viewTapped)];

    tapGestureForTextFieldDismissal.cancelsTouchesInView = NO;
    [self addGestureRecognizer:tapGestureForTextFieldDismissal];
}


@end
