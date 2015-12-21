//
//  LEOExpandedCardAppointmentViewController.m
//  LEOCalendar
//
//  Created by Zachary Drossman on 8/3/15.
//  Copyright (c) 2015 Zachary Drossman. All rights reserved.
//

#import "LEOExpandedCardAppointmentViewController.h"
#import "UIScrollView+LEOScrollToVisible.h"
#import "LEOCard.h"
#import "JVFloatLabeledTextView.h"
#import "UIFont+LeoFonts.h"
#import "UIColor+LeoColors.h"
#import "PrepAppointment.h"
#import "Appointment.h"
#import "AppointmentType.h"
#import "Provider.h"
#import "Patient.h"
#import "NSDate+Extensions.h"
#import "LEOBasicSelectionViewController.h"
#import "AppointmentTypeCell+ConfigureCell.h"
#import "PatientCell+ConfigureCell.h"
#import "ProviderCell+ConfigureCell.h"
#import "LEOCalendarViewController.h"
#import "LEOAppointmentService.h"
#import "LEOAPIAppointmentTypesOperation.h"
#import "LEOAPIPracticeOperation.h"
#import "LEOAPIFamilyOperation.h"
#import "LEOAPISlotsOperation.h"
#import <MBProgressHUD.h>
#import "AppointmentStatus.h"
#import "LEOPromptField.h"
#import "LEOAppointmentView.h"

@interface LEOExpandedCardAppointmentViewController ()

@property (strong, nonatomic) LEOAppointmentView *appointmentView;

@property (strong, nonatomic) Appointment *appointment;
@property (strong, nonatomic) PrepAppointment *prepAppointment;

@property (strong, nonatomic) LEOAppointmentService *appointmentService;

@end

@implementation LEOExpandedCardAppointmentViewController

#pragma mark - View Controller Lifecycle
- (void)viewDidLoad {
    
    [super viewDidLoad];
    
//    self.bodyView = self.appointmentView;
//    self.card.delegate = self;
//        
//    [self setupExpandedCardView];
//    [self setupNotesTextView];
//    [LEOApiReachability startMonitoringForController:self];
}

- (void)viewDidDisappear:(BOOL)animated{
    
//    [LEOApiReachability stopMonitoring];
//    [self.scrollView scrollToViewIfObstructedByKeyboard:nil];
}

#pragma mark - VCL Helper Methods

