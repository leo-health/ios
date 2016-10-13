//
//  LEOCredentialStore.m
//  Leo
//
//  Created by Zachary Drossman on 8/31/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//  Adopted from Ben Scheirman (Fickle Bits, LLC) and NSScreencast (http://www.nsscreencast.com/episodes/41-authentication-with-afnetworking)

#import "LEOCredentialStore.h"
#import "SAMKeychain.h"
#import "LEOConstants.h"

#define SERVICE_NAME @"LEO-AuthClient"
#define AUTH_TOKEN_KEY @"auth_token"

@implementation LEOCredentialStore

+ (void)clearSavedCredentials {
    [self setAuthToken:nil];
}

+ (NSString *)authToken {
    return [self secureValueForKey:AUTH_TOKEN_KEY];
}

+ (void)setAuthToken:(NSString *)authToken {
    [self setSecureValue:authToken
                  forKey:AUTH_TOKEN_KEY];
    
    if (!authToken) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationTokenInvalidated
                                                            object:self];
    }
}

+ (void)setSecureValue:(NSString *)value forKey:(NSString *)key {
    if (value) {

        NSError *error;

        [SAMKeychain setPassword:value
                     forService:SERVICE_NAME
                        account:key
         error:&error];

        if (error) {
            //TODO: Add a log here but use CocoaLumberjack or another tool. Should only get logging when in debug mode / developer mode.
        }
        
    } else {
        [SAMKeychain deletePasswordForService:SERVICE_NAME account:key];
    }
}

+ (NSString *)secureValueForKey:(NSString *)key {
    return [SAMKeychain passwordForService:SERVICE_NAME account:key];
}

@end
