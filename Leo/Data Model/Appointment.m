//
//  Appointment.m
//  Leo
//
//  Created by Zachary Drossman on 6/16/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import "Appointment.h"
#import "User.h"
#import "Provider.h"
#import "Patient.h"
#import "PrepAppointment.h"
#import "AppointmentType.h"
#import "NSDate+Extensions.h"
#import "Practice.h"
#import "NSDictionary+Additions.h"
#import "AppointmentStatus.h"

@implementation Appointment


-(instancetype)initWithObjectID:(nullable NSString *)objectID date:(nullable NSDate *)date appointmentType:(nullable AppointmentType *)appointmentType patient:(nullable Patient *)patient provider:(nullable Provider *)provider practice:(Practice *)practice bookedByUser:(User *)bookedByUser note:(nullable NSString *)note status:(AppointmentStatus *)status {

    self = [super init];

    if (self) {
        _date = date;
        _appointmentType = appointmentType;
        _patient = patient;
        _provider = provider;
        _practice = practice;
        _bookedByUser = bookedByUser;
        _status = status;
        _objectID = objectID;
        _note = note;
    }

    return self;
}


- (instancetype)initWithJSONDictionary:(nonnull NSDictionary *)jsonResponse {
    
    NSDate *date = [NSDate leo_dateFromDateTimeString:[jsonResponse leo_itemForKey:APIParamAppointmentStartDateTime]];
    Patient *patient = [[Patient alloc] initWithJSONDictionary:[jsonResponse leo_itemForKey:APIParamUserPatient]];
    Provider *provider = [[Provider alloc] initWithJSONDictionary:[jsonResponse leo_itemForKey:APIParamUserProvider]];
    User *bookedByUser = [[User alloc] initWithJSONDictionary:[jsonResponse leo_itemForKey:APIParamAppointmentBookedBy]];
    AppointmentType *appointmentType = [[AppointmentType alloc] initWithJSONDictionary:[jsonResponse leo_itemForKey:APIParamAppointmentType]];
    
    AppointmentStatus *status = [[AppointmentStatus alloc] initWithJSONDictionary:[jsonResponse leo_itemForKey:APIParamStatus]];
    NSString *objectID = [[jsonResponse leo_itemForKey:APIParamID] stringValue];
    NSString *note = [jsonResponse leo_itemForKey:APIParamAppointmentNotes];

    Practice *practice = [[Practice alloc] initWithJSONDictionary:[jsonResponse leo_itemForKey:APIParamPractice]];

    //FIXME: Practice ID is being hardcoded while we only have one practice.
    return [self initWithObjectID:objectID date:date appointmentType:appointmentType patient:patient provider:provider practice:practice bookedByUser:bookedByUser note:note status:status];
}

- (AppointmentStatus *)priorStatus {

    if (!_priorStatus) {

        _priorStatus = [[AppointmentStatus alloc] init];
    }

    return _priorStatus;
}

- (instancetype)initWithPrepAppointment:(PrepAppointment *)prepAppointment {


    //TODO: Remove hard coded practice at some point!
    return [self initWithObjectID:prepAppointment.objectID
                             date:prepAppointment.date
                  appointmentType:prepAppointment.appointmentType
                          patient:prepAppointment.patient
                         provider:prepAppointment.provider
                         practice:prepAppointment.practice
                     bookedByUser:prepAppointment.bookedByUser
                             note:prepAppointment.note
                           status:prepAppointment.status];
}

+ (NSDictionary *)dictionaryFromAppointment:(Appointment *)appointment {

    NSMutableDictionary *appointmentDictionary = [[NSMutableDictionary alloc] init];

    if (appointment.objectID) {
        appointmentDictionary[APIParamID] = appointment.objectID;
    }

    appointmentDictionary[APIParamAppointmentStartDateTime] = appointment.date;
    appointmentDictionary[APIParamAppointmentTypeID] = appointment.appointmentType.objectID;
    appointmentDictionary[@"appointment_status_id"] = @(appointment.status.statusCode);
    appointmentDictionary[APIParamUserProviderID] = appointment.provider.objectID;
    appointmentDictionary[APIParamUserPatientID] = appointment.patient.objectID;
    appointmentDictionary[APIParamPracticeID] = appointment.practice.objectID;

    if (appointment.note) {
        appointmentDictionary[APIParamAppointmentNotes] = appointment.note;
    }

    return appointmentDictionary;
}

- (BOOL)isValidForBooking {
    return self.appointmentType && self.patient && self.provider && self.date;
}

- (BOOL)isValidForScheduling {
    return self.appointmentType && self.patient;
}

- (NSString *)description {

    return [NSString stringWithFormat:@"<Appointment: %p>\nid: %@\ndate: %@\nappointmentType: %@\nstate: %lu\nnote %@\nbookedByUser: %@\npatient %@\nprovider: %@", self, self.objectID, self.date, self.appointmentType, (unsigned long)self.status, self.note, self.bookedByUser, self.patient, self.provider];
}


//FIXME: Remove all of the effective mocks here and replace with the API response for getAppointmentStatus.
- (void)reschedule {

    self.priorStatus = self.status;
    self.status = [[AppointmentStatus alloc] initWithObjectID:nil name:@"Future" athenaCode:nil statusCode:AppointmentStatusCodeFuture];
}

- (void)book {

    self.status = [[AppointmentStatus alloc] initWithObjectID:nil name:@"Reminding" athenaCode:nil statusCode:AppointmentStatusCodeReminding];
}

- (void)schedule {

    self.priorStatus = self.status;
    self.status = [[AppointmentStatus alloc] initWithObjectID:nil name:@"Future" athenaCode:nil statusCode:AppointmentStatusCodeFuture];
}

- (void)cancel {
    self.priorStatus = self.status;
    self.status = [[AppointmentStatus alloc] initWithObjectID:nil name:@"Cancelling" athenaCode:nil statusCode:AppointmentStatusCodeCancelling];
}

- (void)confirmCancelled {
    self.status = [[AppointmentStatus alloc] initWithObjectID:nil name:@"ConfirmingCancelling" athenaCode:nil statusCode:AppointmentStatusCodeConfirmingCancelling];
}

- (void)unconfirmCancelled {
    self.status = [[AppointmentStatus alloc] initWithObjectID:nil name:@"Reminding" athenaCode:nil statusCode:AppointmentStatusCodeReminding];
}

- (void)cancelled {
    self.status = [[AppointmentStatus alloc] initWithObjectID:nil name:@"Cancelled" athenaCode:nil statusCode:AppointmentStatusCodeCancelled];
}

- (void)undoIfAvailable {
    self.status = self.priorStatus;
}

- (void)setStatus:(AppointmentStatus *)status {

    _status = status;

    //FIXME: Consider whether this will work given we replace the Appointment object regularly...
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationStatusChanged object:self];
}

@end
