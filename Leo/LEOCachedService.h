//
//  LEOCachedService.h
//  Leo
//
//  Created by Adam Fanslau on 6/28/16.
//  Copyright © 2016 Leo Health. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LEOAsyncDataSource.h"
#import "LEOSyncronousDataSource.h"
#import "LEOCachePolicy.h"

@class LEOCachedDataStore, LEONetworkStore;

@interface LEOCachedService : NSObject<LEOAsyncDataSource, LEOSyncronousDataSource>

@property LEOCachedDataStore *cache;
@property LEONetworkStore *network;
@property LEOCachePolicy *cachePolicy;

+ (instancetype)serviceWithCachePolicy:(LEOCachePolicy *)cachePolicy;

@end
