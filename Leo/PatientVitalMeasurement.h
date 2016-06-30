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

typedef NS_ENUM(NSInteger, PatientVitalMeasurementType) {

    PatientVitalMeasurementTypeBMI,
    PatientVitalMeasurementTypeHeight,
    PatientVitalMeasurementTypeWeight,
};

@property (strong, nonatomic) NSDate *takenAt;
@property (strong, nonatomic) NSNumber *takenAtSince;
@property (strong, nonatomic) NSNumber *value;
@property (strong, nonatomic) NSNumber *percentile;
@property (copy, nonatomic) NSString *unit;
@property (copy, nonatomic) NSString *valueAndUnitFormatted;
@property (nonatomic) PatientVitalMeasurementType measurementType;

- (instancetype)initWithTakenAt:(NSDate *)takenAt
                          value:(NSNumber *)value
                     percentile:(NSNumber *)percentile
                           unit:(NSString *)unit
                measurementType:(PatientVitalMeasurementType)measurementType
          valueAndUnitFormatted:(NSString *)valueAndUnitFormatted;
- (instancetype)initWithJSONDictionary:(NSDictionary *)jsonDictionary;
+ (NSArray *)patientVitalsFromDictionaries:(NSArray *)dictionaries;

- (NSNumber *)takenAtInTimeUnits:(LEOTimeUnit)timeUnit sinceBirthOfPatient:(Patient *)patient;
- (void)setTakenAtSinceBasedOnTakenAtInUnits:(LEOTimeUnit)timeUnit sinceBirthOfPatient:(Patient *)patient;

NS_ASSUME_NONNULL_END
@end
