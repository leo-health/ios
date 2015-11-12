//
//  User.m
//  Leo
//
//  Created by Zachary Drossman on 6/11/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import "User.h"
#import "Appointment.h"

@implementation User


- (id)init
{
    NSAssert(false, @"You cannot init this class without using the designated initializer. See public API for more information.");

    self = nil;
    
    return nil;
}

- (instancetype)initWithObjectID:(nullable NSString*)objectID title:(nullable NSString *)title firstName:(NSString *)firstName middleInitial:(nullable NSString *)middleInitial lastName:(NSString *)lastName suffix:(nullable NSString *)suffix email:(NSString *)email avatarURL:(NSString *)avatarURL avatar:(nullable UIImage *)avatar {
    
    self = [super init];
    
    if (self) {
        _objectID = objectID;
        _title = title;
        _firstName = firstName;
        _middleInitial = middleInitial;
        _lastName = lastName;
        _suffix = suffix;
        _email = email;
        _avatarURL = avatarURL;
        _avatar = avatar;
    }
    
    return self;
}

- (instancetype)initWithJSONDictionary:(NSDictionary *)jsonResponse {
    
    NSString *firstName = jsonResponse[APIParamUserFirstName];
    NSString *lastName = jsonResponse[APIParamUserLastName];
    NSString *middleInitial = jsonResponse[APIParamUserMiddleInitial];
    
    NSString *title;
    if (!(jsonResponse[APIParamUserTitle] == [NSNull null])) {
       title = jsonResponse[APIParamUserTitle];
    }
    
    NSString *suffix;
    
    if (!(jsonResponse[APIParamUserSuffix] == [NSNull null])) {
        suffix = jsonResponse[APIParamUserSuffix];
    }
    
    NSString *objectID = [jsonResponse[APIParamID] stringValue];
    NSString *email = jsonResponse[APIParamUserEmail];
    
    NSString *avatarURL;
    
    if (!(jsonResponse[@"avatar"] == [NSNull null])) {
        avatarURL = jsonResponse[@"avatar"][@"url"];
    }
    
    //TODO: May need to protect against nil values...
    return [self initWithObjectID:objectID title:title firstName:firstName middleInitial:middleInitial lastName:lastName suffix:suffix email:email avatarURL:avatarURL avatar:nil];
}

+ (NSDictionary *)dictionaryFromUser:(User *)user {
    
    NSMutableDictionary *userDictionary = [[NSMutableDictionary alloc] init];
    
    //TODO: Remove the ternary operators for variables that MUST be there!
    userDictionary[APIParamUserTitle] = user.title ?: [NSNull null];
    userDictionary[APIParamUserFirstName] = user.firstName ?: [NSNull null];
    userDictionary[APIParamUserMiddleInitial] = user.middleInitial ?: [NSNull null];
    userDictionary[APIParamUserLastName] = user.lastName ?: [NSNull null];
    userDictionary[APIParamUserSuffix] = user.suffix ?: [NSNull null];
    userDictionary[APIParamID] = user.objectID ?: [NSNull null];
    userDictionary[APIParamUserEmail] = user.email ?: [NSNull null];
    
    return userDictionary;
}

+ (NSDictionary *)dictionaryFromUserWithPhoto:(User *)user {
    
    NSMutableDictionary *userDictionary = [[User dictionaryFromUser:user] mutableCopy];
    
    userDictionary[APIParamUserAvatarURL] = user.avatarURL ?: [NSNull null];
    
    return userDictionary;
}

- (NSString *)initials {

    NSString *_initials;
    
    NSString *firstInitial = [[self.firstName substringToIndex:1] capitalizedString];
    NSString *lastInitial = [[self.lastName substringToIndex:1] capitalizedString];
    
    _initials = [NSString stringWithFormat:@"%@%@", firstInitial, lastInitial];
    
    return _initials;
}

- (NSString *)fullName {
    
    NSArray *nameComponents;
    
    if (self.title && self.suffix) {
        nameComponents = @[self.title, self.firstName, self.lastName, self.suffix];
    } else if (self.title) {
        nameComponents = @[self.title, self.firstName, self.lastName];
    } else if (self.suffix) {
        nameComponents = @[self.firstName, self.lastName, self.suffix];
    } else {
        nameComponents = @[self.firstName, self.lastName];
    }
    
    return [[nameComponents componentsJoinedByString:@" "] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

//TODO: Refactor
- (NSString *)firstAndLastName {
    
    NSArray *nameComponents;
    
    if (self.suffix) {
        nameComponents = @[self.title, self.firstName, self.lastName, self.suffix];
    } else {
        nameComponents = @[self.firstName, self.lastName];
    }
    
    return [[nameComponents componentsJoinedByString:@" "] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

- (NSString *)description {
    
    return [NSString stringWithFormat:@"<%@: %p>",[self class],self];
}

@end
