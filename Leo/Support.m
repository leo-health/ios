//
//  Support.m
//  Leo
//
//  Created by Zachary Drossman on 7/2/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import "Support.h"
#import "LEOConstants.h"

@implementation Support

-(instancetype)initWithObjectID:(nullable NSString *)objectID title:(nullable NSString *)title firstName:(NSString *)firstName middleInitial:(nullable NSString *)middleInitial lastName:(NSString *)lastName suffix:(nullable NSString *)suffix email:(NSString *)email photoURL:(nullable NSURL *)photoURL photo:(UIImage *)photo role:(NSString *)role {
    
    self = [super initWithObjectID:objectID title:title firstName:firstName middleInitial:middleInitial lastName:lastName suffix:suffix email:email photoURL:photoURL photo:photo];
    
    if (self) {
        _role = role;
    }
    
    return self;
}

-(instancetype)initWithJSONDictionary:(NSDictionary *)jsonResponse {
    
    self = [super initWithJSONDictionary:jsonResponse];
    
    if (self) {
        _role = jsonResponse[APIParamUserRole];
    }
    
    return self;
}

+ (NSDictionary *)dictionaryFromUser:(Support *)support {
    
    NSMutableDictionary *userDictionary = [[super dictionaryFromUser:support] mutableCopy];
    
    userDictionary[APIParamUserRole] = support.role;
    
    return userDictionary;
}

- (id)copy {
 
    Support *supportCopy = [super copy];

    supportCopy.role = self.role;
    
    return supportCopy;
}

-(NSString *)description {
    
    NSString *superDesc = [super description];
    
    NSString *subDesc = [NSString stringWithFormat:@"\nName: %@ %@",self.firstName, self.lastName];
    
    return [superDesc stringByAppendingString:subDesc];
}

@end
