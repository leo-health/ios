//
//  LEOAppointmentBookingViewController.m
//  LEOCalendar
//
//  Created by Zachary Drossman on 8/3/15.
//  Copyright (c) 2015 Zachary Drossman. All rights reserved.
//

#import "LEOExpandedCardAppointmentViewController.h"
#import "UIScrollView+LEOScrollToVisible.h"
#import "LEOCard.h"
#import <JVFloatLabeledTextField/JVFloatLabeledTextView.h>
#import "UIFont+LeoFonts.h"
#import "UIColor+LeoColors.h"
#import "PrepAppointment.h"
#import "Appointment.h"
#import "AppointmentType.h"
#import "Provider.h"
#import "Patient.h"
#import "NSDate+Extensions.h"
#import "LEOBasicSelectionViewController.h"
#import "LEODataManager.h"
#import "AppointmentTypeCell+ConfigureCell.h"
#import "PatientCell+ConfigureCell.h"
#import "ProviderCell+ConfigureCell.h"
#import "LEOCalendarViewController.h"

#import <OHHTTPStubs/OHHTTPStubs.h> //TODO: Remove once integrated into main project.

#import "LEOAPIAppointmentTypesOperation.h"
#import "LEOAPIStaffOperation.h"
#import "LEOAPIFamilyOperation.h"
#import "LEOAPISlotsOperation.h"

@protocol DataRequestProtocol <NSObject>

- (void)didCompleteDataRequestWithData:(NSArray *)data;

@end

@interface LEOExpandedCardAppointmentViewController ()

@property (weak, nonatomic) IBOutlet UIView *appointmentView;
@property (weak, nonatomic) IBOutlet JVFloatLabeledTextView *notesTextView;
@property (weak, nonatomic) IBOutlet UIButton *questionVisitTypeButton;
@property (weak, nonatomic) IBOutlet UIButton *questionPatientsButton;
@property (weak, nonatomic) IBOutlet UIButton *questionStaffButton;
@property (weak, nonatomic) IBOutlet UIButton *questionCalendarButton;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomLayoutConstraintForNotesViewSectionSeparator;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *notesTextViewHeightConstraint;

@property (strong, nonatomic) Appointment *appointment;
@property (strong, nonatomic) PrepAppointment *prepAppointment;

@property (strong, nonatomic) LEODataManager *dataManager;

@end

@implementation LEOExpandedCardAppointmentViewController

#pragma mark - View Controller Lifecycle
- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.bodyView = self.appointmentView;
    
    [self setupButtons];
    [self setupExpandedCardView];
    [self setupPrepAppointment];
    [self setupNotesTextView];
    [self setupStubs]; //TODO: Remove stub setup here once API has been brought in with reachability checks.
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    [self.scrollView scrollToViewIfObstructedByKeyboard:self.notesTextView];
}

- (void)viewDidDisappear:(BOOL)animated{
    
    [self.scrollView scrollToViewIfObstructedByKeyboard:nil];
}

- (void)dealloc {
    
    [self.notesTextView removeObserver:self forKeyPath:@"contentSize"];
    [self.prepAppointment removeObserver:self forKeyPath:@"appointmentType"];
    [self.prepAppointment removeObserver:self forKeyPath:@"date"];
    [self.prepAppointment removeObserver:self forKeyPath:@"provider"];
    
}

#pragma mark - VCL Helper Methods

//TODO: Remove stub setup here once API has been brought in with reachability checks.
- (void)setupStubs {
    
    __weak id<OHHTTPStubsDescriptor> staffStub = [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
        NSLog(@"Stub request");
        BOOL test = [request.URL.host isEqualToString:APIHost] && [request.URL.path isEqualToString:[NSString stringWithFormat:@"%@/%@/%@",APIVersion, @"0", @"staff"]];
        return test;
    } withStubResponse:^OHHTTPStubsResponse *(NSURLRequest *request) {
        
        NSString *fixture = fixture = OHPathForFile(@"../Stubs/getAllStaff.json", self.class);
        OHHTTPStubsResponse *response = [OHHTTPStubsResponse responseWithFileAtPath:fixture
                                                                         statusCode:200
                                                                            headers:@{@"Content-Type":@"application/json"}];
        return response;
        
    }];
    
    __weak id<OHHTTPStubsDescriptor> familyStub = [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
        NSLog(@"Stub request");
        BOOL test = [request.URL.host isEqualToString:APIHost] && [request.URL.path isEqualToString:[NSString stringWithFormat:@"%@/%@",APIVersion, @"family"]];
        return test;
    } withStubResponse:^OHHTTPStubsResponse *(NSURLRequest *request) {
        
        NSString *fixture = fixture = OHPathForFile(@"../Stubs/getFamilyForUser.json", self.class);
        OHHTTPStubsResponse *response = [OHHTTPStubsResponse responseWithFileAtPath:fixture
                                                                         statusCode:200
                                                                            headers:@{@"Content-Type":@"application/json"}];
        return response;
    }];
    
    __weak id<OHHTTPStubsDescriptor> appointmentTypesStub = [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
        NSLog(@"Stub request");
        BOOL test = [request.URL.host isEqualToString:APIHost] && [request.URL.path isEqualToString:[NSString stringWithFormat:@"%@/%@",APIVersion, @"appointmentTypes"]];
        return test;
    } withStubResponse:^OHHTTPStubsResponse *(NSURLRequest *request) {
        
        NSString *fixture = fixture = OHPathForFile(@"../Stubs/getAppointmentTypes.json", self.class);
        OHHTTPStubsResponse *response = [OHHTTPStubsResponse responseWithFileAtPath:fixture
                                                                         statusCode:200
                                                                            headers:@{@"Content-Type":@"application/json"}];
        return response;
    }];
    
}


