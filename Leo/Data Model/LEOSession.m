//
//  LEOSession.m
//  Leo
//
//  Created by Zachary Drossman on 5/18/16.
//  Copyright © 2016 Leo Health. All rights reserved.
//

#import "LEOSession.h"
#import "LEODevice.h"
#import "Guardian.h"
#import "LEOUserService.h"
#import "LEOCredentialStore.h"
#import "Configuration.h"
#import "LEOCachedDataStore.h"
#import "Family.h"
#import "LEOApp.h"

@interface LEOSession ()

@end

@implementation LEOSession

+ (NSDictionary *)serializeToJSON {

    NSMutableDictionary *json = [[LEODevice serializeToJSON] mutableCopy];
    json[APIParamSessionAppVersion] = [LEOApp appVersion];

    return [json copy];
}


@end
