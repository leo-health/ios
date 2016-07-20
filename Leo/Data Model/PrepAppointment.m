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
#import "NSDictionary+Extensions.h"

@implementation PrepAppointment

#pragma mark - Initializers

//FIXME: Eventually this needs to use a status from the list of statuses sent from the API or find another place to do this (likely both!)
- (instancetype)init {

    AppointmentStatus *status = [[AppointmentStatus alloc] initWithObjectID:nil name:nil athenaCode:nil statusCode:AppointmentStatusCodeNew];

    return [self initWithObjectID:nil date:nil appointmentType:nil patient:nil provider:nil practice:nil bookedByUser:nil note:nil status:status];
}

//MARK: Not sure this method will ever be used for a prep appointment.
- (instancetype)initWithJSONDictionary:(nonnull NSDictionary *)jsonDictionary {

    if (!jsonDictionary) {
        return nil;
    }
    
    NSDate *date = jsonDictionary[APIParamAppointmentStartDateTime];
    Patient *patient = jsonDictionary[APIParamUserPatient];
    Provider *provider = jsonDictionary[APIParamUserProvider];
    //    Practice *practice = jsonDictionary[APIParamPractice];
    User *bookedByUser = jsonDictionary[APIParamAppointmentBookedBy];
    //FIXME: This should really go looking for the appointment type via ID as opposed to trying to pull it from this JSON response most likely (hence why we get a warning here because that isn't passed as part of the API endpoint.)

    AppointmentType *appointmentType = [[AppointmentType alloc] initWithObjectID:@"0" name:jsonDictionary[APIParamAppointmentType] typeCode:AppointmentTypeCodeWellVisit duration:@15 longDescription:jsonDictionary[APIParamAppointmentTypeLongDescription] shortDescription:jsonDictionary[APIParamAppointmentTypeShortDescription]]; //FIXME: Constant

    AppointmentStatus *status = [[AppointmentStatus alloc] initWithJSONDictionary:[jsonDictionary leo_itemForKey:APIParamStatus]];
    NSString *objectID = [jsonDictionary[APIParamID] stringValue];
    NSString *note = jsonDictionary[APIParamAppointmentNotes];

    Practice *practice = [[Practice alloc] initWithJSONDictionary:[jsonDictionary leo_itemForKey:APIParamPractice]];

    return [self initWithObjectID:objectID date:date appointmentType:appointmentType  patient:patient provider:provider practice:practice bookedByUser:bookedByUser note:note status:status];
}

-(instancetype)initWithAppointment:(Appointment *)appointment {

    AppointmentStatus *newStatus = [[AppointmentStatus alloc] initWithObjectID:nil name:nil athenaCode:nil statusCode:AppointmentStatusCodeBooking];

    AppointmentStatus *status = appointment.status ?: newStatus;

    return [self initWithObjectID:appointment.objectID
                             date:appointment.date
                  appointmentType:appointment.appointmentType
                          patient:appointment.patient
                         provider:appointment.provider
                       practice:appointment.practice
                     bookedByUser:appointment.bookedByUser
                             note:appointment.note
                           status:status];
};

- (instancetype)initWithObjectID:(nullable NSString *)objectID date:(nullable NSDate *)date appointmentType:(AppointmentType *)appointmentType patient:(Patient *)patient provider:(Provider *)provider practice:(Practice *)practice bookedByUser:(User *)bookedByUser note:(NSString *)note status:(AppointmentStatus *)status {

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

- (NSString *)description {
    
    return [NSString stringWithFormat:@"<Appointment: %p>\nid: %@\ndate: %@\nappointmentType: %@\nstate: %lu\nnote %@\nbookedByUser: %@\npatient %@\nprovider: %@",
            self, self.objectID, self.date, self.appointmentType, (unsigned long)self.status, self.note, self.bookedByUser, self.patient, self.provider];
}



- (BOOL)isValidForBooking {
    return self.appointmentType && self.patient && self.provider && self.date;
}

- (BOOL)isValidForScheduling {
    return self.appointmentType && self.patient; // && self.provider;
}

@end
