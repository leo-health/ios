//
//  LEOS3JSONSessionManager.m
//  Leo
//
//  Created by Zachary Drossman on 2/24/16.
//  Copyright © 2016 Leo Health. All rights reserved.
//

#import "LEOS3JSONSessionManager.h"

@implementation LEOS3JSONSessionManager

+ (LEOS3JSONSessionManager *)sharedClient {
    static LEOS3JSONSessionManager *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{

        _sharedClient = [[LEOS3JSONSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
        _sharedClient.responseSerializer = [AFJSONResponseSerializer serializer];
        _sharedClient.requestSerializer.cachePolicy = NSURLRequestReloadIgnoringCacheData;
    });
    return _sharedClient;
}

- (NSURLSessionDataTask *)unauthenticatedGETRequestForJSONDictionaryFromS3WithURLString:(NSString *)urlString params:(NSDictionary *)params completion:(void (^)(NSDictionary *rawResults, NSError *error))completionBlock {

    __block NSString *urlStringBlock = [urlString copy];
    __block NSDictionary *paramsBlock = params;

    NSURLSessionDataTask *task = [self GET:urlString parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {

        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)task.response;

        if (httpResponse.statusCode == 200) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock(responseObject, nil);
            });
        } else {
            NSLog(@"Received HTTP %ld - %@", (long)httpResponse.statusCode, responseObject);
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock(nil, nil);
            });
        }

    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@",paramsBlock);
        NSLog(@"%@",urlStringBlock);
        NSLog(@"Fail: %@",error.localizedDescription);
        NSLog(@"Fail: %@",error.localizedFailureReason);
        dispatch_async(dispatch_get_main_queue(), ^{
            completionBlock(nil, error);
        });
    }];
    
    return task;
    
}


@end
