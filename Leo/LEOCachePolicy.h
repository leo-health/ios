//
//  LEOCachePolicy.h
//  Leo
//
//  Created by Adam Fanslau on 7/6/16.
//  Copyright © 2016 Leo Health. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, LEOCachePolicyGET) {
    LEOCachePolicyGETCacheOnly,
    LEOCachePolicyGETNetworkOnly,
    LEOCachePolicyGETCacheElseGETNetwork,
    LEOCachePolicyGETCacheElseGETNetworkThenPUTCache,
    LEOCachePolicyGETNetworkThenPUTCache,
    LEOCachePolicyGETNetworkElseGETCache,
    LEOCachePolicyGETNetworkThenPUTCacheElseGETCache,
};

typedef NS_ENUM(NSUInteger, LEOCachePolicyPOST) {
    LEOCachePolicyPOSTCacheOnly,
    LEOCachePolicyPOSTNetworkOnly,
    LEOCachePolicyPOSTNetworkThenPOSTCache,
    LEOCachePolicyPOSTCacheThenPOSTNetwork,
    LEOCachePolicyPOSTNetworkThenPUTCache,
};

typedef NS_ENUM(NSUInteger, LEOCachePolicyPUT) {
    LEOCachePolicyPUTCacheOnly,
    LEOCachePolicyPUTNetworkOnly,
    LEOCachePolicyPUTCacheThenPUTNetwork,
    LEOCachePolicyPUTNetworkThenPUTCache,
    LEOCachePolicyPUTCacheThenPOSTNetwork,
};

typedef NS_ENUM(NSUInteger, LEOCachePolicyDESTROY) {
    LEOCachePolicyDESTROYCacheOnly,
    LEOCachePolicyDESTROYNetworkOnly,
    LEOCachePolicyDESTROYCacheThenDESTROYNetwork,
    LEOCachePolicyDESTROYNetworkThenDESTROYCache,
};

static const LEOCachePolicyGET defaultGET = LEOCachePolicyGETNetworkThenPUTCache;
static const LEOCachePolicyPUT defaultPUT = LEOCachePolicyPUTNetworkThenPUTCache;
static const LEOCachePolicyPOST defaultPOST = LEOCachePolicyPOSTNetworkThenPOSTCache;
static const LEOCachePolicyDESTROY defaultDESTROY = LEOCachePolicyDESTROYNetworkThenDESTROYCache;

@interface LEOCachePolicy : NSObject

@property LEOCachePolicyGET get;
@property LEOCachePolicyPUT put;
@property LEOCachePolicyPOST post;
@property LEOCachePolicyDESTROY destroy;

/*

 TODO: find a better way to handle cache policy logic. use something like before block, after block, if error block
 
 */

+ (instancetype)cacheOnly;
+ (instancetype)networkOnly;

@end
