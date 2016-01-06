//
//  PatientVitalMeasurement.m
//  Leo
//
//  Created by Adam Fanslau on 1/6/16.
//  Copyright © 2016 Leo Health. All rights reserved.
//

#import "PatientVitalMeasurement.h"
#import "NSDictionary+Additions.h"
#import "LEOConstants.h"

@implementation PatientVitalMeasurement

-(instancetype)initWithTakenAt:(NSDate *)takenAT value:(NSNumber *)value percentile:(NSNumber *)percentile {

    self = [super init];
    if (self) {

        _takenAt = takenAT;
        _value = value;
        _percentile = percentile;
    }
    return self;
}

-(instancetype)initWithJSONDictionary:(NSDictionary *)jsonDictionary {

    NSDate *takenAt = [jsonDictionary leo_itemForKey:APIParamVitalMeasurementTakenAt];
    NSNumber *value = [jsonDictionary leo_itemForKey:APIParamVitalMeasurementValue];
    NSNumber *percentile = [jsonDictionary leo_itemForKey:APIParamVitalMeasurementPercentile];
    return [self initWithTakenAt:takenAt value:value percentile:percentile];
}

@end
