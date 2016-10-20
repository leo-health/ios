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
#import "LEOPusherHelper.h"
#import "LEOUserService.h"
#import "LEOCredentialStore.h"

@implementation LEOSettingsService

- (void)getConfigurationWithCompletion:(void (^)(BOOL success, NSError *error))completionBlock {

    [[LEOSettingsService leoSessionManager] unauthenticatedGETRequestForJSONDictionaryFromAPIWithEndpoint:APIEndpointConfiguration params:nil completion:^(NSDictionary *rawResults, NSError *error) {

        if (!error) {

            NSDictionary *keyData = rawResults[APIParamData];

            [Configuration updateCrittercismWithNewKeys];

            if (![[Configuration pusherKey] isEqualToString:[keyData leo_itemForKey:kConfigurationPusherAPIKey]]) {

                [NSUserDefaults leo_setString:[keyData leo_itemForKey:kConfigurationPusherAPIKey] forKey:kConfigurationPusherAPIKey];
                [[LEOPusherHelper sharedPusher] updateClientForNewKeys];
            }

            if ([Configuration vendorID] == nil || [LEOCredentialStore authToken] == nil) {

                [NSUserDefaults leo_setString:[keyData leo_itemForKey:kConfigurationVendorID] forKey:kConfigurationVendorID];
                [Localytics setCustomerId:[Configuration vendorID]];
                [Configuration updateCrashlyticsWithNewKeys];
                [Configuration setHasReviewedVendorID:@"YES"];
            }

            //HAX: ZSD - This is a patch for an issue prior to v1.4.2 where the vendorID was incorrect. The `hasReviewedVendorID` would be nil since it was created just for this purpose, so any user on a version prior to v1.4.2 would experience this path forward because they would have a prior vendorID but it would not be a reviewed one. Once all users are on v1.4.2 or later, this condition can be removed from the code base as it should no longer be relevant.
            if (![Configuration hasReviewedVendorID] && [Configuration vendorID]) {

                NSDictionary *userDictionary = [[NSUserDefaults standardUserDefaults] objectForKey:APIEndpointCurrentUser];
                [NSUserDefaults leo_setString:[userDictionary leo_itemForKey:kConfigurationVendorID] forKey:kConfigurationVendorID];
                [Localytics setCustomerId:[Configuration vendorID]];
                [Configuration updateCrashlyticsWithNewKeys];
                [Configuration setHasReviewedVendorID:@"YES"];
            }

            if (![[Configuration crittercismAppID] isEqualToString:[keyData leo_itemForKey:kConfigurationCrittercismAppID]]) {

                [NSUserDefaults leo_setString:[keyData leo_itemForKey:kConfigurationCrittercismAppID] forKey:kConfigurationCrittercismAppID];
                [Configuration updateCrittercismWithNewKeys];
            }

            if (![[Configuration stripeKey] isEqualToString:[keyData leo_itemForKey:kConfigurationStripePublishableKey]]) {

                [NSUserDefaults leo_setString:[keyData leo_itemForKey:kConfigurationStripePublishableKey] forKey:kConfigurationStripePublishableKey];
                [Configuration updateStripeKey];
            }

            if (![[Configuration minimumVersion] isEqualToString:[keyData leo_itemForKey:kConfigurationMinimumVersion]]) {
                [NSUserDefaults leo_setString:[keyData leo_itemForKey:kConfigurationMinimumVersion] forKey:kConfigurationMinimumVersion];
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
