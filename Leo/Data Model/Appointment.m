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
#import "PrepAppointment.h"

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

- (instancetype)initWithPrepAppointment:(PrepAppointment *)prepAppointment {
    
    return [self initWithObjectID:prepAppointment.objectID date:prepAppointment.date appointmentType:prepAppointment.leoAppointmentType patient:prepAppointment.patient provider:prepAppointment.provider bookedByUser:prepAppointment.bookedByUser note:prepAppointment.note state:prepAppointment.state];
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

- (AppointmentState)priorAppointmentState {
    return [self.priorState integerValue];
}

- (nonnull NSString *)stringifiedAppointmentDate {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    dateFormatter.dateFormat = @"EEEE', 'MMMM' 'd'";
    return [dateFormatter stringFromDate:self.date];
}

- (nonnull NSString *)stringifiedAppointmentTime {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    dateFormatter.dateFormat = @"h':'mma";
    dateFormatter.AMSymbol = @"am";
        dateFormatter.PMSymbol = @"pm";
    return [dateFormatter stringFromDate:self.date];
}


-(id)copy {
    
    Appointment *apptCopy = [[Appointment alloc] init];
    apptCopy.objectID = self.objectID;
    apptCopy.date = [self.date copy];
    apptCopy.leoAppointmentType = self.leoAppointmentType;
    apptCopy.state = self.state;
    apptCopy.note = self.note;
    apptCopy.bookedByUser = [self.bookedByUser copy];
    apptCopy.patient = [self.patient copy];
    apptCopy.provider = [self.provider copy];

    return apptCopy;
}

-(NSString *) description {
    
    return [NSString stringWithFormat:@"<Appointment: %p>\nid: %@\ndate: %@\nleoAppointmentType: %@\nstate: %@\nnote %@\nbookedByUser: %@\npatient %@\nprovider: %@",
            self, self.objectID, self.date, self.leoAppointmentType, self.state, self.note, self.bookedByUser, self.patient, self.provider];
}

@end
