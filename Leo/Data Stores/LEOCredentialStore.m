//
//  LEOCredentialStore.m
//  Leo
//
//  Created by Zachary Drossman on 8/31/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//  Adopted from Ben Scheirman (Fickle Bits, LLC) and NSScreencast (http://www.nsscreencast.com/episodes/41-authentication-with-afnetworking)

#import "LEOCredentialStore.h"
#import "SSKeychain.h"

#define SERVICE_NAME @"LEO-AuthClient"
#define AUTH_TOKEN_KEY @"auth_token"

@interface LEOCredentialStore ()

@property (copy, nonatomic) NSString *authToken;

@end

@implementation LEOCredentialStore

//@synthesize authToken = _authToken;

//- (instancetype)initWithAuthToken:(NSString *)authToken {
//    
//    self = [super init];
//    
//    if (self) {
//        
//        _authToken = authToken;
//    }
//    
//    return self;
//}

- (void)clearSavedCredentials {
    [self setAuthToken:nil];
}

- (NSString *)authToken {
    return [self secureValueForKey:AUTH_TOKEN_KEY];
}

- (void)setAuthToken:(NSString *)authToken {
    [self setSecureValue:authToken forKey:AUTH_TOKEN_KEY];
    
    if (!authToken) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"token-invalidated" object:self];
    }
}


- (void)setSecureValue:(NSString *)value forKey:(NSString *)key {
    if (value) {
        [SSKeychain setPassword:value
                     forService:SERVICE_NAME
                        account:key];
    } else {
        [SSKeychain deletePasswordForService:SERVICE_NAME account:key];
    }
}

- (NSString *)secureValueForKey:(NSString *)key {
    return [SSKeychain passwordForService:SERVICE_NAME account:key];
}



@end
