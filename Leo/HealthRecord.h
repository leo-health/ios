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
#import "PatientNote.h"

@interface HealthRecord : NSObject

NS_ASSUME_NONNULL_BEGIN

@property (copy, nonatomic) NSArray<Allergy*>* allergies;
@property (copy, nonatomic) NSArray<Medication*>* medications;
@property (copy, nonatomic) NSArray<Immunization*>* immunizations;
@property (copy, nonatomic) NSArray<PatientVitalMeasurementBMI*>* bmis;
@property (copy, nonatomic) NSArray<PatientVitalMeasurementHeight*>* heights;
@property (copy, nonatomic) NSArray<PatientVitalMeasurementWeight*>* weights;
@property (strong, nonatomic) NSMutableArray<PatientNote*>* notes;

-(instancetype)initWithAllergies:(NSArray<Allergy*> *)allergies medications:(NSArray<Medication*> *)medications immunizations:(NSArray<Immunization*> *)immunizations bmis:(NSArray<PatientVitalMeasurementBMI*> *)bmis heights:(NSArray<PatientVitalMeasurementHeight*>*)heights weights:(NSArray<PatientVitalMeasurementWeight*> *)weights notes:(NSArray<PatientNote*> *)notes;
-(instancetype)initWithJSONDictionary:(NSDictionary *)jsonDictionary;
+(instancetype)mockObject;

NS_ASSUME_NONNULL_END

@end
