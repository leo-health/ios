//
//  PatientVitalMeasurement.h
//  Leo
//
//  Created by Adam Fanslau on 1/6/16.
//  Copyright © 2016 Leo Health. All rights reserved.
//

@class Patient;

#import <Foundation/Foundation.h>

#import "NSDate+Extensions.h"


@interface PatientVitalMeasurement : NSObject

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, LEOPatientVitalMeasurementType) {

    LEOPatientVitalMeasurementTypeUnknown,
    LEOPatientVitalMeasurementTypeBMI,
    LEOPatientVitalMeasurementTypeHeight,
    LEOPatientVitalMeasurementTypeWeight,
};

@property (strong, nonatomic) NSDate *takenAt;
@property (strong, nonatomic) NSNumber *takenAtSince;
@property (strong, nonatomic) NSNumber *value;
@property (strong, nonatomic) NSNumber *percentile;
@property (copy, nonatomic) NSString *unit;
@property (copy, nonatomic) NSString *valueAndUnitFormatted;
@property (nonatomic) LEOPatientVitalMeasurementType measurementType;
@property (copy, nonatomic) NSArray *formattedValues;
@property (copy, nonatomic) NSArray *formattedUnits;

- (instancetype)initWithTakenAt:(NSDate *)takenAt
                          value:(NSNumber *)value
                     percentile:(NSNumber *)percentile
                           unit:(NSString *)unit
                measurementType:(LEOPatientVitalMeasurementType)measurementType
          valueAndUnitFormatted:(NSString *)valueAndUnitFormatted
                formattedValues:(NSArray *)formattedValues
                 formattedUnits:(NSArray *)formattedUnits;

- (instancetype)initWithJSONDictionary:(NSDictionary *)jsonDictionary;
+ (NSArray *)patientVitalsFromDictionaries:(NSArray *)dictionaries;

- (NSDictionary *)takenAtInAppropriateTimeUnitsSinceBirthOfPatient:(nonnull NSDate *)dob;
- (NSString *)percentileWithSuffix;

+ (NSString *)stringFromMeasurementType:(LEOPatientVitalMeasurementType)measurementType;
+ (LEOPatientVitalMeasurementType)measurementTypeFromString:(NSString *)measurementTypeString;

NS_ASSUME_NONNULL_END
@end