//- (void)setupNotesTextView {
//    
//    [self.view layoutIfNeeded];
//    
//    UITapGestureRecognizer *tapGestureForTextFieldDismissal = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(scrollviewTapped:)];
//    tapGestureForTextFieldDismissal.cancelsTouchesInView = NO;
//    [self.scrollView addGestureRecognizer:tapGestureForTextFieldDismissal];
//    
//    }
//
///**
// *  Sets up the container view.
// */
//- (void)setupExpandedCardView {
//    
//    self.expandedFullTitle = @"Schedule a visit\nwith the practice";
//}
//
//
//#pragma mark - Setters / Getters
//
///**
// *  Appointment setter that sets the appointment to the card's associated card object as opposed to a backing store.
// *
// *  @param appointment
// */
//- (void)setAppointment:(Appointment *)appointment {
//    
//    self.card.associatedCardObject = appointment;
//}
//
//
///**
// *  Appointment getter that uses the card's associated object instead of an ivar as its backing store
// *
// *  @return the associated card object (which is an appointment in this case
// */
//-(Appointment *)appointment {
//    return self.card.associatedCardObject;
//}
//
//
//
//#pragma mark - <TextViewDelegate>
//
//-(void)textViewDidChange:(UITextView *)textView {
//    
//    [UIView animateWithDuration:0.1 animations:^{
//        self.prepAppointment.note = textView.text;
//        [self.view layoutIfNeeded];
//    }];
//}
//
//
////- (void)textFieldDidBeginEditing:(UITextField *)sender
////{
////    self.keyboardHelper.activeField = sender;
////}   
////
////- (void)textFieldDidEndEditing:(UITextField *)sender
////{
////    self.keyboardHelper.activeField = nil;
////}
//
//
//#pragma mark - <SingleSelectionProtocol>
///**
// *  Generic delegate method for returning data from a selection view controller
// *
// *  @param item contains the item in memory that was chosen
// *  @param key  describes the prepAppointment property that should be updated by the item
// */
//- (void)didUpdateItem:(nullable id)item forKey:(NSString *)key {
//    
//    [self.prepAppointment setValue:item forKey:key];
//}
//
//
//-(void)didUpdateObjectStateForCard:(LEOCard *)card {
//    
//    [self dismissViewControllerAnimated:YES completion:^{
//        [self.delegate takeResponsibilityForCard:card];
//    }];
//}
//
//
//
//
//- (LEOAppointmentService *)appointmentService {
//    
//    if (!_appointmentService) {
//        _appointmentService = [[LEOAppointmentService alloc] init];
//    }
//    
//    return _appointmentService;
//}
//
//#pragma mark - Actions
//
///**
// *  When the button is tapped at the bottom of the expanded appointment flow, the card's appointment object is updated with the prepAppointment and the card's method for the first action
// *  when in the the current state is called.
// */
//- (void)buttonTapped {
//        
//    self.appointment = [[Appointment alloc] initWithPrepAppointment:self.prepAppointment]; //FIXME: Make this a loop to account for changes to multiple objects, e.g. appointments on a card.
//    
//    self.appointment.status.statusCode = AppointmentStatusCodeFuture;
//    
//    [MBProgressHUD showHUDAddedTo:self.view.window animated:YES];
//    
//    if (!self.appointment.objectID) {
//    
//    [self.appointmentService createAppointmentWithAppointment:self.appointment withCompletion:^(NSDictionary * rawResults, NSError * error) {
//        
//        [MBProgressHUD hideHUDForView:self.view.window animated:YES];
//
//        if (!error) {
//        
//
//            
//#pragma clang diagnostic push
//#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
//            [self.card performSelector:NSSelectorFromString([self.card actionsAvailableForState][0])];
//#pragma  clang diagnostic pop
//
//        //    MARK: Alternative if the above gives us issues.
//        //    if (!self.card) { return; }
//        //    SEL selector = NSSelectorFromString([self.card actionsAvailableForState][0]);
//        //    IMP imp = [self.card methodForSelector:selector];
//        //    void (*func)(id, SEL) = (void *)imp;
//        //    func(self.card, selector);
//        }
//        
//    }];
//    
//    } else {
//        
//        [self.appointmentService rescheduleAppointmentWithAppointment:self.appointment withCompletion:^(NSDictionary *rawResults, NSError *error) {
//            
//            [MBProgressHUD hideHUDForView:self.view.window animated:YES];
//            
//            if (!error) {
//                
//#pragma clang diagnostic push
//#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
//                [self.card performSelector:NSSelectorFromString([self.card actionsAvailableForState][0])];
//#pragma  clang diagnostic pop
//                
//                //    MARK: Alternative if the above gives us issues.
//                //    if (!self.card) { return; }
//                //    SEL selector = NSSelectorFromString([self.card actionsAvailableForState][0]);
//                //    IMP imp = [self.card methodForSelector:selector];
//                //    void (*func)(id, SEL) = (void *)imp;
//                //    func(self.card, selector);
//            }
//        }];
//    }
//}
//
//-(void)scrollviewTapped:(UIGestureRecognizer*)gesture{
//    if (self.notesTextView.isFirstResponder) {
//        [self.notesTextView resignFirstResponder];
//    }
//    
//}
//
//
//#pragma mark - Navigation
//
//// In a storyboard-based application, you will often want to do a little preparation before navigation
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    
//    LEOCalendarViewController *calendarVC = segue.destinationViewController;
//    
//    __block BOOL shouldSelect = NO;
//    
//    if ([segue.identifier isEqualToString:@"CalendarSegue"]) {
//        
//        calendarVC.delegate = self;
//        calendarVC.prepAppointment = self.prepAppointment;
//        calendarVC.requestOperation = [[LEOAPISlotsOperation alloc] initWithPrepAppointment:self.prepAppointment];
//        
//        return;
//    }
//    
//    LEOBasicSelectionViewController *selectionVC = segue.destinationViewController;
//    
//    if ([segue.identifier isEqualToString:@"AppointmentTypeSegue"]) {
//        
//        selectionVC.key = @"appointmentType";
//        selectionVC.reuseIdentifier = @"AppointmentTypeCell";
//        selectionVC.titleText = @"What type of visit is this?";
//        
//        selectionVC.configureCellBlock = ^(AppointmentTypeCell *cell, AppointmentType *appointmentType) {
//            cell.selectedColor = self.card.tintColor;
//            
//            [cell configureForAppointmentType:appointmentType];
//            
//            shouldSelect = NO;
//            
//            if ([appointmentType.objectID isEqualToString:self.prepAppointment.appointmentType.objectID]) {
//                shouldSelect = YES;
//            }
//            
//            return shouldSelect;
//        };
//        
//        selectionVC.requestOperation = [[LEOAPIAppointmentTypesOperation alloc] init];
//        selectionVC.delegate = self;
//        
//        //        [UIView animateWithDuration:0.25
//        //                         animations:^{
//        //                             [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
//        //                             [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.navigationController.view cache:NO];
//        //                         }];
//        
//    } else
//        if ([segue.identifier isEqualToString:@"PatientSegue"]) {
//            
//            selectionVC.key = @"patient";
//            selectionVC.reuseIdentifier = @"PatientCell";
//            selectionVC.titleText = @"Who is the visit for?";
//            
//            selectionVC.configureCellBlock = ^(PatientCell *cell, Patient *patient) {
//                
//                cell.selectedColor = self.card.tintColor;
//                
//                shouldSelect = NO;
//                
//                [cell configureForPatient:patient];
//                
//                if ([patient.objectID isEqualToString:self.prepAppointment.patient.objectID]) {
//                    shouldSelect = YES;
//                }
//                
//                return shouldSelect;
//            };
//            
//            selectionVC.requestOperation = [[LEOAPIFamilyOperation alloc] init];
//            selectionVC.delegate = self;
//        } else
//            if ([segue.identifier isEqualToString:@"ProviderSegue"]) {
//                
//                selectionVC.key = @"provider";
//                selectionVC.reuseIdentifier = @"ProviderCell";
//                selectionVC.titleText = @"Who would you like to see?";
//                selectionVC.feature = FeatureAppointmentScheduling;
//                selectionVC.configureCellBlock = ^(ProviderCell *cell, Provider *provider) {
//                    
//                    cell.selectedColor = self.card.tintColor;
//                    
//                    shouldSelect = NO;
//                    
//                    if ([provider.objectID isEqualToString:self.prepAppointment.provider.objectID]) {
//                        shouldSelect = YES;
//                    }
//                    
//                    [cell configureForProvider:provider];
//                    
//                    return shouldSelect;
//                };
//                
//                selectionVC.requestOperation = [[LEOAPIPracticeOperation alloc] init];
//                selectionVC.delegate = self;
//            }
//    
//}
//
//- (PrepAppointment *)prepAppointment {
//    
//    if (!_prepAppointment) {
//        
//        if (self.appointment) {
//            _prepAppointment = [[PrepAppointment alloc] initWithAppointment:self.appointment];
//        }
//    }
//    
//    return _prepAppointment;
//}
//
//
//#pragma mark - KVO
//
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
//    
//    
//    /**
//     *  Listen for changes to the prepAppointment and then check if we should enable slot choice functionality and booking functionality
//     */
//    if (object == self.prepAppointment) {
//        
//        
//        if ([keyPath isEqualToString:@"appointmentType"]) {
//            
//            self.appointmentView.appointmentType = self.prepAppointment.appointmentType;
//            [self toggleButtonValidated:[self shouldEnableUserToBookAppointment]];
//            
//        } else if ([keyPath isEqualToString:@"provider"]) {
//            
//            self.appointmentView.provider = self.prepAppointment.provider;
//            [self updatePromptFieldText:self.staffPromptField];
//            [self toggleButtonValidated:[self shouldEnableUserToBookAppointment]];
//            
//        } else if ([keyPath isEqualToString:@"patient"]) {
//            
//            self.appointmentView.patient = self.prepAppointment.patient;
//            [self updatePromptFieldText:self.patientPromptField];
//            [self toggleButtonValidated:[self shouldEnableUserToBookAppointment]];
//            
//            
//        } else if ([keyPath isEqualToString:@"date"]) {
//            
//            self.appointmentView.date = self.prepAppointment.date;
//            [self toggleButtonValidated:[self shouldEnableUserToBookAppointment]];
//        }
//    }
//}
//
//
//
//
//- (void)updatePromptFieldText:(LEOPromptField *)promptView {
//    
//    if (promptView == self.visitTypePromptField) {
//        
//        if (self.prepAppointment.appointmentType) {
//            [self updatePromptField:promptView withBaseString:@"I'm scheduling a" variableStrings:@[self.prepAppointment.appointmentType.name]];
//        } else {
//            [self updatePromptField:promptView withBaseString:@"What brings you in today?" variableStrings:nil];
//        }
//        
//    } else if (promptView == self.patientPromptField) {
//        
//        if (self.prepAppointment.patient) {
//            [self updatePromptField:promptView withBaseString:@"This appointment is for" variableStrings:@[self.prepAppointment.patient.firstName]];
//        } else {
//            [self updatePromptField:promptView withBaseString:@"Who is this appointment for?" variableStrings:nil];
//        }
//        
//    } else if (promptView == self.staffPromptField) {
//        
//        if (self.prepAppointment.provider) {
//            
//            NSString *credential = [self.prepAppointment.provider.credentials[0] stringByReplacingOccurrencesOfString:@"." withString:@""];  //TODO: This will need to be updated at some point when we decide how we want to handle these.
//            
//            NSArray *variableStrings;
//            if (credential) {
//                variableStrings = @[[NSString stringWithFormat:@"%@ %@",self.prepAppointment.provider.firstAndLastName, credential]];
//                
//            } else {
//                variableStrings = @[[NSString stringWithFormat:@"%@",self.prepAppointment.provider.firstAndLastName]];
//            }
// 
//            [self updatePromptField:promptView withBaseString:@"We will be seen by" variableStrings:variableStrings];
// 
//        } else {
//            [self updatePromptField:promptView withBaseString:@"Who would you like to see?" variableStrings:nil];
//        }
//        
//    } else if (promptView == self.schedulePromptField) {
//        
//        if (self.prepAppointment.date && self.schedulePromptField.userInteractionEnabled) {
//            [self updateSchedulingPromptField:promptView];
//        } else if (!self.prepAppointment.date && self.schedulePromptField.userInteractionEnabled) {
//            [self updatePromptField:promptView withBaseString:@"When would you like to come in?" variableStrings:nil];
//        } else if (!self.prepAppointment.date && !self.schedulePromptField.userInteractionEnabled) {
//            [self updatePromptField:promptView withBaseString:@"Please complete the fields above before selecting an appointment date and time." variableStrings:nil];
////            promptView.frame = CGRectMake(promptView.frame.origin.x, promptView.frame.origin.y, promptView.frame.size.width, promptView.titleLabel.frame.size.height);
//        }
//    }
//    
//    promptView.accessoryImage =  [UIImage imageNamed:@"Icon-ForwardArrow"];
//    
//    [self.view layoutIfNeeded];
//}


@end
