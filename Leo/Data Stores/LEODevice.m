//
//  LEODevice.m
//  Leo
//
//  Created by Zachary Drossman on 11/20/15.
//  Copyright © 2015 Leo Health. All rights reserved.
//

#import "LEODevice.h"
#import <sys/utsname.h>


#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_RETINA ([[UIScreen mainScreen] scale] >= 2.0)

#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define SCREEN_MIN_LENGTH (MIN(SCREEN_WIDTH, SCREEN_HEIGHT))

#define IS_IPHONE_4_OR_LESS (IS_IPHONE && SCREEN_MAX_LENGTH < 568.0)
#define IS_IPHONE_5 (IS_IPHONE && SCREEN_MAX_LENGTH == 568.0)
#define IS_IPHONE_6 (IS_IPHONE && SCREEN_MAX_LENGTH == 667.0)
#define IS_IPHONE_6P (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)

@implementation LEODevice

static LEODevice *_device = nil;
static NSString *_token = nil;
static dispatch_once_t onceToken;

//FIXME: This doesn't *really* work without further code given you could void the authToken and then it would say you weren't logged in, but not have reset the SessionUser. Need to send a notification that "resets" this singleton. It will suffice for the time-being until we are logging in multiple users on the same phone.

+ (void)resetDeviceToken {
    
    onceToken = 0;
    _device = nil;
}

+ (NSString *)deviceToken {
    
    return _token;
}

+ (instancetype)createTokenWithString:(NSString *)token {
    
    if (onceToken) {
        _token = token;
    }
    
    dispatch_once(&onceToken, ^{
        
        _device = [[self alloc] init];
        _token = token;
    });
    
    return _device;
}

// SOURCE: http://stackoverflow.com/questions/11197509/ios-how-to-get-device-make-and-model
+ (NSString*) deviceType {
    struct utsname systemInfo;

    uname(&systemInfo);

    NSString* code = [NSString stringWithCString:systemInfo.machine
                                        encoding:NSUTF8StringEncoding];

    static NSDictionary* deviceNamesByCode = nil;

    if (!deviceNamesByCode) {

        deviceNamesByCode = @{@"i386"      :@"Simulator",
                              @"x86_64"    :@"Simulator",
                              @"iPod1,1"   :@"iPod Touch",      // (Original)
                              @"iPod2,1"   :@"iPod Touch",      // (Second Generation)
                              @"iPod3,1"   :@"iPod Touch",      // (Third Generation)
                              @"iPod4,1"   :@"iPod Touch",      // (Fourth Generation)
                              @"iPod7,1"   :@"iPod Touch",      // (6th Generation)
                              @"iPhone1,1" :@"iPhone",          // (Original)
                              @"iPhone1,2" :@"iPhone",          // (3G)
                              @"iPhone2,1" :@"iPhone",          // (3GS)
                              @"iPad1,1"   :@"iPad",            // (Original)
                              @"iPad2,1"   :@"iPad 2",          //
                              @"iPad3,1"   :@"iPad",            // (3rd Generation)
                              @"iPhone3,1" :@"iPhone 4",        // (GSM)
                              @"iPhone3,3" :@"iPhone 4",        // (CDMA/Verizon/Sprint)
                              @"iPhone4,1" :@"iPhone 4S",       //
                              @"iPhone5,1" :@"iPhone 5",        // (model A1428, AT&T/Canada)
                              @"iPhone5,2" :@"iPhone 5",        // (model A1429, everything else)
                              @"iPad3,4"   :@"iPad",            // (4th Generation)
                              @"iPad2,5"   :@"iPad Mini",       // (Original)
                              @"iPhone5,3" :@"iPhone 5c",       // (model A1456, A1532 | GSM)
                              @"iPhone5,4" :@"iPhone 5c",       // (model A1507, A1516, A1526 (China), A1529 | Global)
                              @"iPhone6,1" :@"iPhone 5s",       // (model A1433, A1533 | GSM)
                              @"iPhone6,2" :@"iPhone 5s",       // (model A1457, A1518, A1528 (China), A1530 | Global)
                              @"iPhone7,1" :@"iPhone 6 Plus",   //
                              @"iPhone7,2" :@"iPhone 6",        //
                              @"iPhone8,1" :@"iPhone 6S",       //
                              @"iPhone8,2" :@"iPhone 6S Plus",  //
                              @"iPad4,1"   :@"iPad Air",        // 5th Generation iPad (iPad Air) - Wifi
                              @"iPad4,2"   :@"iPad Air",        // 5th Generation iPad (iPad Air) - Cellular
                              @"iPad4,4"   :@"iPad Mini",       // (2nd Generation iPad Mini - Wifi)
                              @"iPad4,5"   :@"iPad Mini",       // (2nd Generation iPad Mini - Cellular)
                              @"iPad4,7"   :@"iPad Mini"        // (3rd Generation iPad Mini - Wifi (model A1599))
                              };
    }

    NSString* deviceName = [deviceNamesByCode objectForKey:code];

    if (!deviceName) {
        // Not found on database. At least guess main device type from string contents:

        if ([code rangeOfString:@"iPod"].location != NSNotFound) {
            deviceName = @"iPod Touch";
        }
        else if([code rangeOfString:@"iPad"].location != NSNotFound) {
            deviceName = @"iPad";
        }
        else if([code rangeOfString:@"iPhone"].location != NSNotFound){
            deviceName = @"iPhone";
        }
        else {
            deviceName = @"Unknown";
        }
    }
    
    return deviceName;
}

+ (DeviceModel)deviceModel {

    if (IS_IPHONE_4_OR_LESS) {
        return DeviceModel4OrLess;
    }

    if (IS_IPHONE_5) {
        return DeviceModel5;
    }

    if (IS_IPHONE_6) {
        return DeviceModel6;
    }

    if (IS_IPHONE_6P) {
        return DeviceModel6Plus;
    }

    return DeviceModelUnsupported;
}

+ (NSString *)osVersionString {

    // SOURCE: http://stackoverflow.com/questions/3339722/how-to-check-ios-version
    NSOperatingSystemVersion osVersion = [[NSProcessInfo processInfo] operatingSystemVersion];
    NSString *oSVersionString = [NSString stringWithFormat:@"%ld.%ld.%ld",osVersion.majorVersion, osVersion.minorVersion, osVersion.patchVersion];
    return oSVersionString;
}

+ (NSDictionary *)jsonDictionary {

    NSMutableDictionary *dict = [@{
                                   APIParamSessionDeviceType : [self deviceType],
                                   APIParamSessionOSVersion  : [self osVersionString] } mutableCopy];

    if ([self deviceToken]) {
        [dict setObject:[self deviceToken] forKey:APIParamSessionDeviceToken];
    }
    return [dict copy];
}

@end
