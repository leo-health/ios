//
//  Immunization.m
//  Leo
//
//  Created by Adam Fanslau on 1/6/16.
//  Copyright © 2016 Leo Health. All rights reserved.
//

#import "Immunization.h"
#import "NSDictionary+Extensions.h"
#import "NSDate+Extensions.h"
#import "LEOConstants.h"

@implementation Immunization

-(instancetype)initWithAdministeredAt:(NSDate *)administeredAt vaccine:(NSString *)vaccine {

    self = [super init];
    if (self) {

        _administeredAt = administeredAt;
        _vaccine = vaccine;
    }
    return self;
}

-(instancetype)initWithJSONDictionary:(NSDictionary *)jsonDictionary {

    if (!jsonDictionary) {
        return nil;
    }

    NSDate *administeredAt = [NSDate leo_dateFromAthenaDateTimeString:[jsonDictionary leo_itemForKey:APIParamImmunizationAdministeredAt]];
    NSString *vaccine = [jsonDictionary leo_itemForKey:APIParamImmunizationVaccine];
    return [self initWithAdministeredAt:administeredAt vaccine:vaccine];
}

+(NSArray *)immunizationsFromDictionaries:(NSArray *)dictionaries {
    NSMutableArray *array = [NSMutableArray new];
    for (NSDictionary *dict in dictionaries) {
        [array addObject:[[self alloc] initWithJSONDictionary:dict]];
    }
    return [array copy];
}


@end
