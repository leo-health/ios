//
//  LEOModelService.m
//  Leo
//
//  Created by Adam Fanslau on 7/13/16.
//  Copyright © 2016 Leo Health. All rights reserved.
//

#import "LEOModelService.h"

@interface LEOModelService ()

@property (strong, nonatomic) LEOCachedService *cachedService;

@end

@implementation LEOModelService

+ (instancetype)serviceWithCachePolicy:(LEOCachePolicy *)cachePolicy {

    LEOModelService *service = [self new];
    service.cachedService = [LEOCachedService serviceWithCachePolicy:cachePolicy];
    return service;
}

- (LEOCachedService *)cachedService {

    if (!_cachedService) {
        _cachedService = [LEOCachedService serviceWithCachePolicy:[LEOCachePolicy new]];
    }

    return _cachedService;
}


@end
