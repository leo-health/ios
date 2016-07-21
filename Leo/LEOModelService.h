//
//  LEOModelService.h
//  Leo
//
//  Created by Adam Fanslau on 7/13/16.
//  Copyright © 2016 Leo Health. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LEOCachedService.h"
#import "LEOPromise.h"

@interface LEOModelService : NSObject {

    @protected LEOCachedService *_cachedService;
}

@property (strong, nonatomic, readonly) LEOCachedService *cachedService;

+ (instancetype)serviceWithCachePolicy:(LEOCachePolicy *)cachePolicy;

@end
