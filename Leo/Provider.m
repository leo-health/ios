//
//  Provider.m
//  Leo
//
//  Created by Zachary Drossman on 7/2/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import "Provider.h"
#import "LEOConstants.h"

@implementation Provider

-(instancetype)initWithID:(nullable NSString *)id title:(nullable NSString *)title firstName:(NSString *)firstName middleInitial:(nullable NSString *)middleInitial lastName:(NSString *)lastName suffix:(nullable NSString *)suffix email:(NSString *)email photoURL:(nullable NSURL *)photoURL photo:(UIImage *)photo credentialSuffix:(NSString *)credential specialty:(NSString *)specialty {
    
    self = [super initWithID:id title:title firstName:firstName middleInitial:middleInitial lastName:lastName suffix:suffix email:email photoURL:photoURL photo:photo];
    
    if (self) {
        _credential = credential;
        _specialty = specialty;
    }
    
    return self;
}

-(instancetype)initWithJSONDictionary:(NSDictionary *)jsonResponse {
    
    self = [super initWithJSONDictionary:jsonResponse];
    
    if (self) {
        _credential = jsonResponse[APIParamUserCredentialSuffix];
        _specialty = jsonResponse[APIParamUserSpecialty];
    }
    
    return self;
}

+ (NSDictionary *)dictionaryFromUser:(Provider *)provider {
    
    NSMutableDictionary *userDictionary = [[super dictionaryFromUser:provider] mutableCopy];
    
    userDictionary[APIParamUserCredentialSuffix] = provider.credential;
    userDictionary[APIParamUserSpecialty] = provider.specialty;
    
    return userDictionary;
}

@end
