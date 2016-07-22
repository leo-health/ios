//
//  InsurancePlan.m
//  Leo
//
//  Created by Zachary Drossman on 9/3/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import "InsurancePlan.h"
#import "Insurer.h"
#import "NSDictionary+Extensions.h"

@implementation InsurancePlan

- (instancetype)initWithObjectID:(NSString *)objectID insurerID:(NSString *)insurerID insurerName:(NSString *)insurerName name:(NSString *)name {

    self = [super init];

    if (self) {
        _objectID = objectID;
        _insurerID = insurerID;
        _insurerName = insurerName;
        _name = name;
    }

    return self;
}

/**
 *  Initializer to turn json data into an insurer object
 *
 *  @param jsonDictionary JSON data to be turned into an insurer object
 *
 *  @note Not yet supported by API because `supported` is not yet supported.
 *
 *  @return instance of Insurer
 */
- (instancetype)initWithJSONDictionary:(NSDictionary *)jsonDictionary {

    if (!jsonDictionary) {
        return nil;
    }

    NSString *objectID = [[jsonDictionary leo_itemForKey:APIParamID] stringValue];
    NSString *name = [jsonDictionary leo_itemForKey:APIParamPlanName];
    NSString *insurerID = [jsonDictionary leo_itemForKey:APIParamInsurerID];
    NSString *insurerName = [jsonDictionary leo_itemForKey:APIParamInsurerName];

    return [self initWithObjectID:objectID insurerID:insurerID insurerName:insurerName name:name];
}

+ (NSDictionary *)serializeToJSON:(InsurancePlan *)insurancePlan {

    if (!insurancePlan) {
        return nil;
    }

    NSMutableDictionary *insurancePlanDictionary = [[NSMutableDictionary alloc] init];

    insurancePlanDictionary[APIParamPlanName] = insurancePlan.name;
    insurancePlanDictionary[APIParamInsurerName] = insurancePlan.insurerName;
    insurancePlanDictionary[APIParamInsurerID] = insurancePlan.insurerID;
    insurancePlanDictionary[APIParamID] = insurancePlan.objectID;

    return insurancePlanDictionary;
}

-(NSString *)combinedName {

    return [NSString stringWithFormat:@"%@ %@",self.insurerName, self.name];
}

-(id)copyWithZone:(NSZone *)zone {

    InsurancePlan *insurancePlan = [self initWithObjectID:[self.objectID copy] insurerID:[self.insurerID copy] insurerName:[self.insurerName copy] name:[self.name copy]];

    return  insurancePlan;
}

@end
