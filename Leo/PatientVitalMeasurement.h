//
//  PatientVitalMeasurement.h
//  Leo
//
//  Created by Adam Fanslau on 1/6/16.
//  Copyright © 2016 Leo Health. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PatientVitalMeasurement : NSObject

NS_ASSUME_NONNULL_BEGIN

typedef PatientVitalMeasurement PatientVitalMeasurementBMI;
typedef PatientVitalMeasurement PatientVitalMeasurementHeight;
typedef PatientVitalMeasurement PatientVitalMeasurementWeight;

@property (strong, nonatomic) NSDate *takenAt;
@property (copy, nonatomic) NSString *value;
@property (copy, nonatomic) NSString *percentile;

-(instancetype)initWithTakenAt:(NSDate *)takenAT value:(NSNumber *)value percentile:(NSNumber *)percentile;
-(instancetype)initWithJSONDictionary:(NSDictionary *)jsonDictionary;
+(NSArray *)patientVitalsFromDictionaries:(NSArray *)dictionaries;
+(instancetype)mockObject;

NS_ASSUME_NONNULL_END


@end
