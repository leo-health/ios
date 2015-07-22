//
//  guardian.m
//  Leo
//
//  Created by Zachary Drossman on 7/2/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import "Guardian.h"
#import "LEOConstants.h"

@implementation Guardian


- (instancetype)initWithObjectID:(nullable NSString *)objectID familyID:(NSString *)familyID title:(nullable NSString *)title firstName:(NSString *)firstName middleInitial:(nullable NSString *)middleInitial lastName:(NSString *)lastName suffix:(nullable NSString *)suffix email:(NSString *)email avatarURL:(nullable NSURL *)avatarURL avatar:(nullable UIImage *)avatar primary:(BOOL)primary relationship:(NSString *)relationship {
    
    self = [super initWithObjectID:objectID title:title firstName:firstName middleInitial:middleInitial lastName:lastName suffix:suffix email:email avatarURL:avatarURL avatar:avatar];
    
    if (self) {
        _familyID = familyID;
        _primary = primary;
        _relationship = relationship;
    }
    
    return self;
}

- (instancetype)initWithJSONDictionary:(NSDictionary *)jsonResponse {
    
    self = [super initWithJSONDictionary:jsonResponse];
    
    if (self) {
        _familyID = jsonResponse[@"family_id"]; //FIXME: Update with constant.
        _primary = jsonResponse[APIParamUserPrimary];
        _relationship = jsonResponse[APIParamRelationship];
    }
    
    return self;
}

+ (NSDictionary *)dictionaryFromUser:(Guardian *)guardian {
    
    NSMutableDictionary *userDictionary = [[super dictionaryFromUser:guardian] mutableCopy];
    
    userDictionary[@"family_id"] = guardian.familyID; //FIXME: Update with constant.
    userDictionary[APIParamUserPrimary] = @(guardian.primary);
    userDictionary[APIParamRelationship] = guardian.relationship;
    
    return userDictionary;
}

- (id)copy {
    
    Guardian *guardianCopy = [[Guardian alloc] init];
    guardianCopy.objectID = self.objectID;
    guardianCopy.familyID = self.familyID;
    guardianCopy.firstName = self.firstName;
    guardianCopy.lastName = self.lastName;
    guardianCopy.middleInitial = self.middleInitial;
    guardianCopy.suffix = self.suffix;
    guardianCopy.title = self.title;
    guardianCopy.email = self.email;
    guardianCopy.avatarURL = self.avatarURL;
    guardianCopy.avatar = [self.avatar copy];
    guardianCopy.relationship = self.relationship;
    guardianCopy.primary = self.primary;
    
    return guardianCopy;
}

- (NSString *)description {
    
    NSString *superDesc = [super description];
    
    NSString *subDesc = [NSString stringWithFormat:@"\nName: %@ %@",self.firstName, self.lastName];
    
    return [superDesc stringByAppendingString:subDesc];
}

- (id)initWithCoder:(NSCoder *)decoder {
    
    self = [super initWithCoder:decoder];
    
    NSString *familyID = [decoder decodeObjectForKey:APIParamFamilyID];
    BOOL primary = [decoder decodeBoolForKey:APIParamUserPrimary];
    NSString *relationship = [decoder decodeObjectForKey:APIParamRelationship];
    
    return [self initWithObjectID:self.objectID familyID:familyID title:self.title firstName:self.firstName middleInitial:self.middleInitial lastName:self.lastName suffix:self.suffix email:self.email avatarURL:self.avatarURL avatar:self.avatar primary:primary relationship:relationship];
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    
    [super encodeWithCoder:encoder];
    
    [encoder encodeObject:self.familyID forKey:APIParamFamilyID];
    [encoder encodeBool:self.primary forKey:APIParamUserPrimary];
    [encoder encodeObject:self.relationship forKey:APIParamRelationship];
}

@end