- (void)setupPrepAppointment {
    
    self.prepAppointment = [[PrepAppointment alloc] initWithAppointment:self.appointment];
    [self.prepAppointment addObserver:self forKeyPath:@"appointmentType" options:0 context:nil];
    [self.prepAppointment addObserver:self forKeyPath:@"date" options:0 context:nil];
    [self.prepAppointment addObserver:self forKeyPath:@"provider" options:0 context:nil];
    [self.prepAppointment addObserver:self forKeyPath:@"patient" options:0 context:nil];
}

- (void)setupButtons {
    
    [self validateForChoosingSlots];
    
    [self updateButtonTitle:self.questionCalendarButton];
    [self updateButtonTitle:self.questionPatientsButton];
    [self updateButtonTitle:self.questionStaffButton];
    [self updateButtonTitle:self.questionVisitTypeButton];
}


- (void)setupNotesTextView {
    
    self.notesTextView.delegate = self;
    self.notesTextView.scrollEnabled = NO;
    self.notesTextView.placeholder = @"Questions / comments";
    self.notesTextView.floatingLabelFont = [UIFont leoQuestionFont];
    self.notesTextView.placeholderLabel.font = [UIFont leoQuestionFont];
    self.notesTextView.floatingLabelActiveTextColor = [UIColor leoGrayBodyText];
    self.notesTextView.textColor = [UIColor leoGreen];
    self.notesTextView.tintColor = [UIColor leoGreen];
    self.notesTextView.text = self.prepAppointment.note;
    self.notesTextViewHeightConstraint.constant = self.notesTextView.contentSize.height;
    
    UITapGestureRecognizer *tapGestureForTextFieldDismissal = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(scrollViewWasTapped:)];
    tapGestureForTextFieldDismissal.cancelsTouchesInView = NO;
    [self.scrollView addGestureRecognizer:tapGestureForTextFieldDismissal];
    
    [self.notesTextView addObserver:self
                         forKeyPath:@"contentSize"
                            options:(NSKeyValueObservingOptionNew)
                            context:NULL];
}

/**
 *  Sets up the container view.
 */
- (void)setupExpandedCardView {
    
    self.expandedFullTitle = @"Schedule a visit\nwith the practice";
}


#pragma mark - Setters / Getters

/**
 *  Appointment setter that sets the appointment to the card's associated card object as opposed to a backing store.
 *
 *  @param appointment
 */
- (void)setAppointment:(Appointment *)appointment {
    self.card.associatedCardObject = appointment;
}


/**
 *  Appointment getter that uses the card's associated object instead of an ivar as its backing store
 *
 *  @return the associated card object (which is an appointment in this case
 */
-(Appointment *)appointment {
    return self.card.associatedCardObject;
}



#pragma mark - <TextViewDelegate>

-(void)textViewDidChange:(UITextView *)textView {
    
    [UIView animateWithDuration:0.1 animations:^{
        self.notesTextViewHeightConstraint.constant = self.notesTextView.contentSize.height;
        [self.view layoutIfNeeded];
    }];
}

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




#pragma mark - <SingleSelectionProtocol>
/**
 *  Generic delegate method for returning data from a selection view controller
 *
 *  @param item contains the item in memory that was chosen
 *  @param key  describes the prepAppointment property that should be updated by the item
 */
- (void)didUpdateItem:(nullable id)item forKey:(NSString *)key {
    
    [self.prepAppointment setValue:item forKey:key];
}


#pragma mark - Validation

/**
 *  Determine whether the calendar button should be enabled
 */
