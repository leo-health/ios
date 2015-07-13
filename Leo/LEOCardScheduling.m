//
//  LEOCardScheduling.m
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
#import "AppointmentType.h"

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

- (instancetype)initWithObjectID:(NSString *)objectID priority:(NSNumber *)priority type:(NSString *)type associatedCardObject:(id)associatedCardObjectDictionary {
    
    self = [super initWithObjectID:objectID priority:priority type:type associatedCardObject:associatedCardObjectDictionary];
    
    if (self) {
        
        Appointment *appointment = [[Appointment alloc] initWithJSONDictionary:associatedCardObjectDictionary];
        
        self.associatedCardObject = appointment;
    }
    
    return self;
}

- (instancetype)initWithDictionary:(NSDictionary *)jsonCard {

    return [self initWithObjectID:jsonCard[APIParamCardID]
                         priority:jsonCard[APIParamCardPriority]
                             type:jsonCard[APIParamCardType]
            associatedCardObject:jsonCard[@"card_data"]];
}


-(Appointment *)appointment {
    
    return (Appointment *)self.associatedCardObject; //FIXME: Update to account for multiple objects at some point...
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
            
        case AppointmentStateCancelled:
            return CardLayoutUndefined;
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
            titleText = @"Appointment Cancelled";
            break;
            
        case AppointmentStateRecommending:
            titleText = @"Recommended Appointment";
            break;
            
        case AppointmentStateReminding:
            titleText = @"Appointment Reminder";
            break;
            
        case AppointmentStateCancelled:
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
            bodyText = [NSString stringWithFormat:@"%@ has a %@ scheduled for %@ at %@.",self.appointment.patient.firstName, [((AppointmentType *)self.appointment.leoAppointmentType).typeDescriptor lowercaseString], self.appointment.stringifiedAppointmentDate, self.appointment.stringifiedAppointmentTime];
            break;
            
        case AppointmentStateCancelled:
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

        case AppointmentStateCancelled:
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
            
            break;
        }
            
        case AppointmentStateCancelled:
            break;
    }
    
    return actions;
}

- (void)book {
    
    self.appointment.priorState = self.appointment.state;
    self.appointment.state = @(AppointmentStateReminding);
    [self.delegate didUpdateObjectStateForCard:self];
}

- (void)schedule {
    
    //opens up a new scheduling card view, filled out with the recommended dates / times
    self.appointment.priorState = self.appointment.state;
    self.appointment.state = @(AppointmentStateBooking);
    [self.delegate didUpdateObjectStateForCard:self];
}

- (void)cancel {
    self.appointment.priorState = self.appointment.state;
    self.appointment.state = @(AppointmentStateCancelling);
    [self.delegate didUpdateObjectStateForCard:self];
    //updates state of the appointment to show a view in which we confirm the user really wants to cancel their appointment
}

- (void)confirmCancelled {
    self.appointment.state = @(AppointmentStateConfirmingCancelling);
    [self.delegate didUpdateObjectStateForCard:self];
}

- (void)unconfirmCancelled {
    
    [self returnToPriorState];
    [self.delegate didUpdateObjectStateForCard:self];
}

- (void)dismiss {
    self.appointment.state = @(AppointmentStateCancelled);
    [self.delegate didUpdateObjectStateForCard:self];
}

- (void)returnToPriorState {
    self.appointment.state = self.appointment.priorState;
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
