//
//  Configuration.m
//  Leo
//
//  Created by Zachary Drossman on 8/18/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//
//  Adapted from source: http://code.tutsplus.com/tutorials/ios-quick-tip-managing-configurations-with-ease--mobile-18324

#import "Configuration.h"
#import "NSUserDefaults+Extensions.h"
#import <Crittercism/Crittercism.h>
#import "LEOSettingsService.h"
#import "LEOPusherHelper.h"
#import "LEOSession.h"
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>
#import <Localytics/Localytics.h>
#import <Stripe/Stripe.h>

#import "AppDelegate.h"

//FIXME: Decide whether to move these to LEOConstants or move the ones in LEOConstants to here
static NSString *const ConfigurationAPIEndpoint = @"ApiURL";
static NSString *const ConfigurationProviderEndpoint = @"ProviderURL";
static NSString *const ConfigurationAPIVersion = @"ApiVersion";
static NSString *const ConfigurationContentURL = @"ContentURL";
static NSString *const ConfigurationSelfSignedCertificate = @"SelfSignedCertificate";
static NSString *const ConfigurationAPIProtocol = @"ApiProtocol";

@interface Configuration ()

@property (copy, nonatomic) NSDictionary *appSettings;
@property (copy, nonatomic) NSString *minimumVersion;

@end

@implementation Configuration

#pragma mark -
#pragma mark Shared Configuration
+ (Configuration *)sharedConfiguration {
    
    static Configuration *_sharedConfiguration = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedConfiguration = [[self alloc] init];
    });
    
    return _sharedConfiguration;
}

#pragma mark -
#pragma mark Private Initialization
- (id)init {

    self = [super init];
    
    if (self) {
        // Fetch App Settings
        NSBundle *mainBundle = [NSBundle mainBundle];
        self.appSettings = [[mainBundle infoDictionary] objectForKey:@"AppSettings"];
    }
    
    return self;
}

#pragma mark -

+ (NSString *)providerBaseURL {

    return [self providerEndpointWithProtocol];
}

+ (NSString *)APIBaseURL {

    return [NSString stringWithFormat:@"%@/%@",[Configuration APIEndpointWithProtocol],[Configuration APIVersion]];
}

+ (NSString *)APIEndpoint {

    Configuration *sharedConfiguration = [Configuration sharedConfiguration];
    
    if (sharedConfiguration.appSettings) {
        return [sharedConfiguration.appSettings objectForKey:ConfigurationAPIEndpoint];
    }
    
    return nil;
}

+ (NSString *)providerEndpoint {

    Configuration *sharedConfiguration = [Configuration sharedConfiguration];

    if (sharedConfiguration.appSettings) {
        return [sharedConfiguration.appSettings objectForKey:ConfigurationProviderEndpoint];
    }

    return nil;
}

+ (NSString *)APIProtocol {
    
    Configuration *sharedConfiguration = [Configuration sharedConfiguration];
    
    if (sharedConfiguration.appSettings) {
        return [sharedConfiguration.appSettings objectForKey:ConfigurationAPIProtocol];
    }
    
    return nil;
}


+ (NSString *)contentURL {
    
    Configuration *sharedConfiguration = [Configuration sharedConfiguration];
    
    if (sharedConfiguration.appSettings) {
        return [sharedConfiguration.appSettings objectForKey:ConfigurationContentURL];
    }
    
    return nil;
}

+ (NSString *)APIVersion {
    Configuration *sharedConfiguration = [Configuration sharedConfiguration];
    
    if (sharedConfiguration.appSettings) {
        return [sharedConfiguration.appSettings objectForKey:ConfigurationAPIVersion];
    }
    
    return nil;
}

+ (NSString *)providerEndpointWithProtocol {

    return [NSString stringWithFormat:@"%@://%@",[self APIProtocol],[self providerEndpoint]];
}

+ (NSString *)APIEndpointWithProtocol {
    
    return [NSString stringWithFormat:@"%@://%@",[self APIProtocol],[self APIEndpoint]];
}

