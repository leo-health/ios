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

- (instancetype)initWithID:(NSString *)id typeDescriptor:(NSString *)typeDescriptor duration:(nullable NSNumber *)duration {
    
    self = [super init];
    if (self) {
        _id = id;
        _typeDescriptor = typeDescriptor;
        _duration = duration;
    }
    return self;
    
}

- (instancetype)initWithJSONDictionary:(NSDictionary *)jsonResponse {
    
    NSString *id = jsonResponse[APIParamID];
    NSString *typeDescriptor = jsonResponse[APIParamApptType];
    //TODO: Decide whether to add duration here.
    
    return [self initWithID:id typeDescriptor:typeDescriptor duration:nil];
}
@end
