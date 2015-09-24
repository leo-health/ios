//
//  SessionUser.h
//  Leo
//
//  Created by Zachary Drossman on 8/31/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Guardian.h"
#import "LEODataManager.h"
#import "LEOCredentialStore.h"

@interface SessionUser : Guardian

@property (strong, nonatomic) LEODataManager *dataManager;
@property (strong, nonatomic) LEOCredentialStore *credentialStore;

+ (instancetype)currentUser;
+ (instancetype)newUserWithJSONDictionary:(NSDictionary *)jsonDictionary;

@end
