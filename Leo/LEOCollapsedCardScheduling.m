//
//  LEOCollapsedCardScheduling.m
//  Leo
//
//  Created by Zachary Drossman on 5/28/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import "LEOCollapsedCardScheduling.h"
#import <NSDate+DateTools.h>
#import "LEOSingleAppointmentSchedulerCardVC.h"

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
            return CardLayoutTwoButtonPrimaryOnly;
            
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
            
            bodyText = @"Are you sure you want to cancel your appointment?";
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

- (nonnull NSArray *)actionsAvailableForState {
    
    NSMutableArray *actions = [[NSMutableArray alloc] init];
    
    switch (self.appointment.appointmentState) {
        case AppointmentStateRecommending: {
            
            NSString *buttonOneAction = @"schedule";
            [actions addObject:buttonOneAction];
            
            NSString *buttonTwoAction = @"cancel";
            [actions addObject:buttonTwoAction];
            
            break;
        }
            
        case AppointmentStateCancelling: {
            
            UIButton *buttonOne = [UIButton buttonWithType:UIButtonTypeCustom];
            [buttonOne setTitle:[self stringRepresentationOfActionsAvailableForState][0] forState:UIControlStateNormal];
            [buttonOne addTarget:self action:@selector(schedule) forControlEvents:UIControlEventTouchUpInside];
            
            [actions addObject:buttonOne];
            
            UIButton *buttonTwo = [UIButton buttonWithType:UIButtonTypeCustom];
            [buttonTwo setTitle:[self stringRepresentationOfActionsAvailableForState][1] forState:UIControlStateNormal];
            [buttonTwo addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
            
            [actions addObject:buttonTwo];
            
            break;
        }
    
        default:
            break;
    }
    
    return actions;
}

- (void)schedule {
    
    //opens up a new scheduling card view, filled out with the recommended dates / times
    
    [self.delegate didTapButtonOneOnCard:self withAssociatedObject:self.appointment];
    
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

-(nonnull User *)secondaryUser {
    return self.appointment.provider;
}

//FIXME: Not sure what data we actually want for a timestamp.
- (nonnull NSDate *)timestamp {
    return [NSDate date];
}

-(nonnull UIImage *)icon {
    return [UIImage imageNamed:@"SMS-32"];
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
