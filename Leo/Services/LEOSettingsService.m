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

    [[LEOSettingsService leoSessionManager] unauthenticatedGETRequestForJSONDictionaryFromAPIWithEndpoint:APIEndpointConfiguration params:nil completion:^(NSDictionary *rawResults, NSError *error) {

        if (!error) {

            NSDictionary *keyData = rawResults[APIParamData];

            [Configuration updateCrittercismWithNewKeys];

            if (![[Configuration pusherKey] isEqualToString:[keyData leo_itemForKey:kConfigurationPusherAPIKey]]) {
                [NSUserDefaults leo_setString:[keyData leo_itemForKey:kConfigurationPusherAPIKey] forKey:kConfigurationPusherAPIKey];
                //Pusher will update as connections are made.
            }

            if (![[Configuration vendorID] isEqualToString:[keyData leo_itemForKey:kConfigurationVendorID]]) {

                [NSUserDefaults leo_setString:[keyData leo_itemForKey:kConfigurationVendorID] forKey:kConfigurationVendorID];
                [Configuration updateCrashlyticsWithNewKeys];
            }

            if (![[Configuration localyticsAppID] isEqualToString:[keyData leo_itemForKey:kConfigurationLocalyticsAppID]]) {

                [NSUserDefaults leo_setString:[keyData leo_itemForKey:kConfigurationLocalyticsAppID] forKey:kConfigurationLocalyticsAppID];
                [Localytics setCustomerId:[Configuration vendorID]];
            }

            if (![[Configuration crittercismAppID] isEqualToString:[keyData leo_itemForKey:kConfigurationCrittercismAppID]]) {

                [NSUserDefaults leo_setString:[keyData leo_itemForKey:kConfigurationCrittercismAppID] forKey:kConfigurationCrittercismAppID];
                [Configuration updateCrittercismWithNewKeys];
            }

            if (![[Configuration stripeKey] isEqualToString:[keyData leo_itemForKey:kConfigurationStripePublishableKey]]) {

                [NSUserDefaults leo_setString:[keyData leo_itemForKey:kConfigurationStripePublishableKey] forKey:kConfigurationStripePublishableKey];
                [Configuration updateStripeKey];
            }

            [NSUserDefaults leo_saveDefaults];
        }

        if (completionBlock) {
            completionBlock(!error, error);
        }
    }];
}

+ (LEOAPISessionManager *)leoSessionManager {
    return [LEOAPISessionManager sharedClient];
}

@end
