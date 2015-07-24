//
//  AppointmentType.m
//  Leo
//
//  Created by Zachary Drossman on 6/16/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import "AppointmentType.h"

@implementation AppointmentType

- (instancetype)initWithObjectID:(NSString *)objectID name:(NSString *)name reasonCode:(AppointmentReasonCode)reasonCode duration:(nullable NSNumber *)duration description:(NSString *)fullDescription {
    
    self = [super init];
    if (self) {
        _objectID = objectID;
        _name = name;
        _duration = duration;
        _reasonCode = reasonCode;
        _fullDescription = fullDescription;
    }
    
    return self;
}

- (instancetype)initWithJSONDictionary:(NSDictionary *)jsonResponse {
    
    NSString *objectID = [jsonResponse[APIParamID] stringValue];
    NSString *name = jsonResponse[APIParamName];
    AppointmentReasonCode reasonCode = [jsonResponse[APIParamAppointmentTypeID] integerValue];
    NSNumber *duration = jsonResponse[APIParamAppointmentTypeDuration]; //Add LEOConstant instead of hardcoding this.
    NSString *fullDescription = jsonResponse[APIParamAppointmentTypeBody];
    
    return [self initWithObjectID:objectID name:name reasonCode:reasonCode duration:duration description:fullDescription];
}


- (NSString *)description {
    return [NSString stringWithFormat:@"<Appointment: %p> id: %@ descriptor: %@", self, self.objectID, self.name];
}

@end
