//
//  LEOSession.m
//  Leo
//
//  Created by Zachary Drossman on 5/18/16.
//  Copyright © 2016 Leo Health. All rights reserved.
//

#import "LEOSession.h"
#import "LEODevice.h"
#import "Guardian.h"
#import "LEOCredentialStore.h"
#import "Configuration.h"

@interface LEOSession ()

@end

@implementation LEOSession

static LEOSession *_currentSession = nil;
static Guardian *_user = nil;
static LEOCredentialStore *_credentialStore = nil;
static dispatch_once_t onceToken;

//TODO: Add an assertion to warn programmer here.
-(instancetype)init {
    return nil;
}

+ (instancetype)currentSession {

    dispatch_once(&onceToken, ^{
        _currentSession = [[self alloc] initFromUserDefaults];
    });

    return _currentSession;
}


- (instancetype)initFromUserDefaults {

    NSDictionary *guardianDictionary = [[NSUserDefaults standardUserDefaults] objectForKey:@"SessionUser"];

    _user = [[Guardian alloc] initWithJSONDictionary:guardianDictionary];

    [_user incrementLoginCounter];

    _currentSession = [[LEOSession alloc] init];

    return _currentSession;
}

+ (Guardian *)user {
    return _user;
}

+ (void)setCurrentSessionWithUserDictionary:(NSDictionary *)jsonDictionary authenticationToken:(NSString *)authenticationToken {

    [self reset];
    if (!jsonDictionary) {
        [_credentialStore clearSavedCredentials];
    } else {
        _currentSession = [LEOSession newSessionWithJSONDictionary:jsonDictionary];

        if (authenticationToken) {
            [self setAuthToken:authenticationToken];
        }
    }
}

+ (void)updateCurrentSessionWithUserDictionary:(NSDictionary *)jsonDictionary {
    [self setCurrentSessionWithUserDictionary:jsonDictionary authenticationToken:nil];
}

+ (instancetype)newSessionWithJSONDictionary:(NSDictionary *)jsonDictionary {

    dispatch_once(&onceToken, ^{

        _currentSession = [[self alloc] init];

        _user = [[Guardian alloc] initWithJSONDictionary:jsonDictionary[APIParamUserGuardian]];
        [_user saveToUserDefaults];

        //Have added this here so that when the currentUser is replaced, we also check for membership changes at that time (once object has been instantiated.)
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationMembershipChanged object:self];
    });

    return _currentSession;
}

+ (NSString *)appBuild {
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"];
}

+ (NSString *)appVersion {
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
}

+ (NSString *)deviceType {
    return [LEODevice deviceType];
}

+ (DeviceModel)deviceModel {
    return [LEODevice deviceModel];
}

+ (NSString *)osVersion {
    return [LEODevice osVersionString];
}

//FIXME: This doesn't *really* work without further code given you could void the authToken and then it would say you weren't logged in, but not have reset the session's user. Need to send a notification that "resets" this singleton. It will suffice for the time-being until we are logging in multiple users on the same phone.
//Not sure this is used anywhere. Remove if not.
+ (void)setCurrentSession:(LEOSession *)currentSession {

    if (!currentSession) {
        [self reset];
        [_credentialStore clearSavedCredentials];
    } else {
        _currentSession = currentSession;
    }
}


+ (void)reset {

    _currentSession = nil;
    _user = nil;
    onceToken = 0;
}

+ (BOOL)isLoggedIn {

    if (!_credentialStore) {
        _credentialStore = [[LEOCredentialStore alloc] init];
    }

    return _user && _credentialStore.authToken;
}

+ (void)logout {

    [LEOBreadcrumb crumbWithFunction:__PRETTY_FUNCTION__];

    [Guardian removeFromUserDefaults];
    [Configuration clearRemoteEnvironmentVariables];

    [_credentialStore clearSavedCredentials];

    [self reset];
}

+ (void)setAuthToken:(NSString *)authToken {
    _credentialStore = [[LEOCredentialStore alloc] init];
    _credentialStore.authToken = authToken;
}

+ (NSString *)authToken {
    return _credentialStore.authToken;
}

+ (NSDictionary *)sessionDictionaryWithoutUser {

    NSMutableDictionary *sessionDictionaryWithoutUser = [[LEODevice jsonDictionary] mutableCopy];
    [sessionDictionaryWithoutUser setObject:[self appVersion] forKey:APIParamSessionAppVersion];

    return [sessionDictionaryWithoutUser copy];
}

@end
