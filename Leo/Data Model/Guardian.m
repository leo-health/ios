//
//  guardian.m
//  Leo
//
//  Created by Zachary Drossman on 7/2/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import "Guardian.h"
#import "NSUserDefaults+Additions.h"
#import "NSDictionary+Additions.h"
#import "LEOValidationsHelper.h"
#import "LEOS3Image.h"

@implementation Guardian

static NSString *const kMembershipTypeUnpaid = @"User";
static NSString *const kMembershipTypeMember = @"Member";
static NSString *const kMembershipTypeIncomplete = @"Incomplete"; //FIXME: This is only because the API doesn't yet support this detail.
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

            [self updateWithJSONDictionary:jsonResponse];
        }

        return self;
    }

    return nil;
}

- (void)incrementLoginCounter {

    NSMutableDictionary *loginCounter = [[[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultsKeyLoginCounts] mutableCopy];
    if (!loginCounter) {
        loginCounter = [NSMutableDictionary new];
    }
    NSInteger count = [loginCounter[self.objectID] integerValue];
    count++;
    loginCounter[self.objectID] = @(count);

    self.numTimesLoggedIn = count;

    [[NSUserDefaults standardUserDefaults] setObject:loginCounter forKey:kUserDefaultsKeyLoginCounts];
}

- (void)saveToUserDefaults {

    NSDictionary *guardianDictionary = [Guardian plistFromUser:self];
    [[NSUserDefaults standardUserDefaults] setObject:guardianDictionary forKey:NSStringFromClass([self class])];
}

- (instancetype)initFromUserDefaults {

    NSDictionary *guardianDictionary = [[NSUserDefaults standardUserDefaults] objectForKey:NSStringFromClass([self class])];
    Guardian *guardian = [[Guardian alloc] initWithJSONDictionary:guardianDictionary];

    [guardian incrementLoginCounter];
    return guardian;
}

+ (void)removeFromUserDefaults {

    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:NSStringFromClass([self class])];
}

- (void)updateWithJSONDictionary:(NSDictionary *)jsonResponse {


    id familyID = [jsonResponse leo_itemForKey:APIParamFamilyID];
    if ([familyID isKindOfClass:[NSString class]]) {
        _familyID = familyID;
    } else if ([familyID respondsToSelector:@selector(stringValue)]) {
        _familyID = [familyID stringValue];
    } else {
        _familyID = familyID;
    }
    _primary = [jsonResponse leo_itemForKey:APIParamUserPrimary];
    _insurancePlan = [jsonResponse leo_itemForKey:APIParamUserInsurancePlan];
    _phoneNumber = [jsonResponse leo_itemForKey:APIParamPhone];
    _membershipType = [Guardian membershipTypeFromString:[jsonResponse leo_itemForKey:APIParamUserMembershipType]];

    //Cannot call notification re: membershiptype changing because object hasn't been fully formed. Must do so either via alternative pattern or via class calling this once creation is complete. For now we will do the latter. Code smell should be reviewed.
}

+ (NSDictionary *)dictionaryFromUser:(Guardian *)guardian {

    NSMutableDictionary *userDictionary = [[super dictionaryFromUser:guardian] mutableCopy];

    userDictionary[APIParamFamilyID] = guardian.familyID;
    userDictionary[APIParamUserPrimary] = @(guardian.primary);
    userDictionary[APIParamPhone] = guardian.phoneNumber;
    userDictionary[APIParamInsurancePlanID] = guardian.insurancePlan.objectID; //FIXME: This should probably break since insurancePlan is a custom object.
    userDictionary[APIParamUserMembershipType] = guardian.membershipType ? [Guardian membershipStringFromType:guardian.membershipType] : Nil;

    return userDictionary;
}

+ (NSDictionary *)plistFromUser:(Guardian *)guardian {

    NSMutableDictionary *userDictionary = [[super plistFromUser:guardian] mutableCopy];

    userDictionary[APIParamFamilyID] = guardian.familyID;
    userDictionary[APIParamUserPrimary] = @(guardian.primary);
    userDictionary[APIParamPhone] = guardian.phoneNumber;
    userDictionary[APIParamUserMembershipType] = [Guardian membershipStringFromType:guardian.membershipType];

    return userDictionary;
}

+ (MembershipType)membershipTypeFromString:(NSString *)membershipTypeString {

    if (!membershipTypeString) {
        return MembershipTypeNone; //As mentioned elsewhere, we don't use MembershipTypeNone for anything except to be exhaustive.
    }
    else if ([membershipTypeString isEqualToString:kMembershipTypeUnpaid]) {
        return MembershipTypeUnpaid;
    }

    else if ([membershipTypeString isEqualToString:kMembershipTypeMember]) {
        return MembershipTypeMember;
    }

    else {
        return MembershipTypeIncomplete;
    }
}

+ (NSString *)membershipStringFromType:(MembershipType)membershipType {

    switch (membershipType) {
        case MembershipTypeUnpaid:
            return kMembershipTypeUnpaid;
        case MembershipTypeMember:
            return kMembershipTypeMember;
        case MembershipTypeIncomplete:
            return kMembershipTypeIncomplete;
        case MembershipTypeNone:
            return nil;
    }
}

-(void)setMembershipType:(MembershipType)membershipType {

    _membershipType = membershipType;

    [[NSNotificationCenter defaultCenter] postNotificationName:@"membership-changed" object:self];
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

@end