- (void)validateForChoosingSlots {
    
    self.questionCalendarButton.enabled = [self shouldEnableUserToChooseASlot] ? YES : NO;
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



#pragma mark - Actions

/**
 *  When the button is tapped at the bottom of the expanded appointment flow, the card's appointment object is updated with the prepAppointment and the card's method for the first action
 *  when in the the current state is called.
 */
- (void)buttonTapped {
    
    self.card.associatedCardObject = [[Appointment alloc] initWithPrepAppointment:self.prepAppointment]; //FIXME: Make this a loop to account for changes to multiple objects, e.g. appointments on a card.
    
    //[self.card performSelector:NSSelectorFromString([self.card actionsAvailableForState][0])]; //FIXME: Alternative way to do this that won't cause warning.
    
    if (!self.card) { return; }
    SEL selector = NSSelectorFromString([self.card actionsAvailableForState][0]);
    IMP imp = [self.card methodForSelector:selector];
    void (*func)(id, SEL) = (void *)imp;
    func(self.card, selector);
}

-(void)scrollViewWasTapped:(UIGestureRecognizer*)gesture{
    if (self.notesTextView.isFirstResponder) {
        [self.notesTextView resignFirstResponder];
    }
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    LEOCalendarViewController *calendarVC = segue.destinationViewController;
    
    __block BOOL shouldSelect = NO;
    
    if ([segue.identifier isEqualToString:@"CalendarSegue"]) {
        
        calendarVC.delegate = self;
        calendarVC.prepAppointment = [self prepAppointment];
        calendarVC.requestOperation = [[LEOAPISlotsOperation alloc] init];
        
        return;
    }
    
    LEOBasicSelectionViewController *selectionVC = segue.destinationViewController;
    
    if ([segue.identifier isEqualToString:@"AppointmentTypeSegue"]) {
        
        selectionVC.key = @"appointmentType";
        selectionVC.reuseIdentifier = @"AppointmentTypeCell";
        selectionVC.titleText = @"What type of visit is this?";
        
        selectionVC.configureCellBlock = ^(AppointmentTypeCell *cell, AppointmentType *appointmentType) {
            cell.selectedColor = self.card.tintColor;
            
            [cell configureForAppointmentType:appointmentType];
            
            shouldSelect = NO;
            
            if ([appointmentType.objectID isEqualToString:self.prepAppointment.appointmentType.objectID]) {
                shouldSelect = YES;
            }
            
            return shouldSelect;
        };
        
        selectionVC.requestOperation = [[LEOAPIAppointmentTypesOperation alloc] init];
        selectionVC.delegate = self;
        
//        [UIView animateWithDuration:0.25
//                         animations:^{
//                             [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
//                             [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.navigationController.view cache:NO];
//                         }];
        
    } else
        if ([segue.identifier isEqualToString:@"PatientSegue"]) {
            
            selectionVC.key = @"patient";
            selectionVC.reuseIdentifier = @"PatientCell";
            selectionVC.titleText = @"Who is the visit for?";
            
            selectionVC.configureCellBlock = ^(PatientCell *cell, Patient *patient) {
                
                cell.selectedColor = self.card.tintColor;
                
                shouldSelect = NO;
                
                [cell configureForPatient:patient];
                
                if ([patient.objectID isEqualToString:self.prepAppointment.patient.objectID]) {
                    shouldSelect = YES;
                }
                
                return shouldSelect;
            };
            
            selectionVC.requestOperation = [[LEOAPIFamilyOperation alloc] init];
            selectionVC.delegate = self;
        } else
            if ([segue.identifier isEqualToString:@"ProviderSegue"]) {
                
                selectionVC.key = @"provider";
                selectionVC.reuseIdentifier = @"ProviderCell";
                selectionVC.titleText = @"Who would you like to see?";
                selectionVC.tintColor = self.card.tintColor;
                selectionVC.configureCellBlock = ^(ProviderCell *cell, Provider *provider) {
                    
                    cell.selectedColor = self.card.tintColor;
                    
                    shouldSelect = NO;
                    
                    if ([provider.objectID isEqualToString:self.prepAppointment.provider.objectID]) {
                        shouldSelect = YES;
                    }
                    
                    [cell configureForProvider:provider];
                    
                    return shouldSelect;
                };
                
                selectionVC.requestOperation = [[LEOAPIStaffOperation alloc] init];
                selectionVC.delegate = self;
            }
    
}

- (PrepAppointment *)prepAppointment {
    
    if (!_prepAppointment) {
        
        if (self.appointment) {
            _prepAppointment = [[PrepAppointment alloc] initWithAppointment:self.appointment];
        }
    }
    
    return _prepAppointment;
}


#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    /**
     *
     *  Source: http://imagineric.ericd.net/2011/03/10/ios-vertical-aligning-text-in-a-uitextview/
     */
    if (object == self.notesTextView && [keyPath isEqualToString:@"contentSize"]) {
        UITextView *tv = object;
        
        //Bottom vertical alignment
        CGFloat topCorrect = ([tv bounds].size.height - [tv contentSize].height);
        topCorrect = (topCorrect <0.0 ? 0.0 : topCorrect);
        tv.contentOffset = (CGPoint){.x = 0, .y = -topCorrect};
    }
    
    
    /**
     *  Listen for changes to the prepAppointment and then check if we should enable slot choice functionality and booking functionality
     */
    if (object == self.prepAppointment) {
        
        if ([keyPath isEqualToString:@"appointmentType"]) {
            
            self.button.enabled = [self shouldEnableUserToBookAppointment];
            [self updateButtonTitle:self.questionVisitTypeButton];
            
        } else if ([keyPath isEqualToString:@"provider"]) {
            
            self.button.enabled = [self shouldEnableUserToBookAppointment];
            [self updateButtonTitle:self.questionStaffButton];
            
        } else if ([keyPath isEqualToString:@"patient"]) {
            
            self.button.enabled = [self shouldEnableUserToBookAppointment];
            [self updateButtonTitle:self.questionPatientsButton];
            
        } else if ([keyPath isEqualToString:@"date"]) {

            [self validateForChoosingSlots];
            self.button.enabled = [self shouldEnableUserToBookAppointment];
            [self updateButtonTitle:self.questionCalendarButton];
        }
    }
}


