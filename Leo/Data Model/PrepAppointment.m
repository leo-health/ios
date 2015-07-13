//
//  PrepAppointment.m
//  Leo
//
//  Created by Zachary Drossman on 7/7/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import "PrepAppointment.h"
#import "LEOConstants.h"
#import "User.h"
#import "Provider.h"
#import "Patient.h"
#import "AppointmentType.h"

@implementation PrepAppointment

- (instancetype)initWithObjectID:(nullable NSString *)objectID date:(nullable NSDate *)date appointmentType:(AppointmentType *)leoAppointmentType patient:(Patient *)patient provider:(Provider *)provider bookedByUser:(User *)bookedByUser note:(NSString *)note state:(NSNumber *)state {
    
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

//MARK: Not sure this method will ever be used for a prep appointment.
- (instancetype)initWithJSONDictionary:(nonnull NSDictionary *)jsonResponse {
    
    NSDate *date = jsonResponse[APIParamApptDate];
    Patient *patient = jsonResponse[APIParamPatient];
    Provider *provider = jsonResponse[APIParamProvider];
    User *bookedByUser = jsonResponse[APIParamBookedByUser];
    
    //FIXME: This should really go looking for the appointment type via ID as opposed to trying to pull it from this JSON response most likely (hence why we get a warning here because that isn't passed as part of the API endpoint.)
    
    AppointmentType *leoAppointmentType = [[AppointmentType alloc] initWithObjectID:jsonResponse[@"visit_type_id"] type:jsonResponse[@"visit_type_display_name"] duration:nil typeDescription:nil]; //FIXME: Constant
    
    NSNumber *state = jsonResponse[APIParamState];
    NSString *objectID = [jsonResponse[APIParamID] stringValue];
    NSString *note = jsonResponse[APIParamApptNote];
    
    //TODO: May need to protect against nil values...
    return [self initWithObjectID:objectID date:date appointmentType:leoAppointmentType patient:patient provider:provider bookedByUser:bookedByUser note:note state:state];
}

- (NSString *)description {
    
    return [NSString stringWithFormat:@"<Appointment: %p>\nid: %@\ndate: %@\nleoAppointmentType: %@\nstate: %@\nnote %@\nbookedByUser: %@\npatient %@\nprovider: %@",
            self, self.objectID, self.date, self.leoAppointmentType, self.state, self.note, self.bookedByUser, self.patient, self.provider];
}

@end
