//
//  Appointment.m
//  Leo
//
//  Created by Zachary Drossman on 6/16/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import "Appointment.h"
#import "LEOConstants.h"
#import "User.h"
#import "Provider.h"
#import "Patient.h"

@implementation Appointment

-(instancetype)initWithObjectID:(nullable NSString *)objectID date:(nullable NSDate *)date appointmentType:(NSNumber *)leoAppointmentType patient:(Patient *)patient provider:(Provider *)provider bookedByUser:(User *)bookedByUser note:(NSString *)note state:(NSNumber *)state {
    
    self = [super init];
    
    if (self) {
        _date = date;
        _leoAppointmentType = leoAppointmentType;
        _patient = patient;
        _provider = provider;
        _bookedByUser = bookedByUser;
        _state = state;
        _objectID = objectID;
        _note = note;
    }
    
    return self;
}

- (instancetype)initWithJSONDictionary:(nonnull NSDictionary *)jsonResponse {
    
    NSDate *date = jsonResponse[APIParamApptDate];
    Patient *patient = jsonResponse[APIParamPatient];
    Provider *provider = jsonResponse[APIParamProvider];
    User *bookedByUser = jsonResponse[APIParamBookedByUser];
    
    /**
     *  Unsure yet whether we're using an AppointmentType object for this or just a description or numeric code.
     *  TODO: Update from id to appropriate object type when determined.
     */
    id leoAppointmentType = jsonResponse[APIParamApptType];
    NSNumber *state = jsonResponse[APIParamState];
    NSString *objectID = jsonResponse[APIParamID];
    NSString *note = jsonResponse[APIParamApptNote];
    
    //TODO: May need to protect against nil values...
    return [self initWithObjectID:objectID date:date appointmentType:leoAppointmentType patient:patient provider:provider bookedByUser:bookedByUser note:note state:state];
}

+ (NSDictionary *)dictionaryFromAppointment:(Appointment *)appointment {
    
    NSMutableDictionary *appointmentDictionary = [[NSMutableDictionary alloc] init];
    
    appointmentDictionary[APIParamID] = appointment.objectID;
    appointmentDictionary[APIParamApptDate] = appointment.date;
    appointmentDictionary[APIParamApptType] = appointment.leoAppointmentType;
    appointmentDictionary[APIParamState] = appointment.state;
    appointmentDictionary[APIParamProviderID] = appointment.provider.objectID;
    appointmentDictionary[APIParamPatientID] = appointment.patient.objectID;
    appointmentDictionary[APIParamApptNote] = appointment.note;
    
    return appointmentDictionary;
    
}
- (AppointmentState)appointmentState {
    return [self.state integerValue];
}

- (nonnull NSString *)stringifiedAppointmentDate {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    dateFormatter.dateFormat = @"EEE', 'MMM','DD'";
    return [dateFormatter stringFromDate:self.date];
}

- (nonnull NSString *)stringifiedAppointmentTime {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    dateFormatter.dateFormat = @"HH':'MM";
    return [dateFormatter stringFromDate:self.date];
}


@end
