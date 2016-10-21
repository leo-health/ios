//
//  Configuration.h
//  Leo
//
//  Created by Zachary Drossman on 8/18/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//
//  Adapted from source: http://code.tutsplus.com/tutorials/ios-quick-tip-managing-configurations-with-ease--mobile-18324

#import <Foundation/Foundation.h>

@interface Configuration : NSObject



+ (void)downloadRemoteEnvironmentVariablesIfNeededWithCompletion:(void (^) (BOOL success, NSError *error))completionBlock;
+ (void)checkVersionRequirementMetWithCompletion:(void (^) (BOOL meetsMinimumVersionRequirements, NSError *error))completionBlock;

+ (BOOL)hasVersionChanged;
+ (void)updateCrittercismWithNewKeys;
+ (void)updateCrashlyticsWithNewKeys;
+ (void)updateLocalyticsWithNewKeys;
+ (void)updateStripeKey;
+ (void)clearRemoteEnvironmentVariables;
+ (void)resetStripeKey;
+ (NSString *)minimumVersion;
+ (void)resetConfiguration;

+ (BOOL)hasReviewedVendorID;
+ (void)setHasReviewedVendorID:(NSString *)hasReviewedVendorID;

+ (NSString *)APIBaseURL;
+ (NSString *)providerBaseURL;
+ (NSString *)APIEndpoint;
+ (NSString *)APIVersion;
+ (NSString *)APIEndpointWithProtocol;
+ (NSString *)contentURL;
+ (NSString *)selfSignedCertificate;
+ (NSString *)pusherKey;
+ (NSString *)crittercismAppID;
+ (NSString *)vendorID;
+ (NSString *)stripeKey;


@end
