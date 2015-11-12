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

static SessionUser *_currentUser = nil;
static LEOCredentialStore *_credentialStore = nil;
static dispatch_once_t onceToken;

+ (instancetype)currentUser {
    
    return [SessionUser newUserWithJSONDictionary:nil];
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
        _currentUser = nil;
        onceToken = 0;
        [_credentialStore clearSavedCredentials];
    } else {
        _currentUser = user;
    }
}

+ (void)setCurrentUserWithJSONDictionary:(NSDictionary *)jsonDictionary {
    
    if (!jsonDictionary) {
        _currentUser = nil;
        onceToken = 0;
        [_credentialStore clearSavedCredentials];
    } else {
        _currentUser = [SessionUser newUserWithJSONDictionary:jsonDictionary];
    }
}

+ (BOOL)isLoggedIn {
    
    if (!_credentialStore) {
        _credentialStore = [[LEOCredentialStore alloc] init];
    }
    
    if (_credentialStore.authToken != nil) {
        return YES;
    }
    
    return NO;
}

//TODO: Eventually need to actually inform the server of the logging out...
+ (void)logout {
    
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
//        NSString *authToken = jsonResponse[APIParamSession][APIParamToken];
//        
//        if (authToken) {
//            [SessionUser setAuthToken:authToken];
//        }
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
