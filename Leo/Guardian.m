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


- (instancetype)initWithObjectID:(nullable NSString *)objectID Title:(nullable NSString *)title firstName:(NSString *)firstName middleInitial:(nullable NSString *)middleInitial lastName:(NSString *)lastName suffix:(nullable NSString *)suffix email:(NSString *)email photoURL:(nullable NSURL *)photoURL photo:(nullable UIImage *)photo primary:(BOOL)primary relationship:(NSString *)relationship {
    
    self = [super initWithObjectID:objectID title:title firstName:firstName middleInitial:middleInitial lastName:lastName suffix:suffix email:email photoURL:photoURL photo:photo];
    
    if (self) {
        _primary = primary;
        _relationship = relationship;
    }
    
    return self;
}

- (instancetype)initWithJSONDictionary:(NSDictionary *)jsonResponse {
    
    self = [super initWithJSONDictionary:jsonResponse];
    
    if (self) {
        _primary = jsonResponse[APIParamUserPrimary];
        _relationship = jsonResponse[APIParamUserRelationship];
    }
    
    return self;
}

+ (NSDictionary *)dictionaryFromUser:(Guardian *)guardian {
    
    NSMutableDictionary *userDictionary = [[super dictionaryFromUser:guardian] mutableCopy];
    
    userDictionary[APIParamUserPrimary] = @(guardian.primary);
    userDictionary[APIParamUserRelationship] = guardian.relationship;
    
    return userDictionary;
    
}

- (id)copy {
    
    Guardian *guardianCopy = [[Guardian alloc] init];
    guardianCopy.objectID = self.objectID;
    guardianCopy.firstName = self.firstName;
    guardianCopy.lastName = self.lastName;
    guardianCopy.middleInitial = self.middleInitial;
    guardianCopy.suffix = self.suffix;
    guardianCopy.title = self.title;
    guardianCopy.email = self.email;
    guardianCopy.photoURL = self.photoURL;
    guardianCopy.photo = [self.photo copy];
    guardianCopy.relationship = self.relationship;
    guardianCopy.primary = self.primary;
    
    return guardianCopy;
}

-(NSString *)description {
    
    NSString *superDesc = [super description];
    
    NSString *subDesc = [NSString stringWithFormat:@"\nName: %@ %@",self.firstName, self.lastName];
    
    return [superDesc stringByAppendingString:subDesc];
}

@end
