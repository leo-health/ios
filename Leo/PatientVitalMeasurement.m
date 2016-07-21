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
#import "NSString+Extensions.h"

@implementation PatientVitalMeasurement

static NSString * const kMonth = @"month";
static NSString * const kMonths = @"months";
static NSString * const kDay = @"day";
static NSString * const kDays = @"days";
static NSString * const kWeeks = @"weeks";
static NSString * const kWeek = @"week";
static NSString * const kYears = @"years";
static NSString * const kYear = @"year";

static NSString * const kMeasurementTypeWeight = @"weight";
static NSString * const kMeasurementTypeHeight = @"height";
static NSString * const kMeasurementTypeUnknown = @"unknown";

- (instancetype)initWithTakenAt:(NSDate *)takenAt
                          value:(NSNumber *)value
                     percentile:(NSNumber *)percentile
                           unit:(NSString *)unit
                measurementType:(LEOPatientVitalMeasurementType)measurementType
          valueAndUnitFormatted:(NSString *)valueAndUnitFormatted
                formattedValues:(NSArray *)formattedValues
                 formattedUnits:(NSArray *)formattedUnits {

    self = [super init];

    if (self) {

        _takenAt = takenAt;
        _value = value;
        _percentile = percentile;
        _measurementType = measurementType;
        _unit = unit;
        _valueAndUnitFormatted = valueAndUnitFormatted;
        _formattedValues = formattedValues;
        _formattedUnits = formattedUnits;
    }

    return self;
}

+ (LEOPatientVitalMeasurementType)measurementTypeFromString:(NSString *)measurementTypeString {

    if ([measurementTypeString isEqualToString:kMeasurementTypeHeight]) {
        return LEOPatientVitalMeasurementTypeHeight;
    }

    if ([measurementTypeString isEqualToString:kMeasurementTypeWeight]) {
        return LEOPatientVitalMeasurementTypeWeight;
    }

    return LEOPatientVitalMeasurementTypeUnknown;
}

+ (NSString *)stringFromMeasurementType:(LEOPatientVitalMeasurementType)measurementType {

    switch (measurementType) {
        case LEOPatientVitalMeasurementTypeHeight:
            return kMeasurementTypeHeight;

        case LEOPatientVitalMeasurementTypeWeight:
            return kMeasurementTypeWeight;

        case LEOPatientVitalMeasurementTypeBMI:
        case LEOPatientVitalMeasurementTypeUnknown:
            break;
    }

    return kMeasurementTypeUnknown;
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

    LEOPatientVitalMeasurementType measurementType = [PatientVitalMeasurement measurementTypeFromString:[jsonDictionary leo_itemForKey:APIParamType]];

    NSArray *formattedValues = [jsonDictionary leo_itemForKey:@"formatted_values"];
    NSArray *formattedUnits = [jsonDictionary leo_itemForKey:@"formatted_units"];

    return [self initWithTakenAt:takenAt value:value percentile:percentile unit:unit measurementType:measurementType valueAndUnitFormatted:valueAndUnitFormatted formattedValues:formattedValues formattedUnits:formattedUnits];
}

+ (NSArray *)patientVitalsFromDictionaries:(NSArray *)dictionaries {

    NSMutableArray *array = [NSMutableArray new];

    for (NSDictionary *dict in dictionaries) {
        [array addObject:[[self alloc] initWithJSONDictionary:dict]];
    }
    
    return [array copy];
}

