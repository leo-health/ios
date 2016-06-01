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

static NSString *const kBundleVersionString = @"CFBundleVersion";
static NSString *const kBundleShortVersionString = @"CFBundleShortVersionString";

//TODO: Add an assertion to warn programmer here.
//-(instancetype)init {
//    return nil;
//}

+ (instancetype)currentSession {

    dispatch_once(&onceToken, ^{
        _currentSession = [[self alloc] initFromUserDefaults];
    });

    return _currentSession;
}


- (instancetype)initFromUserDefaults {

    NSDictionary *guardianDictionary = [[NSUserDefaults standardUserDefaults] objectForKey:LocalParamSessionUser];

    _user = [[Guardian alloc] initWithJSONDictionary:guardianDictionary];

    [_user incrementLoginCounter];

    _currentSession = [[LEOSession alloc] init];

    return _currentSession;
}

+ (Guardian *)user {
    return _user;
}

+ (void)setCurrentSessionWithUserDictionary:(NSDictionary *)jsonDictionary authenticationToken:(NSString *)authenticationToken {

    Guardian *guardian = [[Guardian alloc] initWithJSONDictionary:jsonDictionary];

    [self setCurrentSessionWithGuardian:guardian authenticationToken:authenticationToken];
}

+ (void)saveSessionUserToUserDefaults {

    NSDictionary *guardianDictionary = [Guardian plistFromUser:_user];
    [[NSUserDefaults standardUserDefaults] setObject:guardianDictionary forKey:LocalParamSessionUser];
}

+ (void)setCurrentSessionWithGuardian:(Guardian *)guardian authenticationToken:(NSString *)authenticationToken {

    [self reset];
    if (!guardian) {
        [_credentialStore clearSavedCredentials];
    } else {

        _currentSession = [LEOSession newSessionWithGuardian:guardian];

        if (authenticationToken) {
            [self setAuthToken:authenticationToken];
        }
    }
}

+ (void)updateCurrentSessionWithUserDictionary:(NSDictionary *)jsonDictionary {
    [self setCurrentSessionWithUserDictionary:jsonDictionary authenticationToken:nil];
}

+ (void)updateCurrentSessionWithGuardian:(Guardian *)guardian {
    [self setCurrentSessionWithGuardian:guardian authenticationToken:nil];
}


+ (instancetype)newSessionWithGuardian:(Guardian *)guardian {

    dispatch_once(&onceToken, ^{

        _currentSession = [[LEOSession alloc] init];

        _user = guardian;
        [self saveSessionUserToUserDefaults];
    });

    return _currentSession;
}

+ (NSString *)appBuild {

    return [[NSBundle mainBundle] objectForInfoDictionaryKey:kBundleVersionString];
}

+ (NSString *)appVersion {
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:kBundleShortVersionString];
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

+ (void)reset {

    _currentSession = nil;
    _user = nil;
    onceToken = 0;
}

+ (BOOL)isLoggedIn {

    if (!_credentialStore) {
        _credentialStore = [[LEOCredentialStore alloc] init];
    }

    NSDictionary *guardianDictionary = [[NSUserDefaults standardUserDefaults] objectForKey:LocalParamSessionUser];

    if (guardianDictionary) {
        _user = [[Guardian alloc] initWithJSONDictionary:guardianDictionary];
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
