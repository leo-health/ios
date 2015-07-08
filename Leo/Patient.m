//
//  Patient.m
//  Leo
//
//  Created by Zachary Drossman on 7/2/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import "Patient.h"
#import "LEOConstants.h"

@implementation Patient

-(instancetype)initWithObjectID:(nullable NSString *)objectID title:(nullable NSString *)title firstName:(NSString *)firstName middleInitial:(nullable NSString *)middleInitial lastName:(NSString *)lastName suffix:(nullable NSString *)suffix email:(nullable NSString *)email photoURL:(nullable NSURL *)photoURL photo:(nullable UIImage *)photo dob:(NSDate *)dob gender:(NSString *)gender status:(NSString *)status {
    
    self = [super initWithObjectID:objectID title:title firstName:firstName middleInitial:middleInitial lastName:lastName suffix:suffix email:email photoURL:photoURL photo:photo];
    
    if (self) {
        _dob = dob;
        _gender = gender;
        _status = status;
    }
    
    return self;
}

-(instancetype)initWithJSONDictionary:(NSDictionary *)jsonResponse {
    
    self = [super initWithJSONDictionary:jsonResponse];
    
    if (self) {
        _dob = jsonResponse[APIParamUserDOB];
        _gender = jsonResponse[APIParamUserGender];
        _status = jsonResponse[APIParamUserStatus];
    }
    
    return self;
}

+ (NSDictionary *)dictionaryFromUser:(Patient *)patient {
    
    NSMutableDictionary *userDictionary = [[super dictionaryFromUser:patient] mutableCopy];
    
    userDictionary[APIParamUserDOB] = patient.dob;
    userDictionary[APIParamUserGender] = patient.gender;
    userDictionary[APIParamUserStatus] = patient.status;

    return userDictionary;
    
}

-(id)copy {

    Patient*patientCopy = [[Patient alloc] init];
    patientCopy.objectID = self.objectID;
    patientCopy.firstName = self.firstName;
    patientCopy.lastName = self.lastName;
    patientCopy.middleInitial = self.middleInitial;
    patientCopy.suffix = self.suffix;
    patientCopy.title = self.title;
    patientCopy.email = self.email;
    patientCopy.photoURL = self.photoURL;
    patientCopy.photo = [self.photo copy];
    patientCopy.dob = self.dob;
    patientCopy.gender = self.gender;
    patientCopy.status = self.status;
    
    return patientCopy;
}

-(NSString *)description {
    
    NSString *superDesc = [super description];
    
    NSString *subDesc = [NSString stringWithFormat:@"\nName: %@ %@",self.firstName, self.lastName];
    
    return [superDesc stringByAppendingString:subDesc];
}

@end
