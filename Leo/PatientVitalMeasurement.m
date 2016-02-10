//
//  PatientVitalMeasurement.m
//  Leo
//
//  Created by Adam Fanslau on 1/6/16.
//  Copyright © 2016 Leo Health. All rights reserved.
//

#import "PatientVitalMeasurement.h"
#import "NSDictionary+Additions.h"
#import "NSDate+Extensions.h"
#import "LEOConstants.h"

@implementation PatientVitalMeasurement

- (instancetype)initWithTakenAt:(NSDate *)takenAt value:(NSString *)value percentile:(NSString *)percentile measurementType:(PatientVitalMeasurementType)measurementType {

    self = [super init];
    if (self) {

        _takenAt = takenAt;
        _value = value;
        _percentile = percentile;
        _measurementType = measurementType;
    }

    return self;
}

- (instancetype)initWithJSONDictionary:(NSDictionary *)jsonDictionary {

    NSDate *takenAt = [NSDate leo_dateFromDateTimeString:[jsonDictionary leo_itemForKey:APIParamVitalMeasurementTakenAt]];
    NSString *value = [NSString stringWithFormat:@"%@", [jsonDictionary leo_itemForKey:APIParamVitalMeasurementValue]];
    NSString *percentile = [jsonDictionary leo_itemForKey:APIParamVitalMeasurementPercentile];
    PatientVitalMeasurementType measurementType = [[jsonDictionary leo_itemForKey:APIParamType] integerValue];

    return [self initWithTakenAt:takenAt value:value percentile:percentile measurementType:measurementType];
}

+ (NSArray *)patientVitalsFromDictionaries:(NSArray *)dictionaries {

    NSMutableArray *array = [NSMutableArray new];

    for (NSDictionary *dict in dictionaries) {
        [array addObject:[[self alloc] initWithJSONDictionary:dict]];
    }

    return [array copy];
}

+ (instancetype)mockObject {
    
    return [[self alloc] initWithJSONDictionary:@{
        @"taken_at": @"2016-01-04T12:00:59-05:00",
        @"value": @0.016,
        @"percentile": @"42nd percentile"
        }];
}


@end
