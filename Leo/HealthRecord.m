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

@implementation HealthRecord {

    NSMutableArray *_notes;
}

-(instancetype)initWithAllergies:(NSArray<Allergy *> *)allergies medications:(NSArray<Medication *> *)medications immunizations:(NSArray<Immunization *> *)immunizations bmis:(NSArray<PatientVitalMeasurementBMI *> *)bmis heights:(NSArray<PatientVitalMeasurementHeight *> *)heights weights:(NSArray<PatientVitalMeasurementWeight *> *)weights notes:(NSArray<PatientNote *> *)notes {

    self = [super init];
    if (self) {

        _allergies = allergies;
        _medications = medications;
        _immunizations = immunizations;
        _bmis = bmis;
        _heights = heights;
        _weights = weights;
        _notes = [notes mutableCopy];
    }
    return self;
}

-(instancetype)initWithJSONDictionary:(NSDictionary *)jsonDictionary {
    // TODO: implement when the API is updated to support a single PHR request
    return nil;
}

+ (instancetype)mockObject {

    return [[HealthRecord alloc] initWithAllergies:@[[Allergy mockObject]] medications:@[[Medication mockObject]] immunizations:@[[Immunization mockObject]] bmis:@[[PatientVitalMeasurementBMI mockObject]] heights:@[[PatientVitalMeasurementHeight mockObject]] weights:@[[PatientVitalMeasurementWeight mockObject]] notes:@[[PatientNote mockObject]]];
}

- (void)addNotesObject:(PatientNote *)object {
    [_notes addObject:object];
}

- (void)setNotes:(NSArray<PatientNote *> *)notes {
    _notes = [notes mutableCopy];
}

- (void)removeNotesObject:(PatientNote *)object {
    [_notes removeObject:object];
}

- (NSArray<PatientNote *> *)notes {
    return [_notes copy];
}

@end
