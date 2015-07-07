//
//  Caretaker.m
//  Leo
//
//  Created by Zachary Drossman on 7/2/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import "Caretaker.h"
#import "LEOConstants.h"

@implementation Caretaker


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

+ (NSDictionary *)dictionaryFromUser:(Caretaker *)caretaker {
    
    NSMutableDictionary *userDictionary = [[super dictionaryFromUser:caretaker] mutableCopy];
    
    userDictionary[APIParamUserPrimary] = @(caretaker.primary);
    userDictionary[APIParamUserRelationship] = caretaker.relationship;
    
    return userDictionary;
    
}

@end
