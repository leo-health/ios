//
//  Insurer.m
//  Leo
//
//  Created by Zachary Drossman on 9/3/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import "Insurer.h"
#import "InsurancePlan.h"

@implementation Insurer

- (instancetype)initWithObjectID:(NSString *)objectID name:(NSString *)name plans:(NSArray *)plans {
    
    self = [super init];
    
    if (self) {
        _name = name;
        _objectID = objectID;
        _plans = plans;
    }
    
    return self;
}

- (instancetype)initWithJSONDictionary:(NSDictionary *)jsonDictionary {

    NSString *objectID = [jsonDictionary[APIParamID] stringValue];
    NSString *name = jsonDictionary[APIParamInsurerName];
    
    NSMutableArray *mutablePlans = [[NSMutableArray alloc] init];
    
    for (NSDictionary *planDictionary in jsonDictionary[APIParamInsurancePlans]) {
        
        NSMutableDictionary *mutablePlanDictionary = [planDictionary mutableCopy];
        [mutablePlanDictionary setValue:name forKey:APIParamInsurerName];
        InsurancePlan *plan = [[InsurancePlan alloc] initSupportedPlanWithJSONDictionary:mutablePlanDictionary];
        [mutablePlans addObject:plan];
    }

    return [self initWithObjectID:objectID name:name plans:[mutablePlans copy]];
}

@end