- (NSDictionary *)takenAtInYearsAndMonthsSinceBirthOfPatient:(NSDate *)dob {

    NSCalendar *gregorian = [[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian];

    // pass as many or as little units as you like here, separated by pipes
    NSUInteger units = NSCalendarUnitYear | NSCalendarUnitMonth;

    NSDateComponents *components = [gregorian components:units fromDate:dob toDate:self.takenAt options:0];

    NSInteger years = [components year];
    NSInteger months = [components month];

    NSString *yearKey = years == 1 ? kYear : kYears;
    NSString *monthKey = months == 1 ? kMonth : kMonths;

    return @{ @"units" : @[yearKey, monthKey] , @"values" : @[@(years), @(months)] };
}

- (NSDictionary *)takenAtInMonthsAndDaysSinceBirthOfPatient:(NSDate *)dob {

    NSCalendar *gregorian = [[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian];

    // pass as many or as little units as you like here, separated by pipes
    NSUInteger units = NSCalendarUnitMonth | NSCalendarUnitDay;

    NSDateComponents *components = [gregorian components:units fromDate:dob toDate:self.takenAt options:0];

    NSInteger months = [components month];
    NSInteger days = [components day];

    NSString *monthKey = months > 1 ? kMonths : kMonth;
    NSString *dayKey = days > 1 ? kDays : kDay;

    return @{ @"units" : @[monthKey, dayKey] , @"values" : @[@(months), @(days)] };
}

- (NSDictionary *)takenAtInWeeksAndDaysSinceBirthOfPatient:(NSDate *)dob {

    NSInteger weeks = [self.takenAt daysFrom:dob] / 7.0;
    NSInteger days = [self.takenAt daysFrom:dob] - (weeks * 7);

    NSString *weekKey = weeks > 1 ? kWeeks : kWeek;
    NSString *dayKey = days > 1 ? kDays : kDay;

    return @{ @"units" : @[weekKey, dayKey] , @"values" : @[@(weeks), @(days)] };
}

- (NSDictionary *)takenAtInDaysOnlySinceBirthOfPatient:(NSDate *)dob {

    NSInteger days = [self.takenAt daysFrom:dob];

    NSString *dayKey = days > 1 ? kDays : kDay;

    return @{ @"units" : @[dayKey] , @"values" : @[@(days)] };
}

- (NSDictionary *)takenAtInAppropriateTimeUnitsSinceBirthOfPatient:(nonnull NSDate *)dob {

    NSInteger years = [[self takenAtInTimeUnits:LEOTimeUnitYears sinceBirthOfPatient:dob] integerValue];

    if (years > 0) {
        return [self takenAtInYearsAndMonthsSinceBirthOfPatient:dob];
    } else {

        NSInteger months = [[self takenAtInTimeUnits:LEOTimeUnitMonths sinceBirthOfPatient:dob] integerValue];

        if (months > 0) {
            return [self takenAtInMonthsAndDaysSinceBirthOfPatient:dob];
        } else {

            NSInteger weeks = [[self takenAtInTimeUnits:LEOTimeUnitWeeks sinceBirthOfPatient:dob] integerValue];

            if (weeks > 0) {
                return [self takenAtInWeeksAndDaysSinceBirthOfPatient:dob];
            } else {

                return [self takenAtInDaysOnlySinceBirthOfPatient:dob];
            }
        }
    }
}

- (void)setTakenAtSinceBasedOnTakenAtInUnits:(LEOTimeUnit)timeUnit sinceBirthOfPatient:(NSDate *)dob {
    _takenAtSince = [self takenAtInTimeUnits:timeUnit sinceBirthOfPatient:dob];
}

- (NSNumber *)takenAtInTimeUnits:(LEOTimeUnit)timeUnit sinceBirthOfPatient:(NSDate *)dob {
    
    switch (timeUnit) {
        case LEOTimeUnitDays:
            return @([self takenAtInDaysSinceBirthOfPatient:dob]);

        case LEOTimeUnitWeeks:
            return @([self takenAtInWeeksSinceBirthOfPatient:dob]);

        case LEOTimeUnitMonths:
            return @([self takenAtInMonthsSinceBirthOfPatient:dob]);

        case LEOTimeUnitYears:
            return @([self takenAtInYearsSinceBirthOfPatient:dob]);
    }
}

- (NSInteger)takenAtInDaysSinceBirthOfPatient:(NSDate *)dob {
    return [self.takenAt daysFrom:dob];
}

- (NSInteger)takenAtInWeeksSinceBirthOfPatient:(NSDate *)dob {
    return [self.takenAt weeksFrom:dob];
}

- (NSInteger)takenAtInMonthsSinceBirthOfPatient:(NSDate *)dob {
    return [self.takenAt monthsFrom:dob];
}

- (NSInteger)takenAtInYearsSinceBirthOfPatient:(NSDate *)dob {
    return [self.takenAt yearsFrom:dob];
}

- (NSString *)percentileWithSuffix {
    return [NSString stringWithFormat:@"%@%@", self.percentile, [NSString leo_numericSuffix:[self.percentile integerValue]]];
}

@end
