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
#import <RPFloatingPlaceholders/RPFloatingPlaceholderTextView.h>
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
@property (weak, nonatomic) IBOutlet RPFloatingPlaceholderTextView *notesTextView;
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

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self setupNotesTextView];
    [self setupExpandedCardView];
    [self formatInitialQuestions];
    [self setupStubs];
    
    UITapGestureRecognizer *tapGestureForTextFieldDismissal = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(scrollViewWasTapped:)];
    tapGestureForTextFieldDismissal.cancelsTouchesInView = NO;
    [self.scrollView addGestureRecognizer:tapGestureForTextFieldDismissal];
}


//TODO: Remove stub setup here once integrated back into main project.
- (void)setupStubs {
    
    __weak id<OHHTTPStubsDescriptor> cardsStub = [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
        NSLog(@"Stub request");
        BOOL test = [request.URL.host isEqualToString:APIHost] && [request.URL.path isEqualToString:[NSString stringWithFormat:@"%@/%@",APIVersion, @"cards"]];
        return test;
    } withStubResponse:^OHHTTPStubsResponse *(NSURLRequest *request) {
        
        NSString *fixture = fixture = OHPathForFile(@"../Stubs/getCardsForUser.json", self.class);
        OHHTTPStubsResponse *response = [OHHTTPStubsResponse responseWithFileAtPath:fixture statusCode:200 headers:@{@"Content-Type":@"application/json"}];
        return response;
        
    }];
    
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


- (void)formatInitialQuestions {
    
    self.questionCalendarButton.titleLabel.font = [UIFont leoQuestionFont];
    [self.questionCalendarButton setTitleColor:[UIColor leoBlack]
                                      forState:UIControlStateNormal];
    
    self.questionPatientsButton.titleLabel.font = [UIFont leoQuestionFont];
    [self.questionPatientsButton setTitleColor:[UIColor leoBlack]
                                      forState:UIControlStateNormal];
    
    self.questionStaffButton.titleLabel.font = [UIFont leoQuestionFont];
    [self.questionStaffButton setTitleColor:[UIColor leoBlack]
                                   forState:UIControlStateNormal];
    
    self.questionVisitTypeButton.titleLabel.font = [UIFont leoQuestionFont];
    [self.questionVisitTypeButton setTitleColor:[UIColor leoBlack]
                                       forState:UIControlStateNormal];
}


- (void)setupNotesTextView {
    
    self.bodyView = self.appointmentView;
    self.notesTextView.delegate = self;
    self.notesTextView.scrollEnabled = NO;
    self.notesTextView.placeholder = @"Add your questions or comments here";
    self.notesTextView.floatingLabelActiveTextColor = [UIColor leoGrayBodyText];
    self.notesTextView.floatingLabelInactiveTextColor = [UIColor leoGrayBodyText];
    self.notesTextView.font = [UIFont leoBodyBasicFont];
    self.notesTextView.textColor = [UIColor leoGreen];
    
    self.notesTextViewHeightConstraint.constant = self.notesTextView.contentSize.height;
    [self.view setNeedsUpdateConstraints];
    
    [self.notesTextView addObserver:self
                         forKeyPath:@"contentSize"
                            options:(NSKeyValueObservingOptionNew)
                            context:NULL];
}


- (void)updateButton:(UIButton *)button withSentenceString:(NSString *)sentenceString variableString:(NSString *)variableString {
    
    NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    [style setAlignment:NSTextAlignmentLeft];
    [style setLineBreakMode:NSLineBreakByWordWrapping];
    
    UIFont *font1 = [UIFont leoQuestionFont];
    UIFont *font2 = [UIFont leoQuestionFont];
    
    UIColor *color1 = [UIColor leoBlack];
    UIColor *color2 = [UIColor leoGreen];
    
    NSDictionary *attributedDictionary1 = @{NSForegroundColorAttributeName:color1,
                                            NSFontAttributeName:font1,
                                            NSParagraphStyleAttributeName:style};
    
    NSDictionary *attributedDictionary2 = @{NSForegroundColorAttributeName:color2,
                                            NSFontAttributeName:font2,
                                            NSParagraphStyleAttributeName:style};
    
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] init];
    [attrString appendAttributedString:[[NSAttributedString alloc] initWithString:sentenceString
                                                                       attributes:attributedDictionary1]];
    
    [attrString appendAttributedString:[[NSAttributedString alloc] initWithString:variableString
                                                                       attributes:attributedDictionary2]];
    
    [button setAttributedTitle:attrString forState:UIControlStateNormal];
}



- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.scrollView scrollToViewIfObstructedByKeyboard:self.notesTextView];
}

-(void)viewDidDisappear:(BOOL)animated{
    [self.scrollView scrollToViewIfObstructedByKeyboard:nil];
}


