//
//  Support.m
//  Leo
//
//  Created by Zachary Drossman on 7/9/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import "Support.h"

@implementation Support

- (instancetype)initWithObjectID:(nullable NSString *)objectID title:(nullable NSString *)title firstName:(NSString *)firstName middleInitial:(nullable NSString *)middleInitial lastName:(NSString *)lastName suffix:(nullable NSString *)suffix email:(NSString *)email avatarURL:(nullable NSString *)avatarURL avatar:(UIImage *)avatar role:(RoleCode)role roleDisplayName:(NSString *)roleDisplayName {

    self = [super initWithObjectID:objectID title:title firstName:firstName middleInitial:middleInitial lastName:lastName suffix:suffix email:email avatarURL:avatarURL avatar:avatar];
    
    if (self) {
        _role = role;
        _roleDisplayName = roleDisplayName;
    }
    
    return self;
}


//FIXME: Update with correct constants.
- (instancetype)initWithJSONDictionary:(NSDictionary *)jsonResponse {
    
    self = [super initWithJSONDictionary:jsonResponse];
    
    if (self) {
        _role = [jsonResponse[APIParamRoleID] integerValue];
        _roleDisplayName = jsonResponse[APIParamRole];
    }
    
    return self;
}

//FIXME: Update with correct constants.
+ (NSDictionary *)dictionaryFromUser:(Support *)support {
    
    NSMutableDictionary *userDictionary = [[super dictionaryFromUser:support] mutableCopy];
    
    userDictionary[APIParamRoleID] = [NSNumber numberWithInteger:support.role];
    userDictionary[APIParamRole] = support.roleDisplayName;
    
    return userDictionary;
}

- (id)copy {
    
    Support *supportCopy = [[Support alloc] init];
    supportCopy.objectID = self.objectID;
    supportCopy.firstName = self.firstName;
    supportCopy.lastName = self.lastName;
    supportCopy.middleInitial = self.middleInitial;
    supportCopy.suffix = self.suffix;
    supportCopy.title = self.title;
    supportCopy.email = self.email;
    supportCopy.avatarURL = self.avatarURL;
    supportCopy.avatar = [self.avatar copy];
    supportCopy.role = self.role;
    supportCopy.roleDisplayName = self.roleDisplayName;
    
    return supportCopy;
}

- (NSString *)description {
    
    NSString *superDesc = [super description];
    
    NSString *subDesc = [NSString stringWithFormat:@"\nName: %@ %@",self.firstName, self.lastName];
    
    return [superDesc stringByAppendingString:subDesc];
}

- (id)initWithCoder:(NSCoder *)decoder {
    
    self = [super initWithCoder:decoder];
    
    NSString *roleDisplayName = [decoder decodeObjectForKey:APIParamRole];
    NSInteger role = [decoder decodeIntegerForKey:APIParamRole];

    return [self initWithObjectID:self.objectID title:self.title firstName:self.firstName middleInitial:self.middleInitial lastName:self.lastName suffix:self.suffix email:self.email avatarURL:self.avatarURL avatar:self.avatar role:role roleDisplayName:roleDisplayName];
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    
    [super encodeWithCoder:encoder];
    
    [encoder encodeObject:self.roleDisplayName forKey:APIParamRole];
    [encoder encodeInteger:self.role forKey:APIParamRoleID];
}



@end