#pragma mark - Drill Button Formatting
//TODO: This method is not ideal, but it is working for the time-being; would like to replace with something that's actually flexible.
- (void)updateButton:(UIButton *)button withBaseString:(NSString *)baseString variableStrings:(NSArray *)variableStrings {
    
    NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    [style setAlignment:NSTextAlignmentLeft];
    [style setLineBreakMode:NSLineBreakByWordWrapping];
    
    UIFont *baseFont = [UIFont leoQuestionFont];
    UIFont *variableFont = [UIFont leoQuestionFont];
    
    UIColor *baseColor = [UIColor leoBlack];
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
    
    [button setAttributedTitle:attrString forState:UIControlStateNormal];
}


- (void)updateButtonTitle:(UIButton *)button {
    
    if (button == self.questionVisitTypeButton) {
        
        if (self.prepAppointment.appointmentType) {
            [self updateButton:button withBaseString:@"I'm scheduling a" variableStrings:@[self.prepAppointment.appointmentType.name]];
        } else {
            [self updateButton:button withBaseString:@"What brings you in today?" variableStrings:nil];
        }
        
    } else if (button == self.questionPatientsButton) {
        
        if (self.prepAppointment.patient) {
            [self updateButton:self.questionPatientsButton withBaseString:@"This appointment is for" variableStrings:@[self.prepAppointment.patient.firstName]];
        } else {
            [self updateButton:button withBaseString:@"Who is this appointment for?" variableStrings:nil];
        }
        
    } else if (button == self.questionStaffButton) {
        
        if (self.prepAppointment.provider) {
            [self updateButton:button withBaseString:@"I would like to be seen by\n" variableStrings:@[[NSString stringWithFormat:@"%@ %@",self.prepAppointment.provider.fullName, self.prepAppointment.provider.credentials[0]]]];
        } else {
            [self updateButton:button withBaseString:@"Who would you like to see?" variableStrings:nil];
        }
        
    } else if (button == self.questionCalendarButton) {
        
        if (self.prepAppointment.date && self.questionCalendarButton.enabled) {
            [self updateButton:button withBaseString:@"My visit is at\n" variableStrings:@[[NSDate stringifiedDateTime:self.prepAppointment.date]]];
        } else if (!self.prepAppointment.date && self.questionCalendarButton.enabled) {
            [self updateButton:button withBaseString:@"When would you like to come in?" variableStrings:nil];
        } else if (!self.prepAppointment.date && !self.questionCalendarButton.enabled) {
            [self updateButton:button withBaseString:@"Please select a provider, visit type, and child before selecting an appointment date and time." variableStrings:nil];
        }
    }
    
    
    [button setImage:[UIImage imageNamed:@"Icon-ForwardArrow"] forState:UIControlStateNormal];
    
    [self.view layoutIfNeeded];
    
    CGSize size = button.frame.size;
    CGSize imageSize = button.imageView.image.size;
    
    [button setImageEdgeInsets:UIEdgeInsetsMake(0, size.width - imageSize.width, 0, 0)];
    [button setTitleEdgeInsets:UIEdgeInsetsMake(0, -imageSize.width, 0, 0)];
    button.tintColor = [UIColor leoGreen];
}




@end
