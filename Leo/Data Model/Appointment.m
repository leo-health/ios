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

@implementation Appointment

-(instancetype)initWithObjectID:(nullable NSString *)objectID date:(NSDate *)date appointmentType:(AppointmentType *)appointmentType patient:(Patient *)patient provider:(Provider *)provider practiceID:(NSString *)practiceID bookedByUser:(User *)bookedByUser note:(nullable NSString *)note statusCode:(AppointmentStatusCode)statusCode {

    self = [super init];
    
    if (self) {
        _date = date;
        _appointmentType = appointmentType;
        _patient = patient;
        _provider = provider;
        _practiceID = practiceID;
        _bookedByUser = bookedByUser;
        _statusCode = statusCode;
        _objectID = objectID;
        _note = note;
    }
    
    return self;
}


- (instancetype)initWithJSONDictionary:(nonnull NSDictionary *)jsonResponse {
    
    NSDate *date = [NSDate dateFromDateTimeString:jsonResponse[APIParamAppointmentStartDateTime]];
    Patient *patient = [[Patient alloc] initWithJSONDictionary:jsonResponse[APIParamUserPatient]];
    Provider *provider = [[Provider alloc] initWithJSONDictionary:jsonResponse[APIParamUserProvider]];
    
    //NSString *practiceID = jsonResponse[APIParamPracticeID];
    
    User *bookedByUser = [[User alloc] initWithJSONDictionary:jsonResponse[APIParamAppointmentBookedBy] ];
    
    AppointmentType *appointmentType = [[AppointmentType alloc] initWithJSONDictionary:jsonResponse[APIParamAppointmentType]];
    
    AppointmentStatusCode statusCode = [jsonResponse[APIParamState] integerValue]; //FIXME: Constant
    NSString *objectID = [jsonResponse[APIParamID] stringValue];
    
    NSString *note;

    if (jsonResponse[APIParamAppointmentNotes] != [NSNull null]) {
    
        note = jsonResponse[APIParamAppointmentNotes];
    }
    
    //FIXME: Practice ID is being hardcoded while we only have one practice.
    return [self initWithObjectID:objectID date:date appointmentType:appointmentType patient:patient provider:provider practiceID:@"0" bookedByUser:bookedByUser note:note statusCode:statusCode];
}

- (instancetype)initWithPrepAppointment:(PrepAppointment *)prepAppointment {
    
    return [self initWithObjectID:prepAppointment.objectID date:prepAppointment.date appointmentType:prepAppointment.appointmentType patient:prepAppointment.patient provider:prepAppointment.provider practiceID:@"0" bookedByUser:prepAppointment.bookedByUser note:prepAppointment.note statusCode:prepAppointment.statusCode];
}

+ (NSDictionary *)dictionaryFromAppointment:(Appointment *)appointment {
    
    NSMutableDictionary *appointmentDictionary = [[NSMutableDictionary alloc] init];
    
    if (appointment.objectID) {
    appointmentDictionary[APIParamID] = appointment.objectID;
    }
    
    appointmentDictionary[APIParamAppointmentStartDateTime] = appointment.date;
    appointmentDictionary[APIParamAppointmentTypeID] = appointment.appointmentType.objectID;
    appointmentDictionary[APIParamState] = [NSNumber numberWithInteger:appointment.statusCode];
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
            self, self.objectID, self.date, self.appointmentType, (unsigned long)self.statusCode, self.note, self.bookedByUser, self.patient, self.provider];
}

@end
