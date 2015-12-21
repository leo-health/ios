//
//  LEOAppointmentView.m
//  Leo
//
//  Created by Zachary Drossman on 11/23/15.
//  Copyright © 2015 Leo Health. All rights reserved.
//

#import "LEOAppointmentView.h"
#import "UIView+XibAdditions.h"
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
#import "LEOPromptView.h"
#import "LEOValidatedFloatLabeledTextView.h" //Reason why I need to rebuild LEOPromptView / Field

@interface LEOAppointmentView ()

@property (strong, nonatomic) PrepAppointment *prepAppointment;
@property (strong, nonatomic, readwrite) Appointment *appointment;

@property (weak, nonatomic) IBOutlet LEOPromptView *visitTypePromptView;
@property (weak, nonatomic) IBOutlet LEOPromptView *patientPromptView;
@property (weak, nonatomic) IBOutlet JVFloatLabeledTextView *notesTextView;
@property (weak, nonatomic) IBOutlet LEOPromptView *staffPromptView;
@property (weak, nonatomic) IBOutlet LEOPromptView *schedulePromptView;

@end

@implementation LEOAppointmentView

IB_DESIGNABLE

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
    
    self = [super initWithFrame:frame];
    
    if (self) {
        [self commonInit];
    }
    
    return self;
}

- (instancetype)initWithAppointment:(id)appointment {
    
    self = [super init];
    
    if (self) {

        [self commonInit];
        _appointment = appointment;
    }
    
    return self;
}


- (void)setNotesTextView:(JVFloatLabeledTextView *)notesTextView {
    
    _notesTextView = notesTextView;
    
//    [_notesTextView addObserver:self
//                     forKeyPath:@"contentSize"
//                        options:(NSKeyValueObservingOptionNew)
//                        context:NULL];

    _notesTextView.delegate = self;
    _notesTextView.scrollEnabled = NO;
    _notesTextView.placeholder = @"Questions / comments";
    _notesTextView.floatingLabelFont = [UIFont leoStandardFont];
    _notesTextView.placeholderLabel.font = [UIFont leoStandardFont];
    _notesTextView.font = [UIFont leoStandardFont];
    _notesTextView.floatingLabelActiveTextColor = [UIColor leoGrayStandard];
    _notesTextView.textColor = [UIColor leoGreen];
    _notesTextView.tintColor = [UIColor leoGreen];
}

-(void)setPatientPromptView:(LEOPromptView *)patientPromptView {
    
    _patientPromptView = patientPromptView;
    
    _patientPromptView.textView.editable = NO;
    _patientPromptView.textView.validationPlaceholder = @"";
    _patientPromptView.accessoryImage = [UIImage imageNamed:@"Icon-ForwardArrow"];
    _patientPromptView.accessoryImageViewVisible = YES;
    _patientPromptView.textView.font = [UIFont leoStandardFont];
    _patientPromptView.tintColor = [UIColor leoGreen];
}

- (void)setStaffPromptView:(LEOPromptView *)staffPromptView {

    _staffPromptView = staffPromptView;
    
    _staffPromptView.textView.editable = NO;
    _staffPromptView.textView.validationPlaceholder = @"";
    _staffPromptView.accessoryImage = [UIImage imageNamed:@"Icon-ForwardArrow"];
    _staffPromptView.accessoryImageViewVisible = YES;
    _staffPromptView.textView.font = [UIFont leoStandardFont];
    _staffPromptView.tintColor = [UIColor leoGreen];
}

-(void)setSchedulePromptView:(LEOPromptView *)schedulePromptView {
    
    _schedulePromptView = schedulePromptView;
    
    _schedulePromptView.textView.editable = NO;
    _schedulePromptView.textView.validationPlaceholder = @"";
    _schedulePromptView.accessoryImage =  [UIImage imageNamed:@"Icon-ForwardArrow"];
    _schedulePromptView.accessoryImageViewVisible = YES;
    
    if ([self shouldEnableUserToChooseASlot]) {
        _schedulePromptView.tintColor = [UIColor leoGreen];
    } else {
        _schedulePromptView.tintColor = [UIColor leoGrayForPlaceholdersAndLines];
    }
    
    _schedulePromptView.textView.font = [UIFont leoStandardFont];
}

