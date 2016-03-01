//
//  HealthRecord.m
//  Leo
//
//  Created by Adam Fanslau on 1/6/16.
//  Copyright © 2016 Leo Health. All rights reserved.
//

#import "HealthRecord.h"
#import "NSDictionary+Additions.h"
#import "LEOConstants.h"

@implementation HealthRecord

-(instancetype)initWithAllergies:(NSArray<Allergy *> *)allergies medications:(NSArray<Medication *> *)medications immunizations:(NSArray<Immunization *> *)immunizations bmis:(NSArray<PatientVitalMeasurement *> *)bmis heights:(NSArray<PatientVitalMeasurement *> *)heights weights:(NSArray<PatientVitalMeasurement *> *)weights {

    self = [super init];
    
    if (self) {

        _allergies = allergies;
        _medications = medications;
        _immunizations = immunizations;
        _bmis = bmis;
        _heights = heights;
        _weights = weights;
    }

    return self;
}

-(instancetype)initWithJSONDictionary:(NSDictionary *)jsonDictionary {

    NSArray *heights = [PatientVitalMeasurement patientVitalsFromDictionaries:jsonDictionary[APIParamHeights]];

    NSArray *weights = [PatientVitalMeasurement patientVitalsFromDictionaries:jsonDictionary[APIParamWeights]];

    NSArray *bmis = [PatientVitalMeasurement patientVitalsFromDictionaries:jsonDictionary[APIParamBMIs]];

    NSArray *medications = [Medication medicationsFromDictionaries:jsonDictionary[APIParamMedications]];

    NSArray *immunizations = [Immunization immunizationsFromDictionaries:jsonDictionary[APIParamImmunizations]];

    NSArray *allergies = [Allergy allergiesFromDictionaries:jsonDictionary[APIParamAllergies]];

    return [self initWithAllergies:allergies medications:medications immunizations:immunizations bmis:bmis heights:heights weights:weights];
}

+ (instancetype)mockObject {
    return [[HealthRecord alloc] initWithAllergies:@[[Allergy mockObject]] medications:@[[Medication mockObject]] immunizations:@[[Immunization mockObject]] bmis:@[[PatientVitalMeasurement mockObject]] heights:@[[PatientVitalMeasurement mockObject]] weights:@[[PatientVitalMeasurement mockObject]]];
}

@end
