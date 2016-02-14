//
//  User.m
//  Leo
//
//  Created by Zachary Drossman on 6/11/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import "User.h"
#import "Appointment.h"
#import "NSDictionary+Additions.h"
#import "LEOS3Image.h"
#import "LEOValidationsHelper.h"

@implementation User

- (instancetype)initWithObjectID:(nullable NSString*)objectID title:(nullable NSString *)title firstName:(NSString *)firstName middleInitial:(nullable NSString *)middleInitial lastName:(NSString *)lastName suffix:(nullable NSString *)suffix email:(NSString *)email avatar:(nullable LEOS3Image *)avatar {
    
    self = [super init];
    
    if (self) {
        _objectID = objectID;
        _title = title;
        _firstName = firstName;
        _middleInitial = middleInitial;
        _lastName = lastName;
        _suffix = suffix;
        _email = email;
        _avatar = avatar;
    }
    
    return self;
}

- (instancetype)initWithJSONDictionary:(NSDictionary *)jsonResponse {
    
    NSString *firstName = [jsonResponse leo_itemForKey:APIParamUserFirstName];
    NSString *lastName = [jsonResponse leo_itemForKey:APIParamUserLastName];
    NSString *middleInitial = [jsonResponse leo_itemForKey:APIParamUserMiddleInitial];
    NSString *title = [jsonResponse leo_itemForKey:APIParamUserTitle];
    NSString *suffix = [jsonResponse leo_itemForKey:APIParamUserSuffix];
    
    NSString *objectID;
    
    if ([jsonResponse[APIParamID] isKindOfClass:[NSNumber class]]) {
            objectID = [[jsonResponse leo_itemForKey:APIParamID] stringValue];
    } else {
        objectID = [jsonResponse leo_itemForKey:APIParamID];
    }
    
    NSString *email = [jsonResponse leo_itemForKey:APIParamUserEmail];
    
    LEOS3Image *avatar = [[LEOS3Image alloc] initWithJSONDictionary:[jsonResponse leo_itemForKey:APIParamUserAvatar][APIParamImageURL]];
    avatar.placeholder = [UIImage imageNamed:@"Icon-ProviderAvatarPlaceholder"];
    
    return [self initWithObjectID:objectID title:title firstName:firstName middleInitial:middleInitial lastName:lastName suffix:suffix email:email avatar:avatar];
}


//TODO: All of the rest of this class needs to be updated for the new avatar model.

+ (NSDictionary *)plistFromUser:(User *)user {
    
    NSMutableDictionary *userDictionary = [[NSMutableDictionary alloc] init];
    
    userDictionary[APIParamUserTitle] = user.title;
    userDictionary[APIParamUserFirstName] = user.firstName;
    userDictionary[APIParamUserMiddleInitial] = user.middleInitial;
    userDictionary[APIParamUserLastName] = user.lastName;
    userDictionary[APIParamUserSuffix] = user.suffix;
    userDictionary[APIParamID] = user.objectID;
    userDictionary[APIParamUserEmail] = user.email;
    
    return userDictionary;
}

+ (NSDictionary *)dictionaryFromUser:(User *)user {
    
    NSMutableDictionary *userDictionary = [[NSMutableDictionary alloc] init];
    
    //TODO: Remove the ternary operators for variables that MUST be there!
    userDictionary[APIParamUserTitle] = user.title;
    userDictionary[APIParamUserFirstName] = user.firstName;
    userDictionary[APIParamUserMiddleInitial] = user.middleInitial;
    userDictionary[APIParamUserLastName] = user.lastName;
    userDictionary[APIParamUserSuffix] = user.suffix;
    userDictionary[APIParamID] = user.objectID;
    userDictionary[APIParamUserEmail] = user.email;
    
    return userDictionary;
}

- (NSString *)initials {

    NSString *_initials;
    
    NSString *firstInitial = [[self.firstName substringToIndex:1] capitalizedString];
    NSString *lastInitial = [[self.lastName substringToIndex:1] capitalizedString];
    
    _initials = [NSString stringWithFormat:@"%@%@", firstInitial, lastInitial];
    
    return _initials;
}

- (LEOS3Image *)avatar {

    if (!_avatar) {

        _avatar = [LEOS3Image new];
    }

    return _avatar;
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