-(void)setVisitTypePromptView:(LEOPromptView *)visitTypePromptView {
    
    _visitTypePromptView = visitTypePromptView;
    
    _visitTypePromptView.textView.editable = NO;
    _visitTypePromptView.textView.validationPlaceholder = @"";
    _visitTypePromptView.accessoryImage = [UIImage imageNamed:@"Icon-ForwardArrow"];
    _visitTypePromptView.accessoryImageViewVisible = YES;
    _visitTypePromptView.textView.font = [UIFont leoStandardFont];
    _visitTypePromptView.tintColor = [UIColor leoGreen];
}

- (void)setProvider:(Provider *)provider {
    
    _provider = provider;
    self.prepAppointment.provider = provider;

    if (provider) {
        [self updatePromptView:self.staffPromptView withBaseString:@"We will be seen by" variableStrings:@[provider.firstAndLastName]];
        [self determineIfUserShouldBeAbleToScheduleAppointment];
    } else {
        self.staffPromptView.textView.text = @"Who would you like to see?";
    }
    
}

- (void)setPatient:(Patient *)patient {
   
    _patient = patient;
    self.prepAppointment.patient = patient;

    if (patient) {
        
        [self updatePromptView:self.patientPromptView withBaseString:@"This appointment is for" variableStrings:@[patient.firstName]];
        [self determineIfUserShouldBeAbleToScheduleAppointment];
    } else {
        
        [self updatePromptView:self.patientPromptView withBaseString:@"Who is this appointment for?" variableStrings:nil];
    }
    
}

-(void)setAppointmentType:(AppointmentType *)appointmentType {
    
    _appointmentType = appointmentType;
    self.prepAppointment.appointmentType = appointmentType;

    if (appointmentType) {
        
        [self updatePromptView:self.visitTypePromptView withBaseString:@"I'm scheduling a" variableStrings:@[self.appointmentType.name]];
        [self determineIfUserShouldBeAbleToScheduleAppointment];
    } else {
        
        [self updatePromptView:self.visitTypePromptView withBaseString:@"What brings you in today?" variableStrings:nil];
    }

}

-(void)setDate:(NSDate *)date {
    
    _date = date;
    
    self.prepAppointment.date = date;
    
    if (date) {
        
        [self updateSchedulingPromptView:self.schedulePromptView];
    }
}

- (void)setNote:(NSString *)note {
    
    _note = note;
    
    if (note) {
        
        self.notesTextView.text = note;
    } else {
        
        self.notesTextView.text = nil;
    }
}

- (void)commonInit {
    
    [self leo_loadViewFromNibWithConstraints];
    [self setupTouchEventForDismissingKeyboard];
}

#pragma mark - Autolayout



#pragma mark - Drill Button Formatting
//TODO: This method is not ideal, but it is working for the time-being; would like to replace with something that's actually flexible.
- (void)updatePromptView:(LEOPromptView *)promptView withBaseString:(NSString *)baseString variableStrings:(NSArray *)variableStrings {
    
    NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    [style setAlignment:NSTextAlignmentLeft];
    [style setLineBreakMode:NSLineBreakByWordWrapping];
    
    UIFont *baseFont = [UIFont leoStandardFont];
    UIFont *variableFont = [UIFont leoMenuOptionsAndSelectedTextInFormFieldsAndCollapsedNavigationBarsFont];
    
    UIColor *baseColor = [UIColor leoGrayStandard];
    UIColor *variableColor = [UIColor leoGreen];
    
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

- (void)updateSchedulingPromptView:(LEOPromptView *)promptView {
    
    if (self.prepAppointment.date) {
        NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
        [style setAlignment:NSTextAlignmentLeft];
        [style setLineBreakMode:NSLineBreakByWordWrapping];
        
        UIFont *baseFont = [UIFont leoStandardFont];
        UIFont *variableFont = [UIFont leoMenuOptionsAndSelectedTextInFormFieldsAndCollapsedNavigationBarsFont];
        
        UIColor *baseColor = [UIColor leoGrayStandard];
        UIColor *variableColor = [UIColor leoGreen];
        
        NSDictionary *baseDictionary = @{NSForegroundColorAttributeName:baseColor,
                                         NSFontAttributeName:baseFont,
                                         NSParagraphStyleAttributeName:style};
        
        NSDictionary *variableDictionary = @{NSForegroundColorAttributeName:variableColor,
                                             NSFontAttributeName:variableFont,
                                             NSParagraphStyleAttributeName:style};
        
        NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] init];
        
        
        [attrString appendAttributedString:[[NSAttributedString alloc] initWithString:@"My visit is at "
                                                                           attributes:baseDictionary]];
        
        [attrString appendAttributedString:[[NSAttributedString alloc] initWithString:[NSDate stringifiedTime:self.prepAppointment.date]
                                                                           attributes:variableDictionary]];
        
        [attrString appendAttributedString:[[NSAttributedString alloc] initWithString:@" on "
                                                                           attributes:baseDictionary]];
        
        [attrString appendAttributedString:[[NSAttributedString alloc] initWithString:[NSDate stringifiedDateWithCommas:self.prepAppointment.date]
                                                                           attributes:variableDictionary]];
        
        [attrString appendAttributedString:[[NSAttributedString alloc] initWithString:[NSDate dayOfMonthSuffix:self.prepAppointment.date.day]
                                                                           attributes:variableDictionary]];
        
        promptView.textView.attributedText = attrString;
        
    } else {
        
        [self updatePromptView:promptView withBaseString:@"Please complete the fields above\nbefore selecting an appointment date and time." variableStrings:nil];
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
    
    self.date = prepAppointment.date;
    self.patient = prepAppointment.patient;
    self.note = prepAppointment.note;
    self.appointmentType = prepAppointment.appointmentType;
    self.provider = prepAppointment.provider;
    
//    [_prepAppointment addObserver:self forKeyPath:@"appointmentType" options:0 context:nil];
//    [_prepAppointment addObserver:self forKeyPath:@"date" options:0 context:nil];
//    [_prepAppointment addObserver:self forKeyPath:@"provider" options:0 context:nil];
//    [_prepAppointment addObserver:self forKeyPath:@"patient" options:0 context:nil];
}



