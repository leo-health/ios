//
//  InsurancePlan.m
//  Leo
//
//  Created by Zachary Drossman on 9/3/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import "InsurancePlan.h"
#import "Insurer.h"

@implementation InsurancePlan

- (instancetype)initWithObjectID:(NSString *)objectID insurerID:(NSString *)insurerID insurerName:(NSString *)insurerName name:(NSString *)name supported:(BOOL)supported {
    
    self = [super init];
    
    if (self) {
        _objectID = objectID;
        _insurerID = insurerID;
        _insurerName = insurerName;
        _name = name;
        _supported = supported;
    }
    
    return self;
}

/**
 *  Convenience initializer for supported insurers and plans
 *
 *  @param objectID NSString unique id of plan
 *  @param insurer  Insurer plan provider
 *  @param name     NSString name of plan
 *
 *  @return returns an instance of the insurance plan
 */



- (instancetype)initWithObjectID:(NSString *)objectID insurerID:(NSString *)insurerID insurerName:(NSString *)insurerName name:(NSString *)name {

    return [self initWithObjectID:objectID insurerID:insurerID insurerName:insurerName name:name supported:YES];
}


/**
 *  Initializer to turn json data into an insurer object
 *
 *  @param jsonDictionary JSON data to be turned into an insurer object
 *
 *  @return instance of Insurer
 */
- (instancetype)initSupportedPlanWithJSONDictionary:(NSDictionary *)jsonDictionary {
    
    NSString *objectID = [jsonDictionary[APIParamID] stringValue];
    
    NSString *name = jsonDictionary[APIParamPlanName];
    NSString *insurerID = jsonDictionary[APIParamInsurerID];
    NSString *insurerName = jsonDictionary[APIParamInsurerName];
       
    return [self initWithObjectID:objectID insurerID:insurerID insurerName:insurerName name:name];
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
    
    NSString *objectID = [jsonDictionary[APIParamID] stringValue];
    
    NSString *name = jsonDictionary[APIParamName];
    NSString *insurerID = jsonDictionary[APIParamInsurerID];
    NSString *insurerName = jsonDictionary[APIParamInsurerName];

    BOOL supported = jsonDictionary[@"supported"];
    
    return [self initWithObjectID:objectID insurerID:insurerID insurerName:insurerName name:name supported:supported];
}

+ (NSDictionary *)dictionaryFromInsurancePlan:(InsurancePlan *)insurancePlan {
    
    NSMutableDictionary *insurancePlanDictionary = [[NSMutableDictionary alloc] init];
    
    insurancePlanDictionary[APIParamName] = insurancePlan.name;
    insurancePlanDictionary[APIParamInsurerID] = insurancePlan.insurerID;
    insurancePlanDictionary[APIParamID] = insurancePlan.objectID;

    return insurancePlanDictionary;
}

@end
