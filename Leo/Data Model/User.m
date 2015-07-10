//
//  User.m
//  Leo
//
//  Created by Zachary Drossman on 6/11/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import "User.h"
#import "Appointment.h"
#import "LEOConstants.h"


@implementation User

- (instancetype)initWithObjectID:(nullable NSString*)objectID title:(nullable NSString *)title firstName:(NSString *)firstName middleInitial:(nullable NSString *)middleInitial lastName:(NSString *)lastName suffix:(nullable NSString *)suffix email:(NSString *)email photoURL:(NSURL *)photoURL photo:(nullable UIImage *)photo {

    self = [super init];
    
    if (self) {
        _objectID = objectID;
        _title = title;
        _firstName = firstName;
        _middleInitial = middleInitial;
        _lastName = lastName;
        _suffix = suffix;
        _email = email;
        _photoURL = photoURL;
        _photo = photo;
    }
    
    return self;
}

- (instancetype)initWithJSONDictionary:(NSDictionary *)jsonResponse {

    NSString *firstName = jsonResponse[APIParamUserFirstName];
    NSString *lastName = jsonResponse[APIParamUserLastName];
    NSString *middleInitial = jsonResponse[APIParamUserMiddleInitial];
    NSString *title = jsonResponse[APIParamUserTitle];
    NSString *suffix = jsonResponse[APIParamUserSuffix];
    NSString *objectID = jsonResponse[APIParamID];
    NSString *email = jsonResponse[APIParamUserEmail];
    NSURL *photoURL = [NSURL URLWithString:jsonResponse[APIParamUserPhotoURL]];
    UIImage *photo = [UIImage imageWithData:[NSData dataWithContentsOfURL:photoURL]];
    
    //TODO: May need to protect against nil values...
    return [self initWithObjectID:objectID title:title firstName:firstName middleInitial:middleInitial lastName:lastName suffix:suffix email:email photoURL:photoURL photo:photo];
}

+ (NSDictionary *)dictionaryFromUser:(User *)user {

    NSMutableDictionary *userDictionary = [[NSMutableDictionary alloc] init];
    
    //TODO: Remove the ternary operators for variables that MUST be there!
    userDictionary[APIParamUserTitle] = user.title ? user.title : [NSNull null];
    userDictionary[APIParamUserFirstName] = user.firstName;
    userDictionary[APIParamUserMiddleInitial] = user.middleInitial ? user.middleInitial : [NSNull null];
    userDictionary[APIParamUserLastName] = user.lastName;
    userDictionary[APIParamUserSuffix] = user.suffix ? user.suffix : [NSNull null];
    userDictionary[APIParamID] = user.objectID;
    userDictionary[APIParamUserEmail] = user.email ? user.email : [NSNull null];
    
    return userDictionary;
}

+ (NSDictionary *)dictionaryFromUserWithPhoto:(User *)user {
    
    NSMutableDictionary *userDictionary = [[User dictionaryFromUser:user] mutableCopy];
    
    userDictionary[APIParamUserPhoto] = user.photo ? user.photo : [NSNull null];
    
    return userDictionary;
}


//TODO: Add suffix into fullName
- (NSString *)fullName {
    
    NSArray *nameComponents;
    
    if (self.title) {
        nameComponents = @[self.title, self.firstName, self.lastName];
    } else {
        nameComponents = @[self.firstName, self.lastName];
    }
    
    return [nameComponents componentsJoinedByString:@" "];
}

- (NSString *)description {
    
    return [NSString stringWithFormat:@"<%@: %p>",[self class],self];
}


@end
