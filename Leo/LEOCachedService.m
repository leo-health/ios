//
//  LEOCachedService.m
//  Leo
//
//  Created by Adam Fanslau on 6/28/16.
//  Copyright © 2016 Leo Health. All rights reserved.
//

#import "LEOCachedService.h"
#import "LEOCachedDataStore.h"
#import "LEONetworkStore.h"

typedef NS_ENUM(NSUInteger, LEORequestMethod) {
    LEORequestMethodGET,
    LEORequestMethodPUT,
};

@implementation LEOCachedService

+ (instancetype)serviceWithCachePolicy:(LEOCachePolicy *)cachePolicy {

    LEOCachedService *service = [self new];
    service.cachePolicy = cachePolicy;
    return service;
}

- (instancetype)init {

    self = [super init];
    if (self) {
        _cache = [LEOCachedDataStore sharedInstance];
        _network = [LEONetworkStore new];
    }
    
    return self;
}

- (void(^)(id, NSError*))safeCompletion:(void(^)(id, NSError*))completion {

    return ^(id response, NSError *error){
        if (completion) {
            completion(response, error);
        }
    };
}

- (LEOPromise *)get:(NSString *)endpoint params:(NSDictionary *)params completion:(void (^)(NSDictionary *, NSError *))completion {

    LEOCachePolicyGET cachePolicy = self.cachePolicy.get;
    NSDictionary *cacheResponse;

    if (cachePolicy == LEOCachePolicyGETCacheOnly ||
        cachePolicy == LEOCachePolicyGETCacheElseGETNetwork ||
        cachePolicy == LEOCachePolicyGETCacheElseGETNetworkThenPUTCache) {

        cacheResponse = [self.cache get:endpoint params:params];
    }

    if (cachePolicy == LEOCachePolicyGETCacheElseGETNetwork ||
        cachePolicy == LEOCachePolicyGETCacheElseGETNetworkThenPUTCache) {
        if (cacheResponse) {
            [self safeCompletion:completion](cacheResponse, nil);
            return [LEOPromise finishedCompletion];
        }
    }

    if (cachePolicy == LEOCachePolicyGETNetworkOnly ||
        cachePolicy == LEOCachePolicyGETNetworkThenPUTCache ||
        cachePolicy == LEOCachePolicyGETCacheElseGETNetwork ||
        cachePolicy == LEOCachePolicyGETCacheElseGETNetworkThenPUTCache ||
        cachePolicy == LEOCachePolicyGETNetworkThenPUTCacheElseGETCache ||
        cachePolicy == LEOCachePolicyGETNetworkElseGETCache) {

        return [self.network get:endpoint params:params completion:^(NSDictionary *networkResponse, NSError *networkError) {

            if (cachePolicy == LEOCachePolicyGETNetworkThenPUTCache ||
                cachePolicy == LEOCachePolicyGETCacheElseGETNetworkThenPUTCache ||
                cachePolicy == LEOCachePolicyGETNetworkThenPUTCacheElseGETCache) {
                [self.cache put:endpoint params:networkResponse];
            }

            if (networkError && cachePolicy == LEOCachePolicyGETNetworkElseGETCache) {
                [self safeCompletion:completion](cacheResponse, networkError);
            }
            else {
                [self safeCompletion:completion](networkResponse, networkError);
            }
        }];
    }

    if (self.cachePolicy == LEOCachePolicyGETCacheOnly) {
        [self safeCompletion:completion](cacheResponse, nil);
        return [LEOPromise finishedCompletion];
    }

    return nil;
}

- (LEOPromise *)post:(NSString *)endpoint params:(NSDictionary *)params completion:(void (^)(NSDictionary *, NSError *))completion {

    LEOCachePolicyPOST cachePolicy = self.cachePolicy.post;
    NSDictionary *response;

    if (cachePolicy == LEOCachePolicyPOSTCacheOnly ||
        cachePolicy == LEOCachePolicyPOSTCacheThenPOSTNetwork) {

        response = [self.cache post:endpoint params:params];
    }

    if (cachePolicy == LEOCachePolicyPOSTCacheThenPOSTNetwork ||
        cachePolicy == LEOCachePolicyPOSTNetworkThenPOSTCache ||
        cachePolicy == LEOCachePolicyPOSTNetworkThenPUTCache ||
        cachePolicy == LEOCachePolicyPOSTNetworkOnly) {

        return [self.network post:endpoint params:params completion:^(NSDictionary *response, NSError *error) {

            if (!error) {

                if (cachePolicy == LEOCachePolicyPOSTNetworkThenPOSTCache) {

                    [self.cache post:endpoint params:response];
                }

                if (cachePolicy == LEOCachePolicyPOSTNetworkThenPUTCache) {

                    [self.cache put:endpoint params:response];
                }
            }
            [self safeCompletion:completion](response, error);
        }];
    }

    if (self.cachePolicy == LEOCachePolicyPOSTCacheOnly) {
        [self safeCompletion:completion](response, nil);
        return [LEOPromise finishedCompletion];
    }

    return nil;
}

