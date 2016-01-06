//
//  PatientVitalMeasurement.h
//  Leo
//
//  Created by Adam Fanslau on 1/6/16.
//  Copyright © 2016 Leo Health. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PatientVitalMeasurement : NSObject

typedef PatientVitalMeasurement PatientVitalMeasurementBMI;
typedef PatientVitalMeasurement PatientVitalMeasurementHeight;
typedef PatientVitalMeasurement PatientVitalMeasurementWeight;

@property (strong, nonatomic) NSDate *takenAt;
@property (strong, nonatomic) NSNumber *value;
@property (strong, nonatomic) NSNumber *percentile;

-(instancetype)initWithTakenAt:(NSDate *)takenAT value:(NSNumber *)value percentile:(NSNumber *)percentile;
-(instancetype)initWithJSONDictionary:(NSDictionary *)jsonDictionary;

@end
