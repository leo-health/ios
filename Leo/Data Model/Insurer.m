//
//  Insurer.m
//  Leo
//
//  Created by Zachary Drossman on 9/3/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import "Insurer.h"
#import "InsurancePlan.h"
#import "NSDictionary+Extensions.h"

@implementation Insurer

- (instancetype)initWithObjectID:(NSString *)objectID
                            name:(NSString *)name
                           plans:(NSArray *)plans {
    
    self = [super init];
    
    if (self) {
        _name = name;
        _objectID = objectID;
        _plans = plans;
    }
    
    return self;
}

- (instancetype)initWithJSONDictionary:(NSDictionary *)jsonDictionary {

    if (!jsonDictionary) {
        return nil;
    }

    NSString *objectID = [[jsonDictionary leo_itemForKey:APIParamID] stringValue];
    NSString *name = [jsonDictionary leo_itemForKey:APIParamInsurerName];

    NSArray *plansJSON = [jsonDictionary leo_itemForKey:APIParamInsurancePlans];
    NSMutableArray *modifiedPlansJSON = [NSMutableArray new];
    for (NSDictionary *planJSON in plansJSON) {
        NSMutableDictionary *modifiedPlanJSON = [planJSON mutableCopy];

        modifiedPlanJSON[APIParamInsurerName] = name;

        [modifiedPlansJSON addObject:[modifiedPlanJSON copy]];
    }
    NSArray *plans = [InsurancePlan deserializeManyFromJSON:[modifiedPlansJSON copy]];

    return [self initWithObjectID:objectID
                             name:name
                            plans:plans];
}

+ (NSDictionary *)serializeToJSON:(Insurer *)object {

    NSMutableDictionary *json = [NSMutableDictionary new];
    json[APIParamID] = object.objectID;
    json[APIParamInsurerName] = object.name;
    json[APIParamInsurancePlans] = [InsurancePlan serializeManyToJSON:object.plans];

    return [json copy];
}

@end
