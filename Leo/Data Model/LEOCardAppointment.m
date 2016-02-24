
//
//  LEOCardAppointment.m
//  Leo
//
//  Created by Zachary Drossman on 5/28/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import "LEOCardAppointment.h"
#import <NSDate+DateTools.h>
#import "UIColor+LeoColors.h"
#import "Patient.h"
#import "AppointmentType.h"
#import "Appointment.h"
#import "AppointmentStatus.h"
#import "NSDate+Extensions.h"

@interface LEOCardAppointment ()

@property (strong, nonatomic) Appointment *appointment;

@end

@implementation LEOCardAppointment

static NSString *kActionSelectorSchedule = @"schedule";
static NSString *kActionSelectorCancel = @"cancel";
static NSString *kActionSelectorConfirmCancelled = @"confirmCancelled";
static NSString *kActionSelectorUnconfirmCancelled = @"unconfirmCancelled";
static NSString *kActionSelectorCancelled = @"cancelled";
static NSString *kActionSelectorBook = @"book";
static NSString *kActionSelectorReschedule = @"reschedule";

- (instancetype)initWithObjectID:(NSString *)objectID priority:(NSNumber *)priority associatedCardObject:(id)associatedCardObject {

    Appointment *appointment;

    if ([associatedCardObject isKindOfClass:[NSDictionary class]]) {
        appointment = [[Appointment alloc] initWithJSONDictionary:associatedCardObject];
    } else {
        appointment = associatedCardObject;
    }

    self = [super initWithObjectID:objectID priority:priority type:CardTypeAppointment associatedCardObject:appointment];
    
    if (self) {
        
        [self commonInit];
    }
    
    return self;
}

- (instancetype)initWithJSONDictionary:(NSDictionary *)jsonResponse {

    return [self initWithObjectID:jsonResponse[APIParamID]
                         priority:jsonResponse[APIParamCardPriority]
             associatedCardObject:jsonResponse[APIParamCardData]];
}

- (void)commonInit {

    [self setupNotifications];
}

- (void)setupNotifications {

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(statusChanged) name:kNotificationStatusChanged object:self.associatedCardObject];
}

- (void)removeObservers {

    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotificationStatusChanged object:self.associatedCardObject];
}

- (void)dealloc {

    [self removeObservers];
}

-(void)statusChanged {
     [self.activityDelegate didUpdateObjectStateForCard:self];
}

-(Appointment *)appointment {
    
    return (Appointment *)self.associatedCardObject; //FIXME: Update to account for multiple objects at some point...
}

- (CardLayout)layout {
    
    switch (self.appointment.status.statusCode) {
          
        case AppointmentStatusCodeUndefined:
        case AppointmentStatusCodeCheckedIn:
        case AppointmentStatusCodeCheckedOut:
        case AppointmentStatusCodeChargeEntered:
        case AppointmentStatusCodeOpen:
        case AppointmentStatusCodeBooking:
        case AppointmentStatusCodeNew:
            return CardLayoutUndefined;
            
        case AppointmentStatusCodeCancelling:
            return CardLayoutTwoButtonPrimaryAndSecondary;
            
        case AppointmentStatusCodeConfirmingCancelling:
            return CardLayoutOneButtonPrimaryOnly;
            
        case AppointmentStatusCodeRecommending:
            return CardLayoutOneButtonSecondaryOnly;
            
        case AppointmentStatusCodeFuture:
        case AppointmentStatusCodeReminding:
            return CardLayoutTwoButtonPrimaryAndSecondary;
            
        case AppointmentStatusCodeCancelled:
            return CardLayoutUndefined;
    }
}

- (NSString *)title {
    
    NSString *titleText;
    
    switch (self.appointment.status.statusCode) {
        
        case AppointmentStatusCodeUndefined:
        case AppointmentStatusCodeCheckedIn:
        case AppointmentStatusCodeCheckedOut:
        case AppointmentStatusCodeChargeEntered:
        case AppointmentStatusCodeOpen:
            titleText = @"";
            break;
            
        case AppointmentStatusCodeBooking:
        case AppointmentStatusCodeNew:
            titleText = @"Schedule A Visit";
            break;
            
        case AppointmentStatusCodeCancelling:
            titleText = @"Cancel Appointment?";
            break;
            
        case AppointmentStatusCodeConfirmingCancelling:
            titleText = @"Appointment Cancelled";
            break;
            
        case AppointmentStatusCodeRecommending:
            titleText = @"Recommended Appointment";
            break;
            
        case AppointmentStatusCodeFuture:
        case AppointmentStatusCodeReminding:
            titleText = @"Appointment Reminder";
            break;
            
        case AppointmentStatusCodeCancelled:
            break;
            
        default:
            break;
    }
    
    return titleText;
}

