//
//  Allergy.m
//  Leo
//
//  Created by Adam Fanslau on 1/6/16.
//  Copyright © 2016 Leo Health. All rights reserved.
//

#import "Allergy.h"
#import "NSDictionary+Additions.h"
#import "LEOConstants.h"

@implementation Allergy

-(instancetype)initWithOnsetAt:(NSDate *)onsetAt allergen:(NSString *)allergen severity:(NSString *)severity note:(NSString *)note {

    self = [super init];
    if (self) {

        _onsetAt = onsetAt;
        _allergen = allergen;
        _severity = severity;
        _note = note;
    }
    return self;
}

-(instancetype)initWithJSONDictionary:(NSDictionary *)jsonDictionary {

    NSDate *onsetAt = [jsonDictionary leo_itemForKey:APIParamAllergyOnsetAt];
    NSString *allergen = [jsonDictionary leo_itemForKey:APIParamAllergyAllergen];
    NSString *severity = [jsonDictionary leo_itemForKey:APIParamAllergySeverity];
    NSString *note = [jsonDictionary leo_itemForKey:APIParamAllergyNote];
    return [self initWithOnsetAt:onsetAt allergen:allergen severity:severity note:note];
}

+(instancetype)mockObject {
    return [[self alloc] initWithOnsetAt:[NSDate date] allergen:@"Peanuts" severity:@"High" note:@"note"];
}

+(NSArray *)allergiesFromDictionaries:(NSArray *)dictionaries {
    NSMutableArray *array = [NSMutableArray new];
    for (NSDictionary *dict in dictionaries) {
        [array addObject:[[self alloc] initWithJSONDictionary:dict]];
    }
    return [array copy];
}


@end
