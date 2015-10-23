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

+ (NSString *)APIEndpoint;
+ (NSString *)APIVersion;
+ (NSString *)APIEndpointWithHTTPSProtocol;
+ (NSString *)S3Endpoint;
//+ (BOOL)isLoggingEnabled;

@end