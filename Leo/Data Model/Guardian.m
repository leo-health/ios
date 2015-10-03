//
//  guardian.m
//  Leo
//
//  Created by Zachary Drossman on 7/2/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import "Guardian.h"

@implementation Guardian


- (instancetype)initWithObjectID:(nullable NSString *)objectID familyID:(NSString *)familyID title:(nullable NSString *)title firstName:(NSString *)firstName middleInitial:(nullable NSString *)middleInitial lastName:(NSString *)lastName suffix:(nullable NSString *)suffix email:(NSString *)email avatarURL:(nullable NSString *)avatarURL avatar:(nullable UIImage *)avatar phoneNumber:(NSString *)phoneNumber insurancePlan:(InsurancePlan *)insurancePlan primary:(BOOL)primary {
    
    self = [super initWithObjectID:objectID title:title firstName:firstName middleInitial:middleInitial lastName:lastName suffix:suffix email:email avatarURL:avatarURL avatar:avatar];
    
    if (self) {
        _familyID = familyID;
        _phoneNumber = phoneNumber;
        _insurancePlan = insurancePlan;
        _primary = primary;
    }
    
    return self;
}

- (instancetype)initWithJSONDictionary:(NSDictionary *)jsonResponse {
    
    self = [super initWithJSONDictionary:jsonResponse];
    
    if (self) {
        
        [self updateWithJSONDictionary:jsonResponse];
    }
    
    return self;
}

- (void)updateWithJSONDictionary:(NSDictionary *)jsonResponse {
    
    _familyID = jsonResponse[APIParamFamilyID];
    _primary = jsonResponse[APIParamUserPrimary];
    _insurancePlan = jsonResponse[APIParamUserInsurancePlan];
    _phoneNumber = jsonResponse[APIParamPhone];
}

+ (NSDictionary *)dictionaryFromUser:(Guardian *)guardian {
    
    NSMutableDictionary *userDictionary = [[super dictionaryFromUser:guardian] mutableCopy];
    
    userDictionary[APIParamFamilyID] = guardian.familyID ?: [NSNull null];
    userDictionary[APIParamUserPrimary] = @(guardian.primary) ?: [NSNull null];
    userDictionary[APIParamPhone] = guardian.phoneNumber ?: [NSNull null];
    userDictionary[APIParamUserInsurancePlan] = guardian.insurancePlan ?: [NSNull null]; //FIXME: This should probably break since insurancePlan is a custom object.
    
    return userDictionary;
}

//- (id)copy {
//    
//    Guardian *guardianCopy = [[Guardian alloc] init];
//    guardianCopy.objectID = self.objectID;
//    guardianCopy.familyID = self.familyID;
//    guardianCopy.firstName = self.firstName;
//    guardianCopy.lastName = self.lastName;
//    guardianCopy.middleInitial = self.middleInitial;
//    guardianCopy.suffix = self.suffix;
//    guardianCopy.title = self.title;
//    guardianCopy.email = self.email;
//    guardianCopy.avatarURL = self.avatarURL;
//    guardianCopy.avatar = [self.avatar copy];
//    guardianCopy.primary = self.primary;
//    guardianCopy.insurancePlan = [self.insurancePlan copy];
//    guardianCopy.phoneNumber = self.phoneNumber;
//    return guardianCopy;
//}

- (NSString *)description {
    
    NSString *superDesc = [super description];
    
    NSString *subDesc = [NSString stringWithFormat:@"\nName: %@ %@",self.firstName, self.lastName];
    
    return [superDesc stringByAppendingString:subDesc];
}

//- (id)initWithCoder:(NSCoder *)decoder {
//    
//    self = [super initWithCoder:decoder];
//    
//    NSString *familyID = [decoder decodeObjectForKey:APIParamFamilyID];
//    BOOL primary = [decoder decodeBoolForKey:APIParamUserPrimary];
//    
//    return [self initWithObjectID:self.objectID familyID:familyID title:self.title firstName:self.firstName middleInitial:self.middleInitial lastName:self.lastName suffix:self.suffix email:self.email avatarURL:self.avatarURL avatar:self.avatar phoneNumber:self.phoneNumber insurancePlan:self.insurancePlan primary:self.primary];
//}
//
//- (void)encodeWithCoder:(NSCoder *)encoder {
//    
//    [super encodeWithCoder:encoder];
//    
//    [encoder encodeObject:self.familyID forKey:APIParamFamilyID];
//    [encoder encodeBool:self.primary forKey:APIParamUserPrimary];
//    [encoder encodeObject:self.insurancePlan forKey:APIParamUserInsurancePlan];
//    [encoder encodeObject:self.phoneNumber forKey:APIParamPhone];
//}

@end
