//
//  LEOs3SessionMananger.m
//  Leo
//
//  Created by Zachary Drossman on 8/21/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import "LEOS3SessionManager.h"
#import "Configuration.h"

@implementation LEOS3SessionManager

+ (LEOS3SessionManager *)sharedClient {
    static LEOS3SessionManager *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{

        _sharedClient = [[LEOS3SessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
        _sharedClient.responseSerializer = [AFImageResponseSerializer serializer];
    });
    
    return _sharedClient;
}

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
