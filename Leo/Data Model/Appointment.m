//
//  Appointment.m
//  Leo
//
//  Created by Zachary Drossman on 6/16/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import "Appointment.h"
#import "User.h"
#import "LEOConstants.h"
#import "User+Methods.h"
#import "Role+Methods.h"
#import "LEOCoreDataManager.h"

@implementation Appointment

-(instancetype)initWithDate:(nullable NSDate *)date appointmentType:(NSNumber *)leoAppointmentType patient:(User *)patient provider:(User *)provider familyID:(NSString *)familyID bookedByUser:(User *)bookedByUser state:(NSNumber *)state {
    
    self = [super init];
    
    if (self) {
        _date = date;
        _leoAppointmentType = leoAppointmentType;
        _patient = patient;
        _provider = provider;
        _familyID = familyID;
        _bookedByUser = bookedByUser;
        _state = state;
    }
    
    return self;
}

- (instancetype)initWithJSONDictionary:(nonnull NSDictionary *)jsonResponse {
    
    NSDate *date = jsonResponse[APIParamApptDate];
    id leoAppointmentType = jsonResponse[APIParamApptType];
    
    LEOCoreDataManager *coreDataManager = [LEOCoreDataManager sharedManager];
    
    User *patient = [coreDataManager objectWithObjectID:jsonResponse[APIParamPatientID] objectArray:coreDataManager.users];
    User *provider = [coreDataManager objectWithObjectID:jsonResponse[APIParamProviderID] objectArray:coreDataManager.users];
    User *bookedByUser = [coreDataManager objectWithObjectID:jsonResponse[APIParamBookedByUserID] objectArray:coreDataManager.users];
    NSString *familyID = jsonResponse[APIParamUserFamilyID];
    NSNumber *state = jsonResponse[APIParamState];
    
    return [self initWithDate:date appointmentType:leoAppointmentType patient:patient provider:provider familyID:familyID bookedByUser:bookedByUser state:state];
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
