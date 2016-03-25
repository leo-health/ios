//
//  SessionUser.m
//  Leo
//
//  Created by Zachary Drossman on 8/31/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import "SessionUser.h"
#import "LEOCredentialStore.h"
#import "Configuration.h"

@interface SessionUser()

@end

@implementation SessionUser

static SessionUser *_currentUser = nil;
static LEOCredentialStore *_credentialStore = nil;
static dispatch_once_t onceToken;

+ (instancetype)currentUser {
    if (!_currentUser) {
        _currentUser = [[SessionUser alloc] initFromUserDefaults];
    }
    return _currentUser;
}

+ (instancetype)guardian {
    return _currentUser;
}


//FIXME: This doesn't *really* work without further code given you could void the authToken and then it would say you weren't logged in, but not have reset the SessionUser. Need to send a notification that "resets" this singleton. It will suffice for the time-being until we are logging in multiple users on the same phone.
+ (instancetype)newUserWithJSONDictionary:(NSDictionary *)jsonDictionary {
    dispatch_once(&onceToken, ^{
        
        _currentUser = [[self alloc] initWithJSONDictionary:jsonDictionary];
    });
    
    return _currentUser;
}

+ (void)setCurrentUser:(SessionUser *)user {

    if (!user) {
        [self reset];
        [_credentialStore clearSavedCredentials];
    } else {
        _currentUser = user;
    }
}

+ (void)setCurrentUserWithJSONDictionary:(NSDictionary *)jsonDictionary {
    
    [self reset];
    if (!jsonDictionary) {
        [_credentialStore clearSavedCredentials];
    } else {
        _currentUser = [SessionUser newUserWithJSONDictionary:jsonDictionary];
        
        //Have added this here so that when the currentUser is replaced, we also check for membership changes at that time (once object has been instantiated.)
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationMembershipChanged object:self];
    }
}

+ (void)reset {
    
    _currentUser = nil;
    onceToken = 0;
}

+ (BOOL)isLoggedIn {

    if (!_credentialStore) {
        _credentialStore = [[LEOCredentialStore alloc] init];
    }

    return [self currentUser] && _credentialStore.authToken;
}

//TODO: Eventually need to actually inform the server of the logging out...
+ (void)logout {

    [LEOBreadcrumb crumbWithFunction:__PRETTY_FUNCTION__];

    [self removeFromUserDefaults];
    [Configuration clearRemoteEnvironmentVariables];

    [_credentialStore clearSavedCredentials];
}



//TODO: Add an assertion to warn programmer here.
-(instancetype)init {
    return nil;
}


//TODO: Check if this is even being used. It should probably be removed altogether at this point.
- (instancetype)initWithJSONDictionary:(NSDictionary *)jsonResponse {
    
   self = [super initWithJSONDictionary:jsonResponse[APIParamUser]];
    
    if (self) {
        
        //Ensure the SessionUser guardian is saved to NSUserDefaults at time of creation. We should not allow changes to the guardian without replacing the entirety of the Guardian! Will have to come back to this and how we 
        [self saveToUserDefaults];
    }
    
    return self;
}

+ (void)setAuthToken:(NSString *)authToken {
    _credentialStore = [[LEOCredentialStore alloc] init];
    _credentialStore.authToken = authToken;
}

+ (NSString *)authToken {
    return _credentialStore.authToken;
}

@end
