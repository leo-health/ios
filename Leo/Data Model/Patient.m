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
    
    userDictionary[APIParamFamilyID] = patient.familyID; //FIXME: Update with constant.
    userDictionary[APIParamUserBirthDate] = patient.dob;
    userDictionary[APIParamUserSex] = patient.gender;
    userDictionary[APIParamUserStatus] = patient.status;

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


@end