- (NSString *)body {
    
    NSString *bodyText;
    
    switch (self.appointment.status.statusCode) {
            
        case AppointmentStatusCodeBooking:
        case AppointmentStatusCodeNew:
            bodyText = nil;
            break;
            
        case AppointmentStatusCodeCancelling:
            bodyText = @"Are you sure you want to cancel your appointment?";
            break;
            
        case AppointmentStatusCodeConfirmingCancelling:
            bodyText = [NSString stringWithFormat:@"%@'s appointment has been cancelled. This card will be automatically removed from your feed after some time.",self.appointment.patient.firstName];
            break;
            
        case AppointmentStatusCodeRecommending:
            bodyText = @"Take a tour of the practice and meet our world class physicians.";
            
            //bodyText = [NSString stringWithFormat:@"Looks like %@ is due for an appointment. We've got you all set. Click here to complete %@'s booking.", self.appointment.patient.firstName, self.appointment.patient.firstName];
            break;
            
        case AppointmentStatusCodeFuture:
        case AppointmentStatusCodeReminding:
            bodyText = [NSString stringWithFormat:@"%@ has a %@ scheduled for %@ at %@.",self.appointment.patient.firstName, [((AppointmentType *)self.appointment.appointmentType).name lowercaseString], [NSDate leo_stringifiedDateWithCommas:self.appointment.date], [NSDate leo_stringifiedTimeWithEasternTimeZone:self.appointment.date]];
            break;
            
        case AppointmentStatusCodeCancelled:
            break;
            
        default:
            break;
    }
    
    return bodyText;
}

-(nonnull UIColor *)tintColor {
    return [UIColor leo_green];
}

- (nonnull NSArray *)stringRepresentationOfActionsAvailableForState {
    
    NSArray *actionStrings;
    
    switch (self.appointment.status.statusCode) {
        case AppointmentStatusCodeBooking:
            actionStrings = @[@"RESCHEDULE APPOINTMENT"];
            break;
            
        case AppointmentStatusCodeNew:
            actionStrings = @[@"SCHEDULE APPOINTMENT"];
            break;
            
        case AppointmentStatusCodeCancelling:
            actionStrings = @[@"YES",@"NO"];
            break;
            
            
        case AppointmentStatusCodeConfirmingCancelling:
            actionStrings = @[@"DISMISS"];
            break;
            
            
        case AppointmentStatusCodeRecommending:
            actionStrings = @[@"SCHEDULE A VISIT"];
            break;
            
        case AppointmentStatusCodeFuture:
        case AppointmentStatusCodeReminding:
            actionStrings = @[@"RESCHEDULE",@"CANCEL"];
            break;
            
        case AppointmentStatusCodeCancelled:
            break;
            
        default:
            break;
    }
    
    return actionStrings;
}

- (nonnull NSArray *)actionsAvailableForState {
    
    NSMutableArray *actions = [[NSMutableArray alloc] init];
    
    switch (self.appointment.status.statusCode) {
        
        case AppointmentStatusCodeNew: {
    
            NSString *buttonOneAction = kActionSelectorBook;
            [actions addObject:buttonOneAction];
            
            break;
            
        }
            
        case AppointmentStatusCodeBooking: {
    
            NSString *buttonOneAction = kActionSelectorReschedule;
            [actions addObject:buttonOneAction];
            
            break;
        }
            
        case AppointmentStatusCodeRecommending: {
            
            NSString *buttonOneAction = kActionSelectorSchedule;
            [actions addObject:buttonOneAction];
            
            break;
        }
            
        case AppointmentStatusCodeReminding:
        case AppointmentStatusCodeFuture: {

            NSString *buttonOneAction = kActionSelectorReschedule;
            [actions addObject:buttonOneAction];
            
            NSString *buttonTwoAction = kActionSelectorCancel;
            [actions addObject:buttonTwoAction];
            
            break;
        }
            
        case AppointmentStatusCodeCancelling: {
            
            NSString *buttonOneAction = kActionSelectorConfirmCancelled;
            [actions addObject:buttonOneAction];
            
            NSString *buttonTwoAction = kActionSelectorUnconfirmCancelled;
            [actions addObject:buttonTwoAction];
            
            break;
        }
            
        case AppointmentStatusCodeConfirmingCancelling: {
            
            NSString *buttonOneAction = kActionSelectorCancelled;
            [actions addObject:buttonOneAction];
            
            break;
        }
            
        case AppointmentStatusCodeCancelled:
            break;
            
        default:
            break;
    }
    
    return actions;
}

-(nullable User *)primaryUser {
    
    return self.appointment.patient;
}

-(nullable Provider *)secondaryUser {
    
    return self.appointment.provider;
}

//FIXME: Not sure what data we actually want for a timestamp.
- (nonnull NSDate *)timestamp {
    
    return [NSDate date];
}

-(nonnull UIImage *)icon {
    return [UIImage imageNamed:@"Icon-Calendar"];
}


@end
