//
//  guardian.m
//  Leo
//
//  Created by Zachary Drossman on 7/2/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import "Guardian.h"
#import "NSUserDefaults+Extensions.h"
#import "NSDictionary+Extensions.h"
#import "LEOValidationsHelper.h"
#import "LEOS3Image.h"

@implementation Guardian

static NSString *const kMembershipTypeUnknown = @"unknown";
static NSString *const kMembershipTypeMember = @"member";
static NSString *const kMembershipTypeExempted = @"exempted";
static NSString *const kMembershipTypeDelinquent = @"delinquent";
static NSString *const kMembershipTypeIncomplete = @"incomplete";
static NSString *const kUserDefaultsKeyLoginCounts = @"loginCounter";

- (instancetype)initWithObjectID:(nullable NSString *)objectID familyID:(NSString *)familyID title:(nullable NSString *)title firstName:(NSString *)firstName middleInitial:(nullable NSString *)middleInitial lastName:(NSString *)lastName suffix:(nullable NSString *)suffix email:(NSString *)email avatar:(nullable LEOS3Image *)avatar phoneNumber:(NSString *)phoneNumber insurancePlan:(InsurancePlan *)insurancePlan primary:(BOOL)primary membershipType:(MembershipType)membershipType {

    self = [super initWithObjectID:objectID title:title firstName:firstName middleInitial:middleInitial lastName:lastName suffix:suffix email:email avatar:avatar];

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

    if (jsonResponse) {

        self = [super initWithJSONDictionary:jsonResponse];

        if (self) {

            _familyID = [[jsonResponse leo_itemForKey:APIParamFamilyID] stringValue];
            _primary = [[jsonResponse leo_itemForKey:APIParamUserPrimary] boolValue];
            _insurancePlan = [[InsurancePlan alloc] initWithJSONDictionary:[jsonResponse leo_itemForKey:APIParamInsurancePlan]];
            _phoneNumber = [jsonResponse leo_itemForKey:APIParamPhone];
            _membershipType = [Guardian membershipTypeFromString:[jsonResponse leo_itemForKey:APIParamUserMembershipType]];
            _anonymousCustomerServiceID = [jsonResponse leo_itemForKey:APIParamUserVendorID];
        }

        return self;
    }

    return nil;
}

+ (NSDictionary *)serializeToJSON:(Guardian *)guardian {

    if (!guardian) {
        return nil;
    }

    NSMutableDictionary *userDictionary = [[super serializeToJSON:guardian] mutableCopy];

    userDictionary[APIParamFamilyID] = guardian.familyID;
    userDictionary[APIParamUserPrimary] = @(guardian.primary);
    userDictionary[APIParamPhone] = guardian.phoneNumber;
    userDictionary[APIParamInsurancePlanID] = guardian.insurancePlan.objectID;
    userDictionary[APIParamInsurancePlan] = [guardian.insurancePlan serializeToJSON];
    userDictionary[APIParamUserMembershipType] = guardian.membershipType ? [Guardian membershipStringFromType:guardian.membershipType] : Nil;
    userDictionary[APIParamUserVendorID] = guardian.anonymousCustomerServiceID;

    return userDictionary;
}

+ (NSDictionary *)serializeToPlist:(Guardian *)user {

    NSMutableDictionary *json = [[self serializeToJSON:user] mutableCopy];
    // HACK: can't store UIImage in Plist format
    // TODO: move to URL based references
    [json removeObjectForKey:APIParamUserAvatar];
    return [json copy];
}

+ (MembershipType)membershipTypeFromString:(NSString *)membershipTypeString {

    if ([membershipTypeString isEqualToString:kMembershipTypeMember]) {
        return MembershipTypeMember;
    }

    if ([membershipTypeString isEqualToString:kMembershipTypeIncomplete]) {
        return MembershipTypeIncomplete;
    }

    if ([membershipTypeString isEqualToString:kMembershipTypeExempted]) {
        return MembershipTypeExempted;
    }

    if ([membershipTypeString isEqualToString:kMembershipTypeDelinquent]) {
        return MembershipTypeDelinquent;
    }

    return MembershipTypeUnknown;
}

+ (NSString *)membershipStringFromType:(MembershipType)membershipType {

    switch (membershipType) {

        case MembershipTypeMember:
            return kMembershipTypeMember;

        case MembershipTypeIncomplete:
            return kMembershipTypeIncomplete;

        case MembershipTypeExempted:
            return kMembershipTypeExempted;

        case MembershipTypeDelinquent:
            return kMembershipTypeDelinquent;

        case MembershipTypePreview:
        case MembershipTypeExpecting:
        case MembershipTypeUnknown:
            return kMembershipTypeUnknown;
    }
}

-(void)setMembershipType:(MembershipType)membershipType {

    MembershipType originalMembershipType = _membershipType;

    _membershipType = membershipType;

    if (originalMembershipType != _membershipType) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"membership-changed" object:self];
    }
}

- (void)resetAnonymousCustomerServiceID {
    _anonymousCustomerServiceID = nil;
}

- (NSString *)description {

    NSString *superDesc = [super description];

    NSString *subDesc = [NSString stringWithFormat:@"\nName: %@ %@",self.firstName, self.lastName];

    return [superDesc stringByAppendingString:subDesc];
}

- (BOOL)validFirstName {
    return [LEOValidationsHelper isValidFirstName:self.firstName];
}

- (BOOL)validLastName {
    return [LEOValidationsHelper isValidLastName:self.lastName];
}

- (BOOL)validPhoneNumber {
    return [LEOValidationsHelper isValidPhoneNumberWithFormatting:self.phoneNumber];
}

- (BOOL)validInsurer {
    return [LEOValidationsHelper isValidInsurer:self.insurancePlan.name];
}

//TODO: Work through the rest of what makes it valid / invalid and various cases.
//TODO: Add error terms or error string combination from error terms?

- (BOOL)valid {
    return [self validFirstName] && [self validLastName] && [self validPhoneNumber] && [self validInsurer];
}

-(id)copyWithZone:(NSZone *)zone {

    Guardian *guardianCopy = [self initWithObjectID:[self.objectID copy] familyID:[self.familyID copy] title:[self.title copy] firstName:[self.firstName copy] middleInitial:nil lastName:[self.lastName copy] suffix:[self.suffix copy] email:[self.email copy] avatar:[self.avatar copy] phoneNumber:[self.phoneNumber copy] insurancePlan:[self.insurancePlan copy] primary:self.primary membershipType:self.membershipType];

    return guardianCopy;
}

- (BOOL)isAPaidMember {

    switch (self.membershipType) {
        case MembershipTypeMember:
            return YES;

        case MembershipTypePreview:
        case MembershipTypeUnknown:
        case MembershipTypeExempted:
        case MembershipTypeExpecting:
        case MembershipTypeDelinquent:
        case MembershipTypeIncomplete:
            return NO;
    }
}

- (void)copyFrom:(Guardian *)otherGuardian {

    [super copyFrom:otherGuardian];

    self.phoneNumber = otherGuardian.phoneNumber;
    self.insurancePlan = otherGuardian.insurancePlan;
    self.familyID = otherGuardian.familyID;
    self.primary = otherGuardian.primary;

    if (otherGuardian.membershipType != MembershipTypeUnknown) {
        self.membershipType = otherGuardian.membershipType;
    }
}

-(BOOL)complete {

    BOOL complete = [super complete];

    return complete && self.phoneNumber && self.membershipType && self.familyID && self.insurancePlan;
}

- (BOOL)hasFeedAccess {
    return self.membershipType == MembershipTypeMember || self.membershipType == MembershipTypeExempted;
}

@end
