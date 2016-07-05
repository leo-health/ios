//
//  HealthRecord.m
//  Leo
//
//  Created by Adam Fanslau on 1/6/16.
//  Copyright © 2016 Leo Health. All rights reserved.
//

#import "HealthRecord.h"
#import "NSDictionary+Extensions.h"
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
        _timeSeries = @[weights, heights, bmis];
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

- (BOOL)hasSingleVitalMeasurement {

    return self.bmis.count == 1 || self.heights.count == 1 || self.weights.count == 1;
}

- (BOOL)hasNoVitalMeasurement {
    return self.bmis.count == 0 || self.heights.count == 0 || self.weights.count == 0;
}

- (BOOL)hasManyVitalMeasurements {
    return self.bmis.count > 1 || self.heights.count > 1 || self.weights.count > 1;
}

/**
 *  If any data fields comes back from the API, the health record exists.
 *
 *  @return BOOL existence of health record
 */
- (BOOL)containsData {

    return (self.weights.count ||
            self.heights.count ||
            self.bmis.count ||
            self.allergies.count ||
            self.medications.count ||
            self.immunizations.count);
}

- (BOOL)containsNoData {
    return !(self.weights.count ||
             self.heights.count ||
             self.bmis.count ||
             self.allergies.count ||
             self.medications.count ||
             self.immunizations.count) && self;
}

@end
