//
//  guardian.m
//  Leo
//
//  Created by Zachary Drossman on 7/2/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import "Guardian.h"

@implementation Guardian

static NSString *const kMembershipTypeUnpaid = @"User";
static NSString *const kMembershipTypePaid = @"Member";
static NSString *const kMembershipTypeIncomplete = @"Incomplete"; //FIXME: This is only because the API doesn't yet support this detail.

- (instancetype)initWithObjectID:(nullable NSString *)objectID familyID:(NSString *)familyID title:(nullable NSString *)title firstName:(NSString *)firstName middleInitial:(nullable NSString *)middleInitial lastName:(NSString *)lastName suffix:(nullable NSString *)suffix email:(NSString *)email avatarURL:(nullable NSString *)avatarURL avatar:(nullable UIImage *)avatar phoneNumber:(NSString *)phoneNumber insurancePlan:(InsurancePlan *)insurancePlan primary:(BOOL)primary membershipType:(MembershipType)membershipType {
    
    self = [super initWithObjectID:objectID title:title firstName:firstName middleInitial:middleInitial lastName:lastName suffix:suffix email:email avatarURL:avatarURL avatar:avatar];
    
    if (self) {
        _familyID = familyID;
        _phoneNumber = phoneNumber;
        _insurancePlan = insurancePlan;
        _primary = primary;
        _membershipType = membershipType;
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
    
    if (jsonResponse[APIParamUserMembershipType] != [NSNull null]) {
        _membershipType = [Guardian membershipTypeFromString:jsonResponse[APIParamUserMembershipType]];
    }
}

+ (NSDictionary *)dictionaryFromUser:(Guardian *)guardian {
    
    NSMutableDictionary *userDictionary = [[super dictionaryFromUser:guardian] mutableCopy];
    
    userDictionary[APIParamFamilyID] = guardian.familyID ?: [NSNull null];
    userDictionary[APIParamUserPrimary] = @(guardian.primary) ?: [NSNull null];
    userDictionary[APIParamPhone] = guardian.phoneNumber ?: [NSNull null];
    userDictionary[APIParamUserInsurancePlan] = guardian.insurancePlan ?: [NSNull null]; //FIXME: This should probably break since insurancePlan is a custom object.
    userDictionary[APIParamUserMembershipType] = guardian.membershipType ? [Guardian membershipStringFromType:guardian.membershipType] : [NSNull null];
    
    return userDictionary;
}

+ (MembershipType)membershipTypeFromString:(NSString *)membershipTypeString {
    
    if (!membershipTypeString) {
        return MembershipTypeNone; //As mentioned elsewhere, we don't use MembershipTypeNone for anything except to be exhaustive.
    }
    else if ([membershipTypeString isEqualToString:kMembershipTypeUnpaid]) {
        return MembershipTypeUnpaid;
    }

    else if ([membershipTypeString isEqualToString:kMembershipTypePaid]) {
        return MembershipTypePaid;
    }
    
    else {
        return MembershipTypeIncomplete;
    }
}

+ (NSString *)membershipStringFromType:(MembershipType)membershipType {
    
    switch (membershipType) {
        case MembershipTypeUnpaid:
            return kMembershipTypeUnpaid;
        case MembershipTypePaid:
            return kMembershipTypePaid;
        case MembershipTypeIncomplete:
            return kMembershipTypeIncomplete;
        case MembershipTypeNone:
            return nil;
    }
}

-(void)setMembershipType:(MembershipType)membershipType {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"membership-changed" object:self];
}

- (NSString *)description {
    
    NSString *superDesc = [super description];
    
    NSString *subDesc = [NSString stringWithFormat:@"\nName: %@ %@",self.firstName, self.lastName];
    
    return [superDesc stringByAppendingString:subDesc];
}

@end
