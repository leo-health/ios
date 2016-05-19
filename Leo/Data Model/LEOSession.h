//
//  LEOSession.h
//  Leo
//
//  Created by Zachary Drossman on 5/18/16.
//  Copyright © 2016 Leo Health. All rights reserved.
//

@class LEODevice;

#import <Foundation/Foundation.h>
#import "Guardian.h"

@interface LEOSession : NSObject


+ (instancetype)currentSession;
+ (void)setCurrentSessionWithUserDictionary:(NSDictionary *)jsonDictionary authenticationToken:(NSString *)authenticationToken;
+ (void)updateCurrentSessionWithUserDictionary:(NSDictionary *)jsonDictionary;

+ (Guardian *)user;
+ (BOOL)isLoggedIn;
+ (void)logout;

+ (NSString *)authToken;
+ (void)setAuthToken:(NSString *)authToken;

+ (NSDictionary *)sessionDictionaryWithoutUser;

+ (NSString *)appBuild;
+ (NSString *)appVersion;
+ (NSString *)deviceType;
+ (DeviceModel)deviceModel;
+ (NSString *)osVersion;

@end
