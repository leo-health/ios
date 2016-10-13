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
    return [self secureValueForKey:SERVICE_NAME];
}

+ (void)setAuthToken:(NSString *)authToken {
    [self setSecureValue:authToken forKey:SERVICE_NAME];
    
    if (!authToken) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationTokenInvalidated object:self];
    }
}

+ (void)setSecureValue:(NSString *)value forKey:(NSString *)key {
    if (value) {

        NSError *error;

        [SAMKeychain setPassword:value
                     forService:AUTH_TOKEN_KEY
                        account:key
         error:&error];

        if (error) {
 
        }
    } else {
        [SAMKeychain deletePasswordForService:AUTH_TOKEN_KEY account:key];
    }
}

+ (NSString *)secureValueForKey:(NSString *)key {
    return [SAMKeychain passwordForService:AUTH_TOKEN_KEY account:key];
}


@end
