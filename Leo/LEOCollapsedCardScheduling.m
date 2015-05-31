//
//  LEOCollapsedCardScheduling.m
//  Leo
//
//  Created by Zachary Drossman on 5/28/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import "LEOCollapsedCardScheduling.h"
#import <NSDate+DateTools.h>
@interface LEOCollapsedCardScheduling ()

@property (strong, nonatomic) Appointment *appointment;

@end

@implementation LEOCollapsedCardScheduling

static void * XXContext = &XXContext;

- (instancetype)initWithAppointment:(Appointment *)appointment
{
    self = [super init];
    if (self) {
        _appointment = appointment;
        
        [appointment addObserver:self forKeyPath:NSStringFromSelector(@selector(appointmentState)) options:NSKeyValueObservingOptionNew context:XXContext];
    }
    return self;
}

-(Appointment *)appointment {
    return (Appointment *)self.associatedCardObject;
}

- (CardLayout)layout {
    
    switch (self.appointment.appointmentState) {
            
        case AppointmentStateBooking:
            return CardLayoutTwoButtonPrimaryOnly;
            
        case AppointmentStateCancelling:
            return CardLayoutTwoButtonSecondaryAndPrimary;
            
        case AppointmentStateConfirmingCancelling:
            return CardLayoutOneButtonSecondaryAndPrimary;
            
        case AppointmentStateRecommending:
            return CardLayoutTwoButtonPrimaryOnly;
            
        case AppointmentStateReminding:
            return CardLayoutTwoButtonSecondaryAndPrimary;
            
    }
}

- (NSString *)title {

    NSString *titleText;

    switch (self.appointment.appointmentState) {
            
        case AppointmentStateBooking:
            titleText = @"Book an appointment"; //used?
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
            
            bodyText = @"";
            break;
            
        case AppointmentStateConfirmingCancelling:
            bodyText = [NSString stringWithFormat:@"%@'s appointment has been cancelled. Click dismiss to remove this card from you feed.",self.appointment.patient.firstName];
            break;
            
        case AppointmentStateRecommending:
            bodyText = [NSString stringWithFormat:@"Looks like %@ is due for an appointment. We've got you all set. Click here to complete %@'s booking.", self.appointment.patient.firstName, self.appointment.patient.firstName];
            break;
            
        case AppointmentStateReminding:
            bodyText = [NSString stringWithFormat:@"%@ has an appointment on %@ at %@",self.appointment.patient.firstName, self.appointment.stringifiedAppointmentDate, self.appointment.stringifiedAppointmentTime];
            break;
    }
    
    return bodyText;
}

- (nonnull NSArray *)stringRepresentationOfActionsAvailableForState {
    
    NSArray *actionStrings;
    
    switch (self.appointment.appointmentState) {
        case AppointmentStateBooking:
            actionStrings = @[@"Book",@"Cancel"];
            break;
            
        case AppointmentStateCancelling:
            actionStrings = @[@"Yes",@"No"];
            break;
            
            
        case AppointmentStateConfirmingCancelling:
            actionStrings = @[@"Dismiss"];
            break;
            
            
        case AppointmentStateRecommending:
            actionStrings = @[@"Schedule",@"Cancel"];
            break;
            
            
        case AppointmentStateReminding:
            actionStrings = @[@"Reschedule",@"Cancel"];
            break;
            
    }
    
    return actionStrings;
}

-(nonnull User *)primaryUser {
    return self.appointment.patient;
}

-(nonnull User *)secondaryUser {
    return self.appointment.provider;
}

//FIXME: Not sure what data we actually want for a timestamp.
- (nonnull NSDate *)timestamp {
    return [NSDate date];
}


- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    if (context == XXContext) {
        if ([keyPath isEqualToString:NSStringFromSelector(@selector(appointmentState))]) {
            NSLog(@"Keypath:%@",keyPath);
            NSLog(@"");
            NSLog(@"Object:%@",object);
            NSLog(@"");
            NSLog(@"Change:%@",change);
            NSLog(@"");
            NSLog(@"Context:%@",context);
        }
    }
}
@end
