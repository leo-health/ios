//
//  HealthRecord.h
//  Leo
//
//  Created by Adam Fanslau on 1/6/16.
//  Copyright © 2016 Leo Health. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Allergy.h"
#import "PatientVitalMeasurement.h"
#import "Immunization.h"
#import "Medication.h"

@interface HealthRecord : NSObject
NS_ASSUME_NONNULL_BEGIN

@property (copy, nonatomic) NSArray<Allergy*>* allergies;
@property (copy, nonatomic) NSArray<Medication*>* medications;
@property (copy, nonatomic) NSArray<Immunization*>* immunizations;
@property (copy, nonatomic) NSArray<PatientVitalMeasurement*>* bmis;
@property (copy, nonatomic) NSArray<PatientVitalMeasurement*>* heights;
@property (copy, nonatomic) NSArray<PatientVitalMeasurement*>* weights;
@property (copy, nonatomic) NSArray *timeSeries;

-(instancetype)initWithAllergies:(NSArray<Allergy*> *)allergies medications:(NSArray<Medication*> *)medications immunizations:(NSArray<Immunization*> *)immunizations bmis:(NSArray<PatientVitalMeasurement*> *)bmis heights:(NSArray<PatientVitalMeasurement*>*)heights weights:(NSArray<PatientVitalMeasurement*> *)weights;
-(instancetype)initWithJSONDictionary:(NSDictionary *)jsonDictionary;

- (BOOL)hasSingleVitalMeasurement;
- (BOOL)hasNoVitalMeasurement;

NS_ASSUME_NONNULL_END
@end
