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


//FIXME: This doesn't *really* work without further code given you could void the authToken and then it would say you weren't logged in, but not have reset the SessionUser. Need to send a notification that "resets" this singleton. It will suffice for the time-being until we are logging in multiple users on the same phone.
+ (instancetype)newUserWithJSONDictionary:(NSDictionary *)jsonDictionary {
    
    static SessionUser *currentUser;
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


//TODO: Add an assertion to warn programmer here.
-(instancetype)init {
    return nil;
}

- (instancetype)initWithJSONDictionary:(NSDictionary *)jsonResponse {
    
   self = [super initWithJSONDictionary:jsonResponse[APIParamUser]];
    
    if (self) {
        NSString *authToken = jsonResponse[APIParamSession][APIParamToken];
        
        if (authToken) {
            [self setAuthToken:authToken];
        }
    }
    
    return self;
}


- (void)setAuthToken:(NSString *)authToken {
    LEOCredentialStore *store = [[LEOCredentialStore alloc] init];
    store.authToken = authToken;
    
    //TODO: Merge in changes from issue #295 here to complete this method!
}


@end
