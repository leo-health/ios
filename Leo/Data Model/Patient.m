//
//  Patient.m
//  Leo
//
//  Created by Zachary Drossman on 7/2/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import "Patient.h"

@implementation Patient

- (instancetype)initWithObjectID:(nullable NSString *)objectID familyID:(NSString *)familyID title:(nullable NSString *)title firstName:(NSString *)firstName middleInitial:(nullable NSString *)middleInitial lastName:(NSString *)lastName suffix:(nullable NSString *)suffix email:(nullable NSString *)email avatarURL:(nullable NSString *)avatarURL avatar:(nullable UIImage *)avatar dob:(NSDate *)dob gender:(NSString *)gender status:(NSString *)status {
    
    self = [super initWithObjectID:objectID title:title firstName:firstName middleInitial:middleInitial lastName:lastName suffix:suffix email:email avatarURL:avatarURL avatar:avatar];
    
    if (self) {
        _familyID = familyID;
        _dob = dob;
        _gender = gender;
        _status = status;
    }
    
    return self;
}

- (instancetype)initWithTitle:(nullable NSString *)title firstName:(NSString *)firstName middleInitial:(nullable NSString *)middleInitial lastName:(NSString *)lastName suffix:(nullable NSString *)suffix email:(nullable NSString *)email avatar:(nullable UIImage *)avatar dob:(NSDate *)dob gender:(NSString *)gender status:(NSString *)status {
    
    return [self initWithObjectID:nil familyID:nil title:title firstName:firstName middleInitial:middleInitial lastName:lastName suffix:suffix email:email avatarURL:nil avatar:avatar dob:dob gender:gender status:status];
}

- (instancetype)initWithJSONDictionary:(NSDictionary *)jsonResponse {
    
    self = [super initWithJSONDictionary:jsonResponse];
    
    if (self) {
        _familyID = jsonResponse[APIParamFamilyID]; //FIXME: Update with constant.
        _dob = jsonResponse[APIParamUserBirthDate];
        _gender = jsonResponse[APIParamUserSex];
        _status = jsonResponse[APIParamUserStatus];
    }
    
    return self;
}

+ (NSDictionary *)dictionaryFromUser:(Patient *)patient {
    
    NSMutableDictionary *userDictionary = [[super dictionaryFromUser:patient] mutableCopy];
    
    userDictionary[APIParamFamilyID] = patient.familyID ?: [NSNull null]; //FIXME: Update with constant.
    userDictionary[APIParamUserBirthDate] = patient.dob;
    userDictionary[APIParamUserSex] = patient.gender;
    userDictionary[APIParamUserStatus] = patient.status ?: [NSNull null];

    return userDictionary;
}

- (id)copy {

    Patient*patientCopy = [[Patient alloc] init];
    patientCopy.objectID = self.objectID;
    patientCopy.familyID = self.familyID;
    patientCopy.firstName = self.firstName;
    patientCopy.lastName = self.lastName;
    patientCopy.middleInitial = self.middleInitial;
    patientCopy.suffix = self.suffix;
    patientCopy.title = self.title;
    patientCopy.email = self.email;
    patientCopy.avatarURL = self.avatarURL;
    patientCopy.avatar = [self.avatar copy];
    patientCopy.dob = self.dob;
    patientCopy.gender = self.gender;
    patientCopy.status = self.status;
    
    return patientCopy;
}

- (NSString *)description {
    
    NSString *superDesc = [super description];
    
    NSString *subDesc = [NSString stringWithFormat:@"\nName: %@ %@",self.firstName, self.lastName];
    
    return [superDesc stringByAppendingString:subDesc];
}

- (id)initWithCoder:(NSCoder *)decoder {
    
    self = [super initWithCoder:decoder];
    
    NSString *familyID = [decoder decodeObjectForKey:APIParamFamilyID];
    NSDate *dob = [decoder decodeObjectForKey:APIParamUserBirthDate];
    NSString *gender = [decoder decodeObjectForKey:APIParamUserSex];
    NSString *status = [decoder decodeObjectForKey:APIParamUserStatus];
    
    return [self initWithObjectID:self.objectID familyID:familyID title:self.title firstName:self.firstName middleInitial:self.middleInitial lastName:self.lastName suffix:self.suffix email:self.email avatarURL:self.avatarURL avatar:self.avatar dob:dob gender:gender status:status];
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    
    [super encodeWithCoder:encoder];
    
    [encoder encodeObject:self.familyID forKey:APIParamFamilyID];
    [encoder encodeObject:self.dob forKey:APIParamUserBirthDate];
    [encoder encodeObject:self.gender forKey:APIParamUserSex];
    [encoder encodeObject:self.status forKey:APIParamUserStatus];
}

//MARK: This is both super helpful and super dangerous. We *need* this function for ensuring that we don't add the same patient to a family twice, but at the same time, it can only be used if we have enough information to properly distinguish patient. Meaning, if a parent names it's triplets with the exact same names, we will not be able to capture more than one of them in our product. Down the line we can make this more robust, by capturing data such as social security number, etc. etc. For now, I've added it here, but I'm trying to avoid using it as much as possible. I would love to make a custom compiler warning appear if a user of the Patient model object goes to use this so it is clear that they have to use it a certain way, but that is probably less than ideal in the long run and we should find a better solution. (When we build out a persistence layer on the front-end, we'll *need* this sort of thing to ensure non-duplication, even if just a backend validation.)

- (BOOL)isEqualToPatient:(Patient *)patient {
    if (!patient) {
        return NO;
    }
    
    BOOL haveEqualNames = (!self.fullName && !patient.fullName) || [self.fullName isEqualToString:patient.fullName];
    BOOL haveEqualBirthdays = (!self.dob && !patient.dob) || [self.dob isEqualToDate:patient.dob];
    
    return haveEqualNames && haveEqualBirthdays;
}

-(void)setGender:(NSString * __nonnull)gender {
    
    _gender = gender;
    
    if ([gender isEqualToString:@"Male"]) {
        _gender = @"M";
    }
    
    if ([gender isEqualToString:@"Female"]) {
        _gender = @"F";
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

@end
