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

@implementation Appointment

-(instancetype)initWithObjectID:(nullable NSString *)objectID date:(nullable NSDate *)date appointmentType:(AppointmentType *)leoAppointmentType patient:(Patient *)patient provider:(Provider *)provider bookedByUser:(User *)bookedByUser note:(nullable NSString *)note statusCode:(AppointmentStatusCode)statusCode {
    
    self = [super init];
    
    if (self) {
        _date = date;
        _leoAppointmentType = leoAppointmentType;
        _patient = patient;
        _provider = provider;
        _bookedByUser = bookedByUser;
        _statusCode = statusCode;
        _objectID = objectID;
        _note = note;
    }
    
    return self;
}

- (instancetype)initWithJSONDictionary:(nonnull NSDictionary *)jsonResponse {
    
    NSDate *date = [NSDate dateFromDateTimeString:jsonResponse[@"start_datetime"]];
    Patient *patient = [[Patient alloc] initWithJSONDictionary:jsonResponse[@"patient"]]; //FIXME: Constant
    Provider *provider = [[Provider alloc] initWithJSONDictionary:jsonResponse[APIParamUserProvider]];
    User *bookedByUser = [[User alloc] initWithJSONDictionary:jsonResponse[APIParamAppointmentBookedBy] ];
    
    AppointmentType *leoAppointmentType = [[AppointmentType alloc] initWithJSONDictionary:jsonResponse[@"visit_type"]]; //FIXME: Constant.
    
    AppointmentStatusCode statusCode = [jsonResponse[@"status_id"] integerValue]; //FIXME: Constant
    NSString *objectID = [jsonResponse[APIParamID] stringValue];
    NSString *note = jsonResponse[@"notes"];
    
    //TODO: May need to protect against nil values...
    return [self initWithObjectID:objectID date:date appointmentType:leoAppointmentType patient:patient provider:provider bookedByUser:bookedByUser note:note statusCode:statusCode];
}

- (instancetype)initWithPrepAppointment:(PrepAppointment *)prepAppointment {
    
    return [self initWithObjectID:prepAppointment.objectID date:prepAppointment.date appointmentType:prepAppointment.leoAppointmentType patient:prepAppointment.patient provider:prepAppointment.provider bookedByUser:prepAppointment.bookedByUser note:prepAppointment.note statusCode:prepAppointment.statusCode];
}

+ (NSDictionary *)dictionaryFromAppointment:(Appointment *)appointment {
    
    NSMutableDictionary *appointmentDictionary = [[NSMutableDictionary alloc] init];
    
    appointmentDictionary[APIParamID] = appointment.objectID;
    appointmentDictionary[APIParamAppointmentStartDateTime] = appointment.date;
    appointmentDictionary[APIParamVisitType] = appointment.leoAppointmentType;
    appointmentDictionary[APIParamState] = [NSNumber numberWithInteger:appointment.statusCode];
    appointmentDictionary[APIParamID] = appointment.provider.objectID;
    appointmentDictionary[APIParamID] = appointment.patient.objectID;
    appointmentDictionary[APIParamAppointmentNotes] = appointment.note;
    
    return appointmentDictionary;
}




-(id)copy {
    
    Appointment *apptCopy = [[Appointment alloc] init];
    apptCopy.objectID = self.objectID;
    apptCopy.date = [self.date copy];
    apptCopy.leoAppointmentType = self.leoAppointmentType;
    apptCopy.statusCode = self.statusCode;
    apptCopy.note = self.note;
    apptCopy.bookedByUser = [self.bookedByUser copy];
    apptCopy.patient = [self.patient copy];
    apptCopy.provider = [self.provider copy];
    
    return apptCopy;
}

-(NSString *) description {
    
    return [NSString stringWithFormat:@"<Appointment: %p>\nid: %@\ndate: %@\nleoAppointmentType: %@\nstate: %lu\nnote %@\nbookedByUser: %@\npatient %@\nprovider: %@",
            self, self.objectID, self.date, self.leoAppointmentType, (unsigned long)self.statusCode, self.note, self.bookedByUser, self.patient, self.provider];
}

@end
