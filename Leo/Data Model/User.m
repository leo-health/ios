//
//  User.m
//  Leo
//
//  Created by Zachary Drossman on 6/11/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import "User.h"
#import "Appointment.h"
#import "Role.h"
#import "NSDictionary+Extensions.h"
#import "LEOS3Image.h"
#import "LEOValidationsHelper.h"
#import <DateTools/DateTools.h>

@implementation User

- (instancetype)initWithObjectID:(nullable NSString*)objectID
                           title:(nullable NSString *)title
                       firstName:(NSString *)firstName
                   middleInitial:(nullable NSString *)middleInitial
                        lastName:(NSString *)lastName
                          suffix:(nullable NSString *)suffix
                           email:(NSString *)email
                          avatar:(nullable LEOS3Image *)avatar
                            role:(nullable Role *)role {

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
        _role = role;
    }

    return self;
}

- (instancetype)initWithObjectID:(nullable NSString*)objectID
                           title:(nullable NSString *)title
                       firstName:(NSString *)firstName
                   middleInitial:(nullable NSString *)middleInitial
                        lastName:(NSString *)lastName
                          suffix:(nullable NSString *)suffix
                           email:(NSString *)email
                          avatar:(nullable LEOS3Image *)avatar {

    return [self initWithObjectID:objectID title:title firstName:firstName middleInitial:middleInitial lastName:lastName suffix:suffix email:email avatar:avatar role:nil];
}

- (instancetype)initWithJSONDictionary:(NSDictionary *)jsonDictionary {

    if (!jsonDictionary) {
        return nil;
    }

    NSString *firstName = [jsonDictionary leo_itemForKey:APIParamUserFirstName];
    NSString *lastName = [jsonDictionary leo_itemForKey:APIParamUserLastName];
    NSString *middleInitial = [jsonDictionary leo_itemForKey:APIParamUserMiddleInitial];
    NSString *title = [jsonDictionary leo_itemForKey:APIParamUserTitle];
    NSString *suffix = [jsonDictionary leo_itemForKey:APIParamUserSuffix];
    Role *role = [[Role alloc] initWithJSONDictionary:[jsonDictionary leo_itemForKey:APIParamRole]];
    NSString *objectID;

    objectID = [[jsonDictionary leo_itemForKey:APIParamID] stringValue];

    NSString *email = [jsonDictionary leo_itemForKey:APIParamUserEmail];

    LEOS3Image *avatar = [[LEOS3Image alloc] initWithJSONDictionary:[jsonDictionary leo_itemForKey:APIParamUserAvatar][APIParamImageURL]];
    avatar.placeholder = [UIImage imageNamed:@"Icon-ProviderAvatarPlaceholder"];

    return [self initWithObjectID:objectID title:title firstName:firstName middleInitial:middleInitial lastName:lastName suffix:suffix email:email avatar:avatar role:role];
}

+ (NSArray<NSDictionary *> *)serializeMany:(NSArray<User *> *)users {

    NSArray *objects = users;
    NSMutableArray *json = [NSMutableArray new];
    for (User *object in objects) {
        [json addObject:[object serializeToJSON]];
    }
    return [json copy];
}

+ (NSDictionary *)serializeToJSON:(User *)user {

    if (!user) {
        return nil;
    }

    NSMutableDictionary *userDictionary = [[NSMutableDictionary alloc] init];

    userDictionary[APIParamUserTitle] = user.title;
    userDictionary[APIParamUserFirstName] = user.firstName;
    userDictionary[APIParamUserMiddleInitial] = user.middleInitial;
    userDictionary[APIParamUserLastName] = user.lastName;
    userDictionary[APIParamUserSuffix] = user.suffix;
    userDictionary[APIParamID] = user.objectID;
    userDictionary[APIParamUserEmail] = user.email;
    userDictionary[APIParamRole] = [user.role serializeToJSON];
    NSDictionary *avatarJson = [user.avatar serializeToJSON];
    if (avatarJson) {
        userDictionary[APIParamUserAvatar] = @{APIParamImageURL: avatarJson};
    }

    return [userDictionary copy];
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
    } else if (self.firstName && self.lastName) {
        nameComponents = @[self.firstName, self.lastName];
    } else {
        return nil;
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

- (void)copyFrom:(User *)otherUser {

    self.title = otherUser.title;
    self.firstName = otherUser.firstName;
    self.middleInitial = otherUser.middleInitial;
    self.lastName = otherUser.lastName;
    self.suffix = otherUser.suffix;
    self.email = otherUser.email;
    self.avatar = otherUser.avatar;
}

- (BOOL)complete {
    return self.objectID && self.firstName && self.lastName && self.email;
}


@end
