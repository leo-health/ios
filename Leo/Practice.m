//
//  Practice.m
//  Leo
//
//  Created by Zachary Drossman on 7/2/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import "Practice.h"
#import "LEOConstants.h"
#import "Provider.h"
#import "Support.h"

@implementation Practice

- (instancetype)initWithObjectID:(NSString *)objectID providers:(NSArray *)providers staff:(NSArray *)staff addressLine1:(NSString *)addressLine1 addressLine2:(NSString *)addressLine2 city:(NSString *)city state:(NSString *)state zip:(NSString *)zip phone:(NSString *)phone email:(NSString *)email {

    self = [super init];
    
    if (self) {
        _objectID = objectID;
        _providers = providers;
        _staff = staff;
        _addressLine1 = addressLine1;
        _addressLine2 = addressLine2;
        _city = city;
        _state = state;
        _zip = zip;
        _phone = phone;
        _email = email;
    }
    
    return self;
}

- (instancetype)initWithJSONDictionary:(NSDictionary *)jsonResponse {
    
    NSString *objectID = [jsonResponse[APIParamID] stringValue];
    
    NSArray *providerDictionaries = jsonResponse[APIParamUserProviders];

    NSMutableArray *providers = [[NSMutableArray alloc] init];
    
    for (NSDictionary *providerDictionary in providerDictionaries) {
        
        Provider *provider = [[Provider alloc] initWithJSONDictionary:providerDictionary];
        [providers addObject:provider];
    }
    
    NSArray *supportDictionaries = jsonResponse[APIParamUserSupports];

    NSMutableArray *supportStaff = [[NSMutableArray alloc] init];

    for (NSDictionary *supportDictionary in supportDictionaries) {
        
        Support *support = [[Support alloc] initWithJSONDictionary:supportDictionary];
        [supportStaff addObject:support];
    }
    
    NSString *addressLine1 = jsonResponse[APIParamPracticeLocationAddressLine1];
    NSString *addressLine2 = jsonResponse[APIParamPracticeLocationAddressLine2];
    NSString *city = jsonResponse[APIParamPracticeLocationCity];
    NSString *state = jsonResponse[APIParamPracticeLocationState];
    NSString *zip = jsonResponse[APIParamPracticeLocationZip];
    NSString *phone = jsonResponse[APIParamPracticePhone];
    NSString *email = jsonResponse[APIParamPracticeEmail];
    
    //FIXME: Need to get APIParams for above to complete this and remove warning.
    return [self initWithObjectID:objectID providers:[providers copy] staff:supportStaff addressLine1:addressLine1 addressLine2:addressLine2 city:city state:state zip:zip phone:phone email:email];
}

- (id)initWithCoder:(NSCoder *)decoder {
    
    NSString *objectID = [decoder decodeObjectForKey:APIParamPracticeID];
    NSString *addressLine1 = [decoder decodeObjectForKey:APIParamPracticeLocationAddressLine1];
    NSString *addressLine2 = [decoder decodeObjectForKey:APIParamPracticeLocationAddressLine2];
    NSString *city = [decoder decodeObjectForKey:APIParamPracticeLocationCity];
    NSString *state = [decoder decodeObjectForKey:APIParamPracticeLocationState];
    NSString *zip = [decoder decodeObjectForKey:APIParamPracticeLocationZip];
    NSString *phone = [decoder decodeObjectForKey:APIParamPracticePhone];
    NSString *email = [decoder decodeObjectForKey:APIParamPracticeEmail];
    NSArray *providers = [decoder decodeObjectForKey:APIParamUserProviders];
    NSArray *supportStaff = [decoder decodeObjectForKey:APIParamUserSupports];
    
    return [self initWithObjectID:objectID providers:providers staff:supportStaff addressLine1:addressLine1 addressLine2:addressLine2 city:city state:state zip:zip phone:phone email:email];
}

- (void)encodeWithCoder:(NSCoder *)encoder {
     
    [encoder encodeObject:self.objectID forKey:APIParamID];
    [encoder encodeObject:self.addressLine1 forKey:APIParamPracticeLocationAddressLine1];
    [encoder encodeObject:self.addressLine2 forKey:APIParamPracticeLocationAddressLine2];
    [encoder encodeObject:self.city forKey:APIParamPracticeLocationCity];
    [encoder encodeObject:self.state forKey:APIParamPracticeLocationState];
    [encoder encodeObject:self.zip forKey:APIParamPracticeLocationZip];
    [encoder encodeObject:self.phone forKey:APIParamPracticePhone];
    [encoder encodeObject:self.email forKey:APIParamPracticeEmail];
    [encoder encodeObject:self.providers forKey:APIParamUserProviders];
    [encoder encodeObject:self.staff forKey:APIParamUserSupports];
}

@end
