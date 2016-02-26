//
//  Configuration.m
//  Leo
//
//  Created by Zachary Drossman on 8/18/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//
//  Adapted from source: http://code.tutsplus.com/tutorials/ios-quick-tip-managing-configurations-with-ease--mobile-18324

#import "Configuration.h"

static NSString *const ConfigurationAPIEndpoint = @"ApiURL";
static NSString *const ConfigurationProviderEndpoint = @"ProviderURL";
static NSString *const ConfigurationAPIVersion = @"ApiVersion";
static NSString *const ConfigurationContentURL = @"ContentURL";
static NSString *const ConfigurationSelfSignedCertificate = @"SelfSignedCertificate";
static NSString *const ConfigurationAPIProtocol = @"ApiProtocol";
static NSString *const ConfigurationPusherKey = @"PusherKey";
static NSString *const ConfigurationCrittercismAppID = @"CrittercismAppID";

@interface Configuration ()

@property (copy, nonatomic) NSDictionary *appSettings;

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


+ (NSString *)ContentURL {
    
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

+ (NSString *)pusherKey {

    Configuration *sharedConfiguration = [Configuration sharedConfiguration];

    if (sharedConfiguration.appSettings) {
        return [sharedConfiguration.appSettings objectForKey:ConfigurationPusherKey];
    }

    return nil;
}

+ (NSString *)crittercismAppID {

    Configuration *sharedConfiguration = [Configuration sharedConfiguration];

    if (sharedConfiguration.appSettings) {
        return [sharedConfiguration.appSettings objectForKey:ConfigurationCrittercismAppID];
    }

    return nil;
}

@end
