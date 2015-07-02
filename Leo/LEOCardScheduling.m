//
//  LEOCollapsedCardScheduling.m
//  Leo
//
//  Created by Zachary Drossman on 5/28/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import "LEOCardScheduling.h"
#import <NSDate+DateTools.h>
#import "LEOAppointmentSchedulingCardVC.h"
#import "UIColor+LeoColors.h"
#import "Patient.h"

@interface LEOCardScheduling ()

@property (strong, nonatomic) Appointment *appointment;

@end

@implementation LEOCardScheduling

static void * XXContext = &XXContext;

static NSString *kActionSelectorSchedule = @"schedule";
static NSString *kActionSelectorCancel = @"cancel";
static NSString *kActionSelectorConfirmCancelled = @"confirmCancelled";
static NSString *kActionSelectorUnconfirmCancelled = @"unconfirmCancelled";
static NSString *kActionSelectorDismiss = @"dismiss";
static NSString *kActionSelectorBook = @"book";

- (instancetype)initWithAppointment:(Appointment *)appointment {
    
    self = [super init];
    
    if (self) {
        _appointment = appointment;
    }
    
    return self;
}

-(Appointment *)appointment {
    
    return (Appointment *)self.associatedCardObject;
}

- (CardLayout)layout {
    
    switch (self.appointment.appointmentState) {
            
        case AppointmentStateBooking:
            return CardLayoutUndefined;
            
        case AppointmentStateCancelling:
            return CardLayoutTwoButtonPrimaryAndSecondary;
            
        case AppointmentStateConfirmingCancelling:
            return CardLayoutOneButtonPrimaryOnly;
            
        case AppointmentStateRecommending:
            return CardLayoutOneButtonSecondaryOnly;
            
        case AppointmentStateReminding:
            return CardLayoutTwoButtonPrimaryAndSecondary;
    }
}

- (NSString *)title {
    
    NSString *titleText;
    
    switch (self.appointment.appointmentState) {
            
        case AppointmentStateBooking:
            titleText = @"Schedule A Visit";
            break;
            
        case AppointmentStateCancelling:
            titleText = @"Cancel Appointment?";
            break;
            
        case AppointmentStateConfirmingCancelling:
            titleText = @"Confirm Appointment Cancellation";
            break;
            
        case AppointmentStateRecommending:
            titleText = @"Appointment Recommendation";
            break;
            
        case AppointmentStateReminding:
            titleText = @"Appointment Reminder";
            break;
    }
    
    return titleText;
}

- (NSString *)body {
    
    NSString *bodyText;
    
    switch (self.appointment.appointmentState) {
            
        case AppointmentStateBooking:
            bodyText = nil;
            break;
            
        case AppointmentStateCancelling:
            bodyText = @"Are you sure you want to cancel your appointment?";
            break;
            
        case AppointmentStateConfirmingCancelling:
            bodyText = [NSString stringWithFormat:@"%@'s appointment has been cancelled. Click dismiss to remove this card from you feed.",self.appointment.patient.firstName];
            break;
            
        case AppointmentStateRecommending:
            bodyText = @"Take a tour of the practice and meet our world class physicians.";
            
            //bodyText = [NSString stringWithFormat:@"Looks like %@ is due for an appointment. We've got you all set. Click here to complete %@'s booking.", self.appointment.patient.firstName, self.appointment.patient.firstName];
            break;
            
        case AppointmentStateReminding:
            bodyText = [NSString stringWithFormat:@"%@ has an appointment on %@ at %@",self.appointment.patient.firstName, self.appointment.stringifiedAppointmentDate, self.appointment.stringifiedAppointmentTime];
            break;
    }
    
    return bodyText;
}

-(nonnull UIColor *)tintColor {
    return [UIColor leoGreen];
}

- (nonnull NSArray *)stringRepresentationOfActionsAvailableForState {
    
    NSArray *actionStrings;
    
    switch (self.appointment.appointmentState) {
        case AppointmentStateBooking:
            actionStrings = @[@"SCHEDULE APPOINTMENT"];
            break;
            
        case AppointmentStateCancelling:
            actionStrings = @[@"YES",@"NO"];
            break;
            
            
        case AppointmentStateConfirmingCancelling:
            actionStrings = @[@"DISMISS"];
            break;
            
            
        case AppointmentStateRecommending:
            actionStrings = @[@"SCHEDULE A VISIT"];
            break;
            
            
        case AppointmentStateReminding:
            actionStrings = @[@"RESCHEDULE",@"CANCEL"];
            break;
            
    }
    
    return actionStrings;
}

- (nonnull NSArray *)actionsAvailableForState {
    
    NSMutableArray *actions = [[NSMutableArray alloc] init];
    
    switch (self.appointment.appointmentState) {
            
        case AppointmentStateBooking: {
            
            NSString *buttonOneAction = kActionSelectorBook;
            [actions addObject:buttonOneAction];
            
            break;
        }
            
        case AppointmentStateRecommending: {
            
            NSString *buttonOneAction = kActionSelectorSchedule;
            [actions addObject:buttonOneAction];
            
            break;
        }
            
        case AppointmentStateReminding: {
            
            NSString *buttonOneAction = kActionSelectorSchedule;
            [actions addObject:buttonOneAction];
            
            NSString *buttonTwoAction = kActionSelectorCancel;
            [actions addObject:buttonTwoAction];
            
            break;
        }
            
        case AppointmentStateCancelling: {
            
            NSString *buttonOneAction = kActionSelectorConfirmCancelled;
            [actions addObject:buttonOneAction];
            
            NSString *buttonTwoAction = kActionSelectorUnconfirmCancelled;
            [actions addObject:buttonTwoAction];
            
            break;
        }
            
        case AppointmentStateConfirmingCancelling: {
            
            NSString *buttonOneAction = kActionSelectorDismiss;
            [actions addObject:buttonOneAction];
            
        }
            
        default:
            break;
    }
    
    return actions;
}

- (void)book {
    
    self.appointment.state = @(AppointmentStateReminding);
    [self.delegate didUpdateObjectStateForCard:self];
}

- (void)schedule {
    
    //opens up a new scheduling card view, filled out with the recommended dates / times
    self.appointment.state = @(AppointmentStateBooking);
    [self.delegate didUpdateObjectStateForCard:self];
}

- (void)cancel {
    
    self.appointment.state = @(AppointmentStateCancelling);
    [self.delegate didUpdateObjectStateForCard:self];
    //updates state of the appointment to show a view in which we confirm the user really wants to cancel their appointment
}

- (void)confirmCancel {
    //updates state of the appointment to show a view in which we confirm the appointment was cancelled.
}

- (void)remind {
    //updates state of the collapsed card to show a few in which we remind user of the upcoming appointment.
}

-(nonnull User *)primaryUser {
    
    return self.appointment.patient;
}

-(nonnull Provider *)secondaryUser {
    
    return self.appointment.provider;
}

//FIXME: Not sure what data we actually want for a timestamp.
- (nonnull NSDate *)timestamp {
    
    return [NSDate date];
}

-(nonnull UIImage *)icon {
    return [UIImage imageNamed:@"CalendarIcon"];
}


@end
