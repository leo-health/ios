//
//  Medication.m
//  Leo
//
//  Created by Adam Fanslau on 1/6/16.
//  Copyright © 2016 Leo Health. All rights reserved.
//

#import "Medication.h"
#import "NSDictionary+Additions.h"
#import "LEOConstants.h"

@implementation Medication

-(instancetype)initWithStartedAt:(NSDate *)startedAt enteredAt:(NSDate *)enteredAt medication:(NSString *)medication sig:(NSString *)sig note:(NSString *)note dose:(NSString *)dose route:(NSString *)route frequency:(NSString *)frequency {

    self = [super init];
    if (self) {

        _startedAt = startedAt;
        _enteredAt = enteredAt;
        _medication = medication;
        _sig = sig;
        _note = note;
        _dose = dose;
        _route = route;
        _frequency = frequency;
    }
    return self;
}

-(instancetype)initWithJSONDictionary:(NSDictionary *)jsonDictionary {

    NSDate *startedAt = [jsonDictionary leo_itemForKey:APIParamMedicationStartedAt];
    NSDate *enteredAt = [jsonDictionary leo_itemForKey:APIParamMedicationEnteredAt];
    NSString *medication = [jsonDictionary leo_itemForKey:APIParamMedicationMedication];
    NSString *sig = [jsonDictionary leo_itemForKey:APIParamMedicationSig];
    NSString *note = [jsonDictionary leo_itemForKey:APIParamMedicationNote];
    NSString *dose = [jsonDictionary leo_itemForKey:APIParamMedicationDose];
    NSString *route = [jsonDictionary leo_itemForKey:APIParamMedicationRoute];
    NSString *frequency = [jsonDictionary leo_itemForKey:APIParamMedicationFrequency];
    return [self initWithStartedAt:startedAt enteredAt:enteredAt medication:medication sig:sig note:note dose:dose route:route frequency:frequency];
}

+(NSArray *)medicationsFromDictionaries:(NSArray *)dictionaries {
    NSMutableArray *array = [NSMutableArray new];
    for (NSDictionary *dict in dictionaries) {
        [array addObject:[[self alloc] initWithJSONDictionary:dict]];
    }
    return [array copy];
}


@end
