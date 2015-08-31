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

@property (strong, nonatomic) LEOCredentialStore *credentialStore;

@end

@implementation SessionUser

- (BOOL)isLoggedIn {
    
    return [self.credentialStore authToken] != nil;
}

-(LEOCredentialStore *)credentialStore {
    
    if (!_credentialStore) {
       _credentialStore = [[LEOCredentialStore alloc] init];
    }
    
    return _credentialStore;
}

@end
