//
//  Patient.m
//  Leo
//
//  Created by Zachary Drossman on 7/2/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import "Patient.h"
#import "NSDate+Extensions.h"
#import "LEOValidationsHelper.h"
#import "LEOS3Image.h"
#import "LEOConstants.h"

@implementation Patient

@synthesize genderDisplayName = _genderDisplayName;

- (instancetype)initWithObjectID:(nullable NSString *)objectID familyID:(NSString *)familyID title:(nullable NSString *)title firstName:(NSString *)firstName middleInitial:(nullable NSString *)middleInitial lastName:(NSString *)lastName suffix:(nullable NSString *)suffix email:(nullable NSString *)email avatar:(nullable LEOS3Image *)avatar dob:(NSDate *)dob gender:(NSString *)gender status:(NSString *)status {

    self = [super initWithObjectID:objectID title:title firstName:firstName middleInitial:middleInitial lastName:lastName suffix:suffix email:email avatar:avatar];

    if (self) {
        _familyID = familyID;
        _dob = dob;
        _gender = gender;
        _status = status;

        [self setPatientAvatarPlaceholder];
    }

    return self;
}

- (instancetype)initWithTitle:(nullable NSString *)title firstName:(NSString *)firstName middleInitial:(nullable NSString *)middleInitial lastName:(NSString *)lastName suffix:(nullable NSString *)suffix email:(nullable NSString *)email avatar:(nullable LEOS3Image *)avatar dob:(NSDate *)dob gender:(NSString *)gender status:(nullable NSString *)status {

    return [self initWithObjectID:nil familyID:nil title:title firstName:firstName middleInitial:middleInitial lastName:lastName suffix:suffix email:email avatar:avatar dob:dob gender:gender status:status];
}

- (instancetype)initWithFirstName:(NSString *)firstName lastName:(NSString *)lastName avatar:(LEOS3Image *)avatar dob:(NSDate *)dob gender:(NSString *)gender {

    return [self initWithObjectID:nil familyID:nil title:nil firstName:firstName middleInitial:nil lastName:lastName suffix:nil email:nil avatar:avatar dob:dob gender:gender status:nil];
}

- (instancetype)initWithJSONDictionary:(NSDictionary *)jsonResponse {

    self = [super initWithJSONDictionary:jsonResponse];

    if (self) {
        _familyID = [jsonResponse[APIParamFamilyID] stringValue];
        _dob = [NSDate leo_dateFromDashedDateString:jsonResponse[APIParamUserBirthDate]];
        _gender = jsonResponse[APIParamUserSex];
        _status = jsonResponse[APIParamUserStatus];

        [self setPatientAvatarPlaceholder];
    }

    return self;
}

- (void)setPatientAvatarPlaceholder {

    if ([self.gender isEqualToString:kGenderFemale]) {
        self.avatar.placeholder = [UIImage imageNamed:@"Avatar_Patient_Daughter"];
    } else {
        self.avatar.placeholder = [UIImage imageNamed:@"Avatar_Patient_Son"];
    }
}

+ (NSDictionary *)dictionaryFromUser:(Patient *)patient {

    NSMutableDictionary *userDictionary = [[super dictionaryFromUser:patient] mutableCopy];

    userDictionary[APIParamFamilyID] = patient.familyID;
    userDictionary[APIParamUserBirthDate] = [NSDate leo_stringifiedDashedShortDate:patient.dob];
    userDictionary[APIParamUserSex] = patient.gender;
    userDictionary[APIParamUserStatus] = patient.status;

    return userDictionary;
}

- (NSString *)description {

    NSString *superDesc = [super description];

    NSString *subDesc = [NSString stringWithFormat:@"\nName: %@ %@",self.firstName, self.lastName];

    return [superDesc stringByAppendingString:subDesc];
}

