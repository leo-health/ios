//
//  UserFactory.m
//  Leo
//
//  Created by Zachary Drossman on 11/17/15.
//  Copyright © 2015 Leo Health. All rights reserved.
//

#import "UserFactory.h"
#import "User.h"
#import "Guardian.h"
#import "Patient.h"
#import "Provider.h"
#import "Support.h"
#import "Role.h"

@implementation UserFactory

+ (User *)userFromJSONDictionary:(NSDictionary *)dictionary {
    
    Role *role = [[Role alloc] initWithJSONDictionary:dictionary[APIParamRole]];
    
    switch (role.roleCode) {
            
        case RoleCodeClinical:
        case RoleCodeClinicalSupport:
            return [[Provider alloc] initWithJSONDictionary:dictionary];
            
        case RoleCodeFinancial:
        case RoleCodeCustomerService:
        case RoleCodeOperational:
            return [[Support alloc] initWithJSONDictionary:dictionary];
            
        case RoleCodePatient:
            return [[Patient alloc] initWithJSONDictionary:dictionary];
            
        case RoleCodeGuardian:
            return [[Guardian alloc] initWithJSONDictionary:dictionary];
            
        case RoleCodeUndefined:
        case RoleCodeBot:
            return [[User alloc] initWithJSONDictionary:dictionary];
    }
}

@end