- (void)setupExpandedCardView {
    
    self.expandedFullTitle = @"Schedule a visit with the practice";
    
    if (self.prepAppointment) {
        [self didUpdateItem:self.prepAppointment.date forKey:@"date"];
        [self didUpdateItem:self.prepAppointment.appointmentType forKey:@"appointmentType"];
        [self didUpdateItem:self.prepAppointment.patient forKey:@"patient"];
        [self didUpdateItem:self.prepAppointment.provider forKey:@"provider"];
    }
}

-(void)setAppointment:(Appointment *)appointment {
    self.card.associatedCardObject = appointment;
}

-(Appointment *)appointment {
    return self.card.associatedCardObject;
}

-(void)scrollViewWasTapped:(UIGestureRecognizer*)gesture{
    if (self.notesTextView.isFirstResponder) {
        [self.notesTextView resignFirstResponder];
    }
}

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


/**
 *  Generic delegate method for returning data from a selection view controller
 *
 *  @param item contains the item in memory that was chosen
 *  @param key  describes the prepAppointment property that should be updated by the item
 */
- (void)didUpdateItem:(nullable id)item forKey:(NSString *)key {
    
    if (item) {
        if ([key isEqualToString:@"appointmentType"]) {
            [self updateButton:self.questionVisitTypeButton withSentenceString:@"I'm scheduling a " variableString:((AppointmentType *)item).name];
        } else if ([key isEqualToString:@"patient"]) {
            [self updateButton:self.questionPatientsButton withSentenceString:@"This appointment is for " variableString:((Patient *)item).firstName];
        } else if ([key isEqualToString:@"provider"]) {
            [self updateButton:self.questionStaffButton withSentenceString:@"I would like to be seen by " variableString:((Provider *)item).fullName];
        } else if ([key isEqualToString:@"date"]) {
            [self updateButton:self.questionCalendarButton withSentenceString:@"My visit is at " variableString:[NSDate stringifiedDateTime:((NSDate *)item)]];
        }
    }
    
    [self.prepAppointment setValue:item forKey:key];
}

/**
 *  When the button is tapped at the bottom of the expanded appointment flow, the card's appointment object is updated with the prepAppointment and the card's method for the first action when in the the current state is called.
 */
- (void)button0Tapped {
    
    self.card.associatedCardObject = [[Appointment alloc] initWithPrepAppointment:self.prepAppointment]; //FIXME: Make this a loop to account for changes to multiple objects, e.g. appointments on a card.
    
    [self.card performSelector:NSSelectorFromString([self.card actionsAvailableForState][0])]; //FIXME: Alternative way to do this that won't cause warning.
    
    //    if (!self.card) { return; }
    //    SEL selector = NSSelectorFromString([self.card actionsAvailableForState][0]);
    //    IMP imp = [self.card methodForSelector:selector];
    //    void (*func)(id, SEL) = (void *)imp;
    //    func(self.card, selector);
}


- (void)button:(UIButton *)button enabled:(BOOL)enabled {
    //This does nothing yet so not actually implementing at this time.
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

-(PrepAppointment *)prepAppointment {
    
    if (!_prepAppointment) {
        
        if (self.appointment) {
            _prepAppointment = [[PrepAppointment alloc] initWithAppointment:self.appointment];
        }
        
        //        NSDate *startTime = [NSDate dateWithYear:2015 month:8 day:12 hour:0 minute:0 second:0];
        //
        //        AppointmentType *type = [[AppointmentType alloc] initWithObjectID:@"0" name:@"Well Visit" typeCode:AppointmentTypeCodeCheckup duration:@30 longDescription:@"Long description" shortDescription:@"Short description"];
        //
        //        Patient *patient = [[Patient alloc] initWithObjectID:@"0" familyID:@"0" title:nil firstName:@"Zach" middleInitial:nil lastName:@"Drossman" suffix:nil email:nil avatarURL:nil avatar:nil dob:[NSDate date] gender:@"Male" status:@"active"];
        //
        //        Provider *provider = [[Provider alloc] initWithObjectID:@"10" title:@"Dr." firstName:@"Om" middleInitial:nil lastName:@"Lala" suffix:nil email:@"lala@leohealth.com" avatarURL:nil avatar:nil credentialSuffixes:@[@"M.D."] specialties:@[@"pediatrics"]];
        //
        //        _prepAppointment = [[PrepAppointment alloc] initWithObjectID:@"0" date:startTime appointmentType:type patient:patient provider:provider bookedByUser:provider note:@"blank note" statusCode:AppointmentStatusCodeBooking];
        
    }
    
    return _prepAppointment;
}



-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
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
}

-(void)dealloc {
    [self.notesTextView removeObserver:self forKeyPath:@"contentSize"];
}



@end
