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
    
    /**
     *  If an avatarURL exists, then append the objectID to it, followed by
     *  @1x.png, @2x.png, or @3x.png based on the scaleFactor.
     */
    if (!(jsonResponse[APIParamUserAvatarURL] == [NSNull null])) {
        
        NSInteger scaleFactor = [@([[UIScreen mainScreen] scale]) integerValue];
        
        avatarURL = [NSString stringWithFormat:@"%@%@@%ldx.png",jsonResponse[APIParamUserAvatarURL],@"3",(long)scaleFactor];
    }
    
    //TODO: May need to protect against nil values...
    return [self initWithObjectID:objectID title:title firstName:firstName middleInitial:middleInitial lastName:lastName suffix:suffix email:email avatarURL:avatarURL avatar:nil];
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
    
    userDictionary[APIParamUserAvatarURL] = user.avatarURL ? user.avatarURL : [NSNull null];
    
    return userDictionary;
}


//TODO: Refactor
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

#pragma mark - NSCoding

- (id)initWithCoder:(NSCoder *)decoder {
    
    NSString *firstName = [decoder decodeObjectForKey:APIParamUserFirstName];
    NSString *lastName = [decoder decodeObjectForKey:APIParamUserLastName];
    NSString *middleInitial = [decoder decodeObjectForKey:APIParamUserMiddleInitial];
    NSString *title = [decoder decodeObjectForKey:APIParamUserTitle];
    NSString *suffix = [decoder decodeObjectForKey:APIParamUserSuffix];
    NSString *objectID = [decoder decodeObjectForKey:APIParamID];
    NSString *email = [decoder decodeObjectForKey:APIParamUserEmail];
    NSString *avatarURL = [decoder decodeObjectForKey:APIParamUserAvatarURL];
    UIImage *avatar = [UIImage imageWithData:[decoder decodeObjectForKey:@"Avatar"]];
    
    return [self initWithObjectID:objectID title:title firstName:firstName middleInitial:middleInitial lastName:lastName suffix:suffix email:email avatarURL:avatarURL avatar:avatar];
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    
    [encoder encodeObject:self.firstName forKey:APIParamUserFirstName];
    [encoder encodeObject:self.lastName forKey:APIParamUserLastName];
    [encoder encodeObject:self.middleInitial forKey:APIParamUserMiddleInitial];
    [encoder encodeObject:self.title forKey:APIParamUserTitle];
    [encoder encodeObject:self.suffix forKey:APIParamUserSuffix];
    [encoder encodeObject:self.objectID forKey:APIParamID];
    [encoder encodeObject:self.email forKey:APIParamUserEmail];
    [encoder encodeObject:self.avatarURL forKey:APIParamUserAvatarURL];
    [encoder encodeObject:UIImagePNGRepresentation(self.avatar) forKey:@"Avatar"];
}

@end
