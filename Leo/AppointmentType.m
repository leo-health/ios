//
//  AppointmentType.m
//  Leo
//
//  Created by Zachary Drossman on 6/16/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import "AppointmentType.h"
#import "LEOConstants.h"

@implementation AppointmentType

- (instancetype)initWithObjectID:(NSString *)objectID type:(NSString *)type duration:(nullable NSNumber *)duration typeDescription:(NSString *)typeDescription {

    self = [super init];
    if (self) {
        _objectID = objectID;
        _type = type;
        _duration = duration;
        _typeDescription = typeDescription;
    }
    
    return self;
}

- (instancetype)initWithJSONDictionary:(NSDictionary *)jsonResponse {
    
    NSString *objectID = [jsonResponse[APIParamID] stringValue];
    NSString *type = jsonResponse[@"name"];
    NSNumber *duration = jsonResponse[@"duration"]; //Add LEOConstant instead of hardcoding this.
    NSString *typeDescription = jsonResponse[@"description"];
    
    return [self initWithObjectID:objectID type:type duration:duration typeDescription:typeDescription];
}


- (NSString *)description {
    return [NSString stringWithFormat:@"<Appointment: %p> id: %@ descriptor: %@", self, self.objectID, self.type];
}
@end