- (LEOPromise *)put:(NSString *)endpoint params:(NSDictionary *)params completion:(void (^)(NSDictionary *, NSError *))completion {

    LEOCachePolicyPUT cachePolicy = self.cachePolicy.put;
    NSDictionary *response;

    if (cachePolicy == LEOCachePolicyPUTCacheOnly ||
        cachePolicy == LEOCachePolicyPUTCacheThenPOSTNetwork ||
        cachePolicy == LEOCachePolicyPUTCacheThenPUTNetwork) {

        response = [self.cache put:endpoint params:params];
    }

    if (cachePolicy == LEOCachePolicyPUTNetworkThenPUTCache ||
        cachePolicy == LEOCachePolicyPUTNetworkOnly ||
        cachePolicy == LEOCachePolicyPUTCacheThenPUTNetwork) {

        return [self.network put:endpoint params:params completion:^(NSDictionary *response, NSError *error) {

            if (!error) {

                if (cachePolicy == LEOCachePolicyPUTNetworkThenPUTCache) {

                    [self.cache put:endpoint params:response];
                }
            }
            [self safeCompletion:completion](response, error);
        }];
    }

    if (cachePolicy == LEOCachePolicyPUTCacheThenPOSTNetwork) {

        // ????: could argue that the ThenPOSTNetwork should happen in the background after returning
        return [self.network post:endpoint params:params completion:completion];
    }

    if (cachePolicy == LEOCachePolicyPUTCacheOnly) {
        
        [self safeCompletion:completion](response, nil);
        return [LEOPromise finishedCompletion];
    }

    return nil;
}

- (LEOPromise *)destroy:(NSString *)endpoint params:(NSDictionary *)params completion:(void (^)(NSDictionary *, NSError *))completion {

    LEOCachePolicyDESTROY cachePolicy = self.cachePolicy.destroy;
    NSDictionary *response;

    if (cachePolicy == LEOCachePolicyDESTROYCacheOnly ||
        cachePolicy == LEOCachePolicyDESTROYCacheThenDESTROYNetwork) {

        response = [self.cache destroy:endpoint params:params];
    }

    if (cachePolicy == LEOCachePolicyPUTNetworkOnly ||
        cachePolicy == LEOCachePolicyDESTROYNetworkThenDESTROYCache ||
        cachePolicy == LEOCachePolicyDESTROYCacheThenDESTROYNetwork) {

        return [self.network destroy:endpoint params:params completion:^(NSDictionary *response, NSError *error) {

            if (!error) {

                if (cachePolicy == LEOCachePolicyDESTROYNetworkThenDESTROYCache) {

                    [self.cache destroy:endpoint params:response];
                }
            }
            [self safeCompletion:completion](response, error);
        }];
    }

    if (cachePolicy == LEOCachePolicyDESTROYCacheOnly) {

        [self safeCompletion:completion](response, nil);
        return [LEOPromise finishedCompletion];
    }
    
    return nil;
}

// TODO: Follow same cache policy logic when the network can be performed synchronously

- (NSDictionary *)get:(NSString *)endpoint params:(NSDictionary *)params {

    return [self.cache get:endpoint params:params];
}

- (NSDictionary *)post:(NSString *)endpoint params:(NSDictionary *)params {

    return [self.cache post:endpoint params:params];
}

- (NSDictionary *)put:(NSString *)endpoint params:(NSDictionary *)params {

    return [self.cache put:endpoint params:params];
}

- (NSDictionary *)destroy:(NSString *)endpoint params:(NSDictionary *)params {

    return [self.cache destroy:endpoint params:params];
}


@end
