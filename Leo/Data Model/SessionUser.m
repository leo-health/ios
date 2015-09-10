//
//  SessionUser.m
//  Leo
//
//  Created by Zachary Drossman on 8/31/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import "SessionUser.h"
#import "LEOCredentialStore.h"

@interface SessionUser()

@end

@implementation SessionUser

+ (instancetype)currentUser {
    
    return [SessionUser newUserWithJSONDictionary:nil];
}

+ (instancetype)newUserWithJSONDictionary:(NSDictionary *)jsonDictionary {
    
    static SessionUser *currentUser = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        currentUser = [[self alloc] initWithJSONDictionary:jsonDictionary];
    });
    return currentUser;
}


- (BOOL)isLoggedIn {
    
    return [[self credentialStore] authToken] != nil;
}

- (LEOCredentialStore *)credentialStore {
    
    return [[LEOCredentialStore alloc] init];;
}

-(instancetype)init {
    return nil;
}

- (instancetype)initWithJSONDictionary:(NSDictionary *)jsonResponse {
   self = [super initWithJSONDictionary:jsonResponse[APIParamUser]];
    
    if (self) {
        NSString *authToken = jsonResponse[@"authentication_token"];
        
        if (authToken) {
            [self setAuthToken:authToken];
        }
    }
    
    return self;
}

- (void)updateWithJSONDictionary:(NSDictionary *)jsonResponse {
    
    [super updateWithJSONDictionary:jsonResponse[APIParamUser]];
    
    NSString *authToken = jsonResponse[@"authentication_token"];
    
    if (authToken) {
        [self setAuthToken:authToken];
    }
}


- (void)setAuthToken:(NSString *)authToken {
    LEOCredentialStore *store = [[LEOCredentialStore alloc] init];
    store.authToken = authToken;
    
    //TODO: Merge in changes from issue #295 here to complete this method!
}

@end