//MARK: This is both super helpful and super dangerous. We *need* this function for ensuring that we don't add the same patient to a family twice, but at the same time, it can only be used if we have enough information to properly distinguish patient. Meaning, if a parent names it's triplets with the exact same names, we will not be able to capture more than one of them in our product. Down the line we can make this more robust, by capturing data such as social security number, etc. etc. For now, I've added it here, but I'm trying to avoid using it as much as possible. I would love to make a custom compiler warning appear if a user of the Patient model object goes to use this so it is clear that they have to use it a certain way, but that is probably less than ideal in the long run and we should find a better solution. (When we build out a persistence layer on the front-end, we'll *need* this sort of thing to ensure non-duplication, even if just a backend validation.)

- (BOOL)isEqualToPatient:(Patient *)patient {
    if (!patient) {
        return NO;
    }

    BOOL haveEqualNames = (!self.fullName && !patient.fullName) || [self.fullName isEqualToString:patient.fullName];
    BOOL haveEqualBirthdays = (!self.dob && !patient.dob) || [self.dob isEqualToDate:patient.dob];
    BOOL haveEqualGenders = (!self.gender && !patient.gender) || [self.gender isEqualToString:patient.gender];

    return haveEqualNames && haveEqualBirthdays && haveEqualGenders;
}

//FIXME: This was a quick implementation for dealing with gender display names vs. M/F in backend that I put in before leaving for vacation. Needs to be rebuilt at some point or backend could use display name instead to simplify.
-(void)setGenderDisplayName:(NSString *)genderDisplayName {

    _genderDisplayName = genderDisplayName;

    if ([_genderDisplayName isEqualToString:kGenderMaleDisplay]) {
        self.gender = kGenderMale;
    }

    if ([_genderDisplayName isEqualToString:kGenderFemaleDisplay]) {
        self.gender = kGenderFemale;
    }

}

- (NSString *)genderDisplayName {

    NSString *displayName;

    if ([self.gender isEqualToString:kGenderMale]) {
        displayName = kGenderMaleDisplay;
    }

    if ([self.gender isEqualToString:kGenderFemale]) {
        displayName = kGenderFemaleDisplay;
    }

    return displayName;
}

-(void)setGender:(NSString *)gender {

    _gender = gender;

    if ([gender isEqualToString:kGenderMaleDisplay]) {
        _gender = kGenderMale;
    }

    if ([gender isEqualToString:kGenderFemaleDisplay]) {
        _gender = kGenderFemale;
    }
}

#pragma mark - NSObject

- (BOOL)isEqual:(id)object {
    if (self == object) {
        return YES;
    }

    if (![object isKindOfClass:[Patient class]]) {
        return NO;
    }

    return [self isEqualToPatient:(Patient *)object];
}

- (NSUInteger)hash {
    return [self.fullName hash] ^ [self.dob hash];
}

- (BOOL)isValid {

    BOOL validFirstName = [LEOValidationsHelper isValidFirstName:self.firstName];
    BOOL validLastName = [LEOValidationsHelper isValidLastName:self.lastName];
    BOOL validBirthDate = [LEOValidationsHelper isValidBirthDate:self.dob];
    BOOL validGender = [LEOValidationsHelper isValidGender:self.gender];
    BOOL validAvatar = [LEOValidationsHelper isValidAvatar:self.avatar.image];

    return validAvatar && validFirstName && validLastName && validBirthDate && validGender;
}

//FIXME: This is not completely built out. Will work where currently used and probably nowhere else...
-(id)copyWithZone:(NSZone *)zone {
    
    Patient *copy = [[Patient allocWithZone:zone] initWithFirstName:[self.firstName copy] lastName:[self.lastName copy] avatar:[self.avatar copy] dob:[self.dob copy] gender:[self.gender copy]];

    return copy;
}

- (void)copyFrom:(Patient *)otherPatient {

    self.firstName = otherPatient.firstName;
    self.lastName = otherPatient.lastName;
    self.avatar = otherPatient.avatar;
    self.dob = otherPatient.dob;
    self.gender = otherPatient.gender;
}

@end
