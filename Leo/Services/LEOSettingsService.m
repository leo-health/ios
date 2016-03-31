//
//  LEOSettingsService.m
//  Leo
//
//  Created by Zachary Drossman on 3/21/16.
//  Copyright © 2016 Leo Health. All rights reserved.
//

#import "LEOSettingsService.h"
#import "LEOAPISessionManager.h"
#import "NSUserDefaults+Extensions.h"
#import "NSDictionary+Extensions.h"
#import "Configuration.h"
#import "AppDelegate.h"

@implementation LEOSettingsService

- (void)getConfigurationWithCompletion:(void (^)(BOOL success, NSError *error))completionBlock {

    [[LEOSettingsService leoSessionManager] standardGETRequestForJSONDictionaryFromAPIWithEndpoint:APIEndpointConfiguration params:nil completion:^(NSDictionary *rawResults, NSError *error) {

        NSDictionary *keyData = rawResults[APIParamData];

        [NSUserDefaults leo_setString:[keyData leo_itemForKey:kConfigurationCrittercismAppID] forKey:kConfigurationCrittercismAppID];
        [NSUserDefaults leo_setString:[keyData leo_itemForKey:kConfigurationPusherAPIKey] forKey:kConfigurationPusherAPIKey];

        [Configuration updateCrittercismWithNewKeys];
        [Configuration updateCrashlyticsWithNewKeys];

        if (![[Configuration localyticsAppID] isEqualToString:[keyData leo_itemForKey:kConfigurationLocalyticsAppID]]) {
            [NSUserDefaults leo_setString:[keyData leo_itemForKey:kConfigurationLocalyticsAppID] forKey:kConfigurationLocalyticsAppID];
            [Configuration updateLocalyticsWithNewKeys];
        }

        [NSUserDefaults leo_saveDefaults];

        if (completionBlock) {
            completionBlock(!error, error);
        }
    }];
}

+ (LEOAPISessionManager *)leoSessionManager {
    return [LEOAPISessionManager sharedClient];
}

@end
