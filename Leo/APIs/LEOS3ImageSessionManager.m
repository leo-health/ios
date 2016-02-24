//
//  LEOs3SessionMananger.m
//  Leo
//
//  Created by Zachary Drossman on 8/21/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import "LEOS3ImageSessionManager.h"
#import "Configuration.h"

@implementation LEOS3ImageSessionManager

+ (LEOS3ImageSessionManager *)sharedClient {
    static LEOS3ImageSessionManager *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{

        _sharedClient = [[LEOS3ImageSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
        _sharedClient.responseSerializer = [AFImageResponseSerializer serializer];
    });
    return _sharedClient;
}

//TODO: Technically there is no difference right now between the two methods below; however, the presigned token could arguably be available here instead of in the service class, so I am leaving in both methods for the time-being. We can decide on what we would like to do with that at a later time.
- (NSURLSessionDataTask *)presignedGETRequestForImageFromS3WithURL:(NSString *)urlString params:(NSDictionary *)params completion:(void (^)(UIImage *rawImage, NSError *error))completionBlock {

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
