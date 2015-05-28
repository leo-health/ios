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

    switch (self.appointment.appointmentState) {
            
        case AppointmentStateBooking:
            return @"Book an appointment"; //used?
            
        case AppointmentStateCancelling:
            return @"Cancel Appointment?";
            
        case AppointmentStateConfirmingCancelling:
            return @"Confirm Appointment Cancellation";
            
        case AppointmentStateRecommending:
            return @"Appointment Recommendation";
            
        case AppointmentStateReminding:
            return @"Appointment Reminder";
    }

    
}

- (NSString *)body {
    
    switch (self.appointment.appointmentState) {
            
        case AppointmentStateBooking:
            return nil;
            
        case AppointmentStateCancelling:
            return @"";
            
        case AppointmentStateConfirmingCancelling:
            return [NSString stringWithFormat:@"%@'s appointment has been cancelled. Click dismiss to remove this card from you feed.",self.appointment.primaryForAppointment.firstName];
            
        case AppointmentStateRecommending:
            return [NSString stringWithFormat:@"Looks like %@ is due for an appointment. We've got you all set. Click here to complete %@'s booking.", self.appointment.primaryForAppointment.firstName, self.appointment.primaryForAppointment.firstName];
            
        case AppointmentStateReminding:
            return [NSString stringWithFormat:@"%@ has an appointment on %@ at %@",self.appointment.primaryForAppointment.firstName, self.appointment.stringifiedAppointmentDate, self.appointment.stringifiedAppointmentTime];
    }
}

- (nonnull NSArray *)stringRepresentationOfActionsAvailableForState {
    
    switch (self.appointment.appointmentState) {
        case AppointmentStateBooking:
            return @[@"Book",@"Cancel"];
            break;
            
        case AppointmentStateCancelling:
            return @[@"Yes",@"No"];
            break;
            
            
        case AppointmentStateConfirmingCancelling:
            return @[@"Dismiss"];
            break;
            
            
        case AppointmentStateRecommending:
            return @[@"Schedule",@"Cancel"];
            break;
            
            
        case AppointmentStateReminding:
            return @[@"Reschedule",@"Cancel"];
            break;
            
        default:
            break;
    }
}


- (nonnull User *)secondaryUser {
    
    
    
}

- (nonnull User *)primaryUser {
    
}

- (nonnull NSDate *)timestamp {

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
