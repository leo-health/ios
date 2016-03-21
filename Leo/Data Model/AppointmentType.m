//
//  AppointmentType.m
//  Leo
//
//  Created by Zachary Drossman on 6/16/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import "AppointmentType.h"
#import "NSDictionary+Extensions.h"

@implementation AppointmentType

- (instancetype)initWithObjectID:(NSString *)objectID name:(NSString *)name typeCode:(AppointmentTypeCode)typeCode duration:(nullable NSNumber *)duration longDescription:(NSString *)longDescription shortDescription:(NSString *)shortDescription {

    self = [super init];
    if (self) {
        _objectID = objectID;
        _name = name;
        _duration = duration;
        _typeCode = typeCode;
        _longDescription = longDescription;
        _shortDescription = shortDescription;
        
    }
    
    return self;
}

- (instancetype)initWithJSONDictionary:(NSDictionary *)jsonResponse {
    
    NSString *objectID = [[jsonResponse leo_itemForKey:APIParamID] stringValue];
    NSString *name = [jsonResponse leo_itemForKey:APIParamName];
    AppointmentTypeCode typeCode = [[jsonResponse leo_itemForKey:APIParamAppointmentTypeID] integerValue];
    NSNumber *duration = [jsonResponse leo_itemForKey:APIParamAppointmentTypeDuration]; //Add LEOConstant instead of hardcoding this.
    NSString *longDescription = [jsonResponse leo_itemForKey:APIParamAppointmentTypeLongDescription];
    NSString *shortDescription = [jsonResponse leo_itemForKey:APIParamAppointmentTypeShortDescription];

    return [self initWithObjectID:objectID name:name typeCode:typeCode duration:duration longDescription:longDescription shortDescription:shortDescription];
}


- (NSString *)description {
    return [NSString stringWithFormat:@"<AppointmentType: %p> id: %lu descriptor: %@", self, (unsigned long)self.typeCode, self.name];
}

@end