- (Appointment *)appointment {
    
    if (self.prepAppointment) {
        return [[Appointment alloc] initWithPrepAppointment:self.prepAppointment];
    } else {
        return _appointment;
    }
}

- (void)dealloc {
    //TODO: Remove after debugging complete.
}

#pragma mark - <UITextViewDelegate>
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    /**
     *  Ensures textview length does not exceed character limit imposed.
     *
     *  TODO: Remove magic numbers
     */
    if([text isEqualToString:@" "] && range.location < 600){
        return YES;
    }else if([[textView text] length] - range.length + text.length > 600){
        return NO;
    }
    
    return YES;
}

#pragma mark - Validation

/**
 *  Determine whether the calendar button should be enabled
 */
- (void)determineIfUserShouldBeAbleToScheduleAppointment {
    
    self.schedulePromptView.userInteractionEnabled = NO;
    [self updatePromptView:self.schedulePromptView withBaseString:@"Please complete the above fields before booking." variableStrings:nil];
    
    if ([self shouldEnableUserToChooseASlot]) {
        self.schedulePromptView.userInteractionEnabled = YES;
        [self updatePromptView:self.schedulePromptView withBaseString:@"When would you like to come in?" variableStrings:nil];
    }
}

- (void)enableSchedulingIfNeeded {
    
    [self determineIfUserShouldBeAbleToScheduleAppointment];
    
    
}
/**
 *  Determines whether user should be able to choose a slot
 *
 *  @return BOOL
 */
- (BOOL)shouldEnableUserToChooseASlot {
    
    return self.prepAppointment.appointmentType && self.prepAppointment.patient && self.prepAppointment.provider;
}

/**
 *  Determines whether user should be able to schedule an appointment
 *
 *  @return BOOL
 */
- (BOOL)shouldEnableUserToBookAppointment {


    return self.prepAppointment.appointmentType && self.prepAppointment.patient && self.prepAppointment.provider && self.prepAppointment.date;
}

#pragma mark - KVO

//- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
//
//    /**
//     *
//     *  Source: http://imagineric.ericd.net/2011/03/10/ios-vertical-aligning-text-in-a-uitextview/
//     */
//    if (object == self.notesTextView && [keyPath isEqualToString:@"contentSize"]) {
//        UITextView *tv = object;
//
//        //Bottom vertical alignment
//        CGFloat topCorrect = ([tv bounds].size.height - [tv contentSize].height);
//        topCorrect = (topCorrect <0.0 ? 0.0 : topCorrect);
//        tv.contentOffset = (CGPoint){.x = 0, .y = -topCorrect};
//    }
//}

//-(CGSize)intrinsicContentSize {
//    return CGSizeMake(UIViewNoIntrinsicMetric, self.xibSize.height);
//}

@end
