//
//  DeviceToken.m
//  Leo
//
//  Created by Zachary Drossman on 11/20/15.
//  Copyright © 2015 Leo Health. All rights reserved.
//

#import "DeviceToken.h"

@implementation DeviceToken

static DeviceToken *_deviceToken = nil;
static NSString *_token = nil;
static dispatch_once_t onceToken;

//FIXME: This doesn't *really* work without further code given you could void the authToken and then it would say you weren't logged in, but not have reset the SessionUser. Need to send a notification that "resets" this singleton. It will suffice for the time-being until we are logging in multiple users on the same phone.

+ (void)resetDeviceToken {
    
    onceToken = 0;
    _deviceToken = nil;
}

+ (NSString *)token {
    
    return _token;
}

+ (instancetype)createTokenWithString:(NSString *)token {
    
    if (onceToken) {
        _token = token;
    }
    
    dispatch_once(&onceToken, ^{
        
        _deviceToken = [[self alloc] init];
        _token = token;
    });
    
    return _deviceToken;
}
@end