+ (NSString *)selfSignedCertificate {
    
    Configuration *sharedConfiguration = [Configuration sharedConfiguration];
    
    if (sharedConfiguration.appSettings) {
        return [sharedConfiguration.appSettings objectForKey:ConfigurationSelfSignedCertificate];
    }
    
    return nil;
}

+ (NSString *)minimumVersion {
    return [NSUserDefaults leo_stringForKey:kConfigurationMinimumVersion];
}

+ (NSString *)pusherKey {
    return [NSUserDefaults leo_stringForKey:kConfigurationPusherAPIKey];
}

+ (NSString *)crittercismAppID {
    return [NSUserDefaults leo_stringForKey:kConfigurationCrittercismAppID];
}

+ (NSString *)localyticsAppID {
    return [NSUserDefaults leo_stringForKey:kConfigurationLocalyticsAppID];
}

+ (void)updateCrittercismWithNewKeys {

    [Crittercism enableWithAppID:[Configuration crittercismAppID]];

    if ([Configuration vendorID]) {
        [Crittercism setUsername:[Configuration vendorID]];
    }
}

+ (void)updateCrashlyticsWithNewKeys {

    [Fabric with:@[[Crashlytics class]]];
    [[Crashlytics sharedInstance] setUserIdentifier:[Configuration vendorID]];
}

+ (NSString *)vendorID {

    return [LEOSession user].anonymousCustomerServiceID ? : [NSUserDefaults leo_stringForKey:kConfigurationVendorID];
}

+ (void)resetVendorID {
    [NSUserDefaults leo_removeObjectForKey:kConfigurationVendorID];
    [[LEOSession user] resetAnonymousCustomerServiceID];
}

+ (NSString *)stripeKey {
    return [NSUserDefaults leo_stringForKey:kConfigurationStripePublishableKey];
}

+ (void)resetStripeKey {
    [NSUserDefaults leo_removeObjectForKey:kConfigurationStripePublishableKey];
}

+ (void)updateStripeKey {
    [Stripe setDefaultPublishableKey:[Configuration stripeKey]];
}

+ (void)clearRemoteEnvironmentVariables {

    [NSUserDefaults leo_removeObjectForKey:kConfigurationPusherAPIKey];
    [NSUserDefaults leo_removeObjectForKey:kConfigurationCrittercismAppID];
    [NSUserDefaults leo_removeObjectForKey:kConfigurationLocalyticsAppID];
    [NSUserDefaults leo_removeObjectForKey:kConfigurationVendorID];
    [NSUserDefaults leo_removeObjectForKey:kConfigurationStripePublishableKey];
    [NSUserDefaults leo_removeObjectForKey:kConfigurationMinimumVersion];
}

+ (BOOL)isMissingKeys {
    return (![Configuration pusherKey] || ![Configuration crittercismAppID] || ![Configuration localyticsAppID] || ![Configuration vendorID] || ![Configuration stripeKey] || [Configuration minimumVersion]);
}

+ (void)downloadRemoteEnvironmentVariablesIfNeededWithCompletion:(void (^) (BOOL success, NSError *error))completionBlock {

    if ([self isMissingKeys]) {

        [[LEOSettingsService new] getConfigurationWithCompletion:^(BOOL success, NSError *error) {

            if (completionBlock) {
                completionBlock(success, error);
            }
        }];
    } else {

        if (completionBlock) {
            completionBlock(YES, nil);
        }
    }
}

+ (void)checkVersionRequirementMetWithCompletion:(void (^) (BOOL meetsMinimumVersionRequirements, NSError *error))completionBlock {

    [Configuration downloadRemoteEnvironmentVariablesIfNeededWithCompletion:^(BOOL success, NSError *error) {

        if (error) {
            if (completionBlock) {
                completionBlock(nil, error);
            }
        }

        if ([Configuration minimumVersion] > [LEOSession appVersion]) {

            if (completionBlock) {
                completionBlock(NO, nil);
                [LEOSession logout];
            }
        } else {

            if (completionBlock) {
                completionBlock(YES, nil);
            }
        }
    }];
}


@end
