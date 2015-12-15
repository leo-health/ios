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
#import "Practice.h"
#import "AppointmentStatus.h"
#import "NSDictionary+Additions.h"

@implementation PrepAppointment

- (instancetype)initWithObjectID:(nullable NSString *)objectID date:(nullable NSDate *)date appointmentType:(AppointmentType *)appointmentType patient:(Patient *)patient provider:(Provider *)provider practiceID:(NSString *)practiceID bookedByUser:(User *)bookedByUser note:(NSString *)note status:(AppointmentStatus *)status {

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

/**
 *  Sets provider and resets the date of the appointment as required for a new appointment date to be chosen
 *
 *  @param appointmentType an AppointmentType object
 */
-(void)setProvider:(Provider *)provider {
    _provider = provider;
    self.date = nil;
}

/**
 *  Sets appointmentType and resets the date of the appointment as required for a new appointment date to be chosen
 *
 *  @param appointmentType an AppointmentType object
 */
-(void)setAppointmentType:(AppointmentType *)appointmentType {
    _appointmentType = appointmentType;
    self.date = nil;
}

//MARK: Not sure this method will ever be used for a prep appointment.
- (instancetype)initWithJSONDictionary:(nonnull NSDictionary *)jsonResponse {
    
    NSDate *date = jsonResponse[APIParamAppointmentStartDateTime];
    Patient *patient = jsonResponse[APIParamUserPatient];
    Provider *provider = jsonResponse[APIParamUserProvider];
//    Practice *practice = jsonResponse[APIParamPractice];
    User *bookedByUser = jsonResponse[APIParamAppointmentBookedBy];
    //FIXME: This should really go looking for the appointment type via ID as opposed to trying to pull it from this JSON response most likely (hence why we get a warning here because that isn't passed as part of the API endpoint.)
    
    AppointmentType *appointmentType = [[AppointmentType alloc] initWithObjectID:@"0" name:jsonResponse[APIParamAppointmentType] typeCode:AppointmentTypeCodeWellVisit duration:@15 longDescription:jsonResponse[APIParamAppointmentTypeLongDescription] shortDescription:jsonResponse[APIParamAppointmentTypeShortDescription]]; //FIXME: Constant
    
    AppointmentStatus *status = [[AppointmentStatus alloc] initWithJSONDictionary:[jsonResponse leo_itemForKey:APIParamStatus]];
    NSString *objectID = [jsonResponse[APIParamID] stringValue];
    NSString *note = jsonResponse[APIParamAppointmentNotes];
    
    //TODO: Come back and replace practiceID with actual practiceID
    return [self initWithObjectID:objectID date:date appointmentType:appointmentType  patient:patient provider:provider practiceID:@"0" bookedByUser:bookedByUser note:note status:status];
}

- (NSString *)description {
    
    return [NSString stringWithFormat:@"<Appointment: %p>\nid: %@\ndate: %@\nappointmentType: %@\nstate: %lu\nnote %@\nbookedByUser: %@\npatient %@\nprovider: %@",
            self, self.objectID, self.date, self.appointmentType, (unsigned long)self.status, self.note, self.bookedByUser, self.patient, self.provider];
}

-(instancetype)initWithAppointment:(Appointment *)appointment {
    
    return [self initWithObjectID:appointment.objectID
                             date:appointment.date
                  appointmentType:appointment.appointmentType
                          patient:appointment.patient
                         provider:appointment.provider
                       practiceID:appointment.practiceID
                     bookedByUser:appointment.bookedByUser
                             note:appointment.note
                           status:appointment.status];
};

@end
