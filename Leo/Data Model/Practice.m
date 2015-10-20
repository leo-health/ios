//
//  Practice.m
//  Leo
//
//  Created by Zachary Drossman on 7/2/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import "Practice.h"
#import "Provider.h"
#import "Support.h"

@implementation Practice

//TODO: Having this and using it in Practice is a code smell. Return to this and determine whether a change to the model might be ideal.
static NSString *const RoleProvider = @"clinical";

- (instancetype)initWithObjectID:(NSString *)objectID name:(NSString *)name staff:(NSArray *)staff addressLine1:(NSString *)addressLine1 addressLine2:(NSString *)addressLine2 city:(NSString *)city state:(NSString *)state zip:(NSString *)zip phone:(NSString *)phone email:(NSString *)email fax:(NSString *)fax {

    self = [super init];
    
    if (self) {
        _objectID = objectID;
        _name = name;
        _staff = staff;
        _addressLine1 = addressLine1;
        _addressLine2 = addressLine2;
        _city = city;
        _state = state;
        _zip = zip;
        _phone = phone;
        _email = email;
        _fax = fax;
    }
    
    return self;
}

- (instancetype)initWithJSONDictionary:(NSDictionary *)jsonResponse {
    
    NSString *objectID = [jsonResponse[APIParamID] stringValue];
    
    NSArray *staffDictionaries = jsonResponse[APIParamUserStaff];

    NSMutableArray *staff = [[NSMutableArray alloc] init];
    
    for (NSDictionary *staffDictionary in staffDictionaries) {
        
        NSString *role = staffDictionary[APIParamRole];
        
        if ([role isEqualToString:RoleProvider]) {
            Provider *provider = [[Provider alloc] initWithJSONDictionary:staffDictionary];
            [staff addObject:provider];
        } else {
            Support *support = [[Support alloc] initWithJSONDictionary:staffDictionary];
            [staff addObject:support];
        }
    }
    
    NSString *name = jsonResponse[APIParamPracticeName];
    NSString *fax = jsonResponse[APIParamPracticeFax];
    
    NSString *addressLine1 = jsonResponse[APIParamPracticeLocationAddressLine1];
    NSString *addressLine2 = jsonResponse[APIParamPracticeLocationAddressLine2];
    NSString *city = jsonResponse[APIParamPracticeLocationCity];
    NSString *state = jsonResponse[APIParamPracticeLocationState];
    NSString *zip = jsonResponse[APIParamPracticeLocationZip];
    NSString *phone = jsonResponse[APIParamPracticePhone];
    NSString *email = jsonResponse[APIParamPracticeEmail];
    
    //FIXME: Need to get APIParams for above to complete this and remove warning.
    return [self initWithObjectID:objectID name:name staff:[staff copy] addressLine1:addressLine1 addressLine2:addressLine2 city:city state:state zip:zip phone:phone email:email fax:fax];
}

- (id)initWithCoder:(NSCoder *)decoder {
    
    NSString *objectID = [decoder decodeObjectForKey:APIParamPracticeID];
    NSString *name = [decoder decodeObjectForKey:APIParamPracticeName];
    NSString *addressLine1 = [decoder decodeObjectForKey:APIParamPracticeLocationAddressLine1];
    NSString *addressLine2 = [decoder decodeObjectForKey:APIParamPracticeLocationAddressLine2];
    NSString *city = [decoder decodeObjectForKey:APIParamPracticeLocationCity];
    NSString *state = [decoder decodeObjectForKey:APIParamPracticeLocationState];
    NSString *zip = [decoder decodeObjectForKey:APIParamPracticeLocationZip];
    NSString *phone = [decoder decodeObjectForKey:APIParamPracticePhone];
    NSString *email = [decoder decodeObjectForKey:APIParamPracticeEmail];
    NSArray *staff = [decoder decodeObjectForKey:APIParamUsers];
    NSString *fax = [decoder decodeObjectForKey:APIParamPracticeFax];
    
    return [self initWithObjectID:objectID name:name staff:[staff copy] addressLine1:addressLine1 addressLine2:addressLine2 city:city state:state zip:zip phone:phone email:email fax:fax];
}

- (void)encodeWithCoder:(NSCoder *)encoder {
     
    [encoder encodeObject:self.objectID forKey:APIParamID];
    [encoder encodeObject:self.name forKey:APIParamPracticeName];
    [encoder encodeObject:self.addressLine1 forKey:APIParamPracticeLocationAddressLine1];
    [encoder encodeObject:self.addressLine2 forKey:APIParamPracticeLocationAddressLine2];
    [encoder encodeObject:self.city forKey:APIParamPracticeLocationCity];
    [encoder encodeObject:self.state forKey:APIParamPracticeLocationState];
    [encoder encodeObject:self.zip forKey:APIParamPracticeLocationZip];
    [encoder encodeObject:self.phone forKey:APIParamPracticePhone];
    [encoder encodeObject:self.email forKey:APIParamPracticeEmail];
    [encoder encodeObject:self.fax forKey:APIParamPracticeFax];
    [encoder encodeObject:self.staff forKey:APIParamUsers];
}

@end
