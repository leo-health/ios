//
//  PrepAppointment.m
//  Leo
//
//  Created by Zachary Drossman on 7/7/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import "PrepAppointment.h"
#import "User.h"
#import "Provider.h"
#import "Patient.h"
#import "AppointmentType.h"
#import "Appointment.h"

@implementation PrepAppointment

- (instancetype)initWithObjectID:(nullable NSString *)objectID date:(nullable NSDate *)date appointmentType:(AppointmentType *)appointmentType patient:(Patient *)patient provider:(Provider *)provider bookedByUser:(User *)bookedByUser note:(NSString *)note statusCode:(AppointmentStatusCode)statusCode {

    self = [super init];
    
    if (self) {
        _date = date;
        _appointmentType = appointmentType;
        _patient = patient;
        _provider = provider;
        _bookedByUser = bookedByUser;
        _statusCode = statusCode;
        _objectID = objectID;
        _note = note;
    }
    
    return self;
}

//MARK: Not sure this method will ever be used for a prep appointment.
- (instancetype)initWithJSONDictionary:(nonnull NSDictionary *)jsonResponse {
    
    NSDate *date = jsonResponse[APIParamAppointmentStartDateTime];
    Patient *patient = jsonResponse[APIParamUserPatient];
    Provider *provider = jsonResponse[APIParamUserProvider];
    User *bookedByUser = jsonResponse[APIParamAppointmentBookedBy];
    //FIXME: This should really go looking for the appointment type via ID as opposed to trying to pull it from this JSON response most likely (hence why we get a warning here because that isn't passed as part of the API endpoint.)
    
    AppointmentType *appointmentType = [[AppointmentType alloc] initWithObjectID:@"0" name:jsonResponse[APIParamAppointmentType] typeCode:AppointmentTypeCodeCheckup duration:@15 longDescription:jsonResponse[APIParamAppointmentTypeLongDescription] shortDescription:jsonResponse[APIParamAppointmentTypeShortDescription]]; //FIXME: Constant
    
    AppointmentStatusCode statusCode = [jsonResponse[APIParamState] integerValue];
    NSString *objectID = [jsonResponse[APIParamID] stringValue];
    NSString *note = jsonResponse[APIParamAppointmentNotes];
    
    //TODO: May need to protect against nil values...
    return [self initWithObjectID:objectID date:date appointmentType:appointmentType patient:patient provider:provider bookedByUser:bookedByUser note:note statusCode:statusCode];
}

- (NSString *)description {
    
    return [NSString stringWithFormat:@"<Appointment: %p>\nid: %@\ndate: %@\nappointmentType: %@\nstate: %lu\nnote %@\nbookedByUser: %@\npatient %@\nprovider: %@",
            self, self.objectID, self.date, self.appointmentType, (unsigned long)self.statusCode, self.note, self.bookedByUser, self.patient, self.provider];
}

-(instancetype)initWithAppointment:(Appointment *)appointment {
    
    return [self initWithObjectID:appointment.objectID date:appointment.date appointmentType:appointment.appointmentType patient:appointment.patient provider:appointment.provider bookedByUser:appointment.bookedByUser note:appointment.note statusCode:appointment.statusCode];
};

@end
