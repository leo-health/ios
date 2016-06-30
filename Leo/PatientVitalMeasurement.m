//
//  PatientVitalMeasurement.m
//  Leo
//
//  Created by Adam Fanslau on 1/6/16.
//  Copyright © 2016 Leo Health. All rights reserved.
//

#import "PatientVitalMeasurement.h"
#import "NSDictionary+Extensions.h"
#import "LEOConstants.h"
#import <NSDate+DateTools.h>
#import "Patient.h"

@implementation PatientVitalMeasurement

- (instancetype)initWithTakenAt:(NSDate *)takenAt value:(NSNumber *)value percentile:(NSNumber *)percentile unit:(NSString*)unit measurementType:(PatientVitalMeasurementType)measurementType valueAndUnitFormatted:(NSString*)valueAndUnitFormatted {

    self = [super init];
    if (self) {

        _takenAt = takenAt;
        _value = value;
        _percentile = percentile;
        _measurementType = measurementType;
        _unit = unit;
        _valueAndUnitFormatted = valueAndUnitFormatted;
    }

    return self;
}

- (instancetype)initWithJSONDictionary:(NSDictionary *)jsonDictionary {

    //The backend should really decide on a format and stick with it, but for now, this uses a different method than slots to convert the string to a date.
    NSDate *takenAt = [NSDate leo_dateFromAthenaDateTimeString:[jsonDictionary leo_itemForKey:APIParamVitalMeasurementTakenAt]];

    NSString *valueString = [NSString stringWithFormat:@"%@", [jsonDictionary leo_itemForKey:APIParamVitalMeasurementValue]];
    NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
    f.numberStyle = NSNumberFormatterDecimalStyle;
    NSNumber *value = [f numberFromString:valueString];

    NSString *unit = [NSString stringWithFormat:@"%@", [jsonDictionary leo_itemForKey:APIParamVitalMeasurementUnit]];
    NSString *valueAndUnitFormatted = [jsonDictionary leo_itemForKey:APIParamVitalMeasurementFormattedValueAndUnit];

    NSNumber *percentile = [jsonDictionary leo_itemForKey:APIParamVitalMeasurementPercentile];

    PatientVitalMeasurementType measurementType = [[jsonDictionary leo_itemForKey:APIParamType] integerValue];

    return [self initWithTakenAt:takenAt value:value percentile:percentile unit:unit measurementType:measurementType valueAndUnitFormatted:valueAndUnitFormatted];
}

+ (NSArray *)patientVitalsFromDictionaries:(NSArray *)dictionaries {

    NSMutableArray *array = [NSMutableArray new];

    for (NSDictionary *dict in dictionaries) {
        [array addObject:[[self alloc] initWithJSONDictionary:dict]];
    }

    return [array copy];
}

- (void)setTakenAtSinceBasedOnTakenAtInUnits:(LEOTimeUnit)timeUnit sinceBirthOfPatient:(Patient *)patient {
    _takenAtSince = [self takenAtInTimeUnits:timeUnit sinceBirthOfPatient:patient];
}

- (NSNumber *)takenAtInTimeUnits:(LEOTimeUnit)timeUnit sinceBirthOfPatient:(Patient *)patient {

    switch (timeUnit) {
        case LEOTimeUnitDays:
            return @([self takenAtInDaysSinceBirthOfPatient:patient]);

        case LEOTimeUnitWeeks:
            return @([self takenAtInWeeksSinceBirthOfPatient:patient]);

        case LEOTimeUnitMonths:
            return @([self takenAtInMonthsSinceBirthOfPatient:patient]);

        case LEOTimeUnitYears:
            return @([self takenAtInYearsSinceBirthOfPatient:patient]);
    }
}

- (NSInteger)takenAtInDaysSinceBirthOfPatient:(Patient *)patient {
    return [self.takenAt daysFrom:patient.dob];
}

- (CGFloat)takenAtInWeeksSinceBirthOfPatient:(Patient *)patient {
    return [self.takenAt daysFrom:patient.dob] / 7.0;
}

- (CGFloat)takenAtInMonthsSinceBirthOfPatient:(Patient *)patient {
    return [self.takenAt daysFrom:patient.dob] / 30.0 ;
}

- (CGFloat)takenAtInYearsSinceBirthOfPatient:(Patient *)patient {
    return [self.takenAt daysFrom:patient.dob] / 365.0;
}

@end
