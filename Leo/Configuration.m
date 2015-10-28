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
static NSString *const ConfigurationAPIVersion = @"ApiVersion";
static NSString *const ConfigurationS3Endpoint = @"S3URL";
static NSString *const ConfigurationSelfSignedCertificate = @"SelfSignedCertificate";

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
+ (NSString *)APIEndpoint {
    Configuration *sharedConfiguration = [Configuration sharedConfiguration];
    
    if (sharedConfiguration.appSettings) {
        return [sharedConfiguration.appSettings objectForKey:ConfigurationAPIEndpoint];
    }
    
    return nil;
}

+ (NSString *)S3Endpoint {
    
    Configuration *sharedConfiguration = [Configuration sharedConfiguration];
    
    if (sharedConfiguration.appSettings) {
        return [sharedConfiguration.appSettings objectForKey:ConfigurationS3Endpoint];
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

+ (NSString *)APIEndpointWithHTTPSProtocol {
    return [NSString stringWithFormat:@"https://%@",[self APIEndpoint]];
}

+ (NSString *)selfSignedCertificate {
    
    Configuration *sharedConfiguration = [Configuration sharedConfiguration];
    
    if (sharedConfiguration.appSettings) {
        return [sharedConfiguration.appSettings objectForKey:ConfigurationSelfSignedCertificate];
    }
    
    return nil;}
@end
