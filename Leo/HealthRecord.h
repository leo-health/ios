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

@property (strong, nonatomic) NSArray<Allergy*>* allergies;
@property (strong, nonatomic) NSArray<Medication*>* medications;
@property (strong, nonatomic) NSArray<Immunization*>* immunizations;
@property (strong, nonatomic) NSArray<PatientVitalMeasurementBMI*>* bmis;
@property (strong, nonatomic) NSArray<PatientVitalMeasurementHeight*>* heights;
@property (strong, nonatomic) NSArray<PatientVitalMeasurementWeight*>* weights;
@property (strong, nonatomic) NSArray<PatientNote*>* notes;

-(instancetype)initWithAllergies:(NSArray<Allergy*> *)allergies medications:(NSArray<Medication*> *)medications immunizations:(NSArray<Immunization*> *)immunizations bmis:(NSArray<PatientVitalMeasurementBMI*> *)bmis heights:(NSArray<PatientVitalMeasurementHeight*>*)heights weights:(NSArray<PatientVitalMeasurementWeight*> *)weights notes:(NSArray<PatientNote*> *)notes;
-(instancetype)initWithJSONDictionary:(NSDictionary *)jsonDictionary;

@end
