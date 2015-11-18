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

-(instancetype)initWithObjectID:(nullable NSString *)objectID date:(nullable NSDate *)date appointmentType:(nullable AppointmentType *)appointmentType patient:(nullable Patient *)patient provider:(nullable Provider *)provider practiceID:(nullable NSString *)practiceID bookedByUser:(User *)bookedByUser note:(nullable NSString *)note status:(AppointmentStatus *)status {

    self = [super init];
    
    if (self) {
        _date = date;
        _appointmentType = appointmentType;
        _patient = patient;
        _provider = provider;
        _practiceID = practiceID;
        _bookedByUser = bookedByUser;
        _status = status;
        _objectID = objectID;
        _note = note;
    }
    
    return self;
}


- (instancetype)initWithJSONDictionary:(nonnull NSDictionary *)jsonResponse {
    
    NSDate *date = [NSDate dateFromDateTimeString:[jsonResponse itemForKey:APIParamAppointmentStartDateTime]];
    Patient *patient = [[Patient alloc] initWithJSONDictionary:[jsonResponse itemForKey:APIParamUserPatient]];
    Provider *provider = [[Provider alloc] initWithJSONDictionary:[jsonResponse itemForKey:APIParamUserProvider]];
    User *bookedByUser = [[User alloc] initWithJSONDictionary:[jsonResponse itemForKey:APIParamAppointmentBookedBy]];
    AppointmentType *appointmentType = [[AppointmentType alloc] initWithJSONDictionary:[jsonResponse itemForKey:APIParamAppointmentType]];
    
    AppointmentStatus *status = [[AppointmentStatus alloc] initWithJSONDictionary:[jsonResponse itemForKey:APIParamStatus]];
    NSString *objectID = [[jsonResponse itemForKey:APIParamID] stringValue];
    NSString *note = [jsonResponse itemForKey:APIParamAppointmentNotes];
    
    //FIXME: Practice ID is being hardcoded while we only have one practice.
    return [self initWithObjectID:objectID date:date appointmentType:appointmentType patient:patient provider:provider practiceID:@"1" bookedByUser:bookedByUser note:note status:status];
}

- (instancetype)initWithPrepAppointment:(PrepAppointment *)prepAppointment {
    
    //TODO: Remove hard coded practice at some point!
    return [self initWithObjectID:prepAppointment.objectID date:prepAppointment.date appointmentType:prepAppointment.appointmentType patient:prepAppointment.patient provider:prepAppointment.provider practiceID:@"1" bookedByUser:prepAppointment.bookedByUser note:prepAppointment.note status:prepAppointment.status];
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
    appointmentDictionary[APIParamPracticeID] = appointment.practiceID;
    
    if (appointment.note) {
        appointmentDictionary[APIParamAppointmentNotes] = appointment.note;
    }

    return appointmentDictionary;
}

-(NSString *) description {
    
    return [NSString stringWithFormat:@"<Appointment: %p>\nid: %@\ndate: %@\nappointmentType: %@\nstate: %lu\nnote %@\nbookedByUser: %@\npatient %@\nprovider: %@",
            self, self.objectID, self.date, self.appointmentType, (unsigned long)self.status, self.note, self.bookedByUser, self.patient, self.provider];
}

@end
