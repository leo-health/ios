//
//  LEOAPIHelper.m
//  Leo
//
//  Created by Zachary Drossman on 5/18/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import "LEOAPIHelper.h"
#import <AFNetworking.h>

@implementation LEOAPIHelper

NSString *const LEOErrorDomain = @"LEOApiErrorDomain";

+ (void)standardGETRequestForJSONDictionaryFromAPIWithURL:(NSString *)urlString params:(NSDictionary *)params completion:(void (^)(NSDictionary *rawResults, NSError *error))completionBlock {
    
    __block NSString *urlStringBlock = [urlString copy];
    __block NSDictionary *paramsBlock = params;
    
    [[AFHTTPSessionManager manager] GET:urlString parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)task.response;
        
        if (httpResponse.statusCode == 200) {
        //NSDictionary *rawResults = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        completionBlock(responseObject, nil);
        } else {
            NSLog(@"Received HTTP %ld - %@", (long)httpResponse.statusCode, responseObject);
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@",paramsBlock);
        NSLog(@"%@",urlStringBlock);
        NSLog(@"Fail: %@",error.localizedDescription);
        NSLog(@"Fail: %@",error.localizedFailureReason);
        
        completionBlock(nil, error);

        //TODO: Deal with all sorts of errors. Replace with DLog!
    }];
}

+ (void)standardGETRequestForDataFromS3WithURL:(NSString *)urlString params:(NSDictionary *)params completion:(void (^)(NSData *rawResults, NSError *error))completionBlock {
    
    [[AFHTTPSessionManager manager] GET:urlString parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        
        completionBlock(responseObject, nil);

        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"Fail: %@",error.localizedDescription);
        NSLog(@"Fail: %@",error.localizedFailureReason);
        
        completionBlock(nil, error);

        //TODO: Deal with all sorts of errors. Replace with DLog!
    }];

    
}


+ (void)standardPOSTRequestForJSONDictionaryFromAPIWithURL:(NSString *)urlString params:(NSDictionary *)params completion:(void (^)(NSDictionary *rawResults, NSError *error))completionBlock {
    
    [[AFHTTPSessionManager manager] POST:urlString parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSError *error;
        NSDictionary *rawResults = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:&error];
        completionBlock(rawResults, nil);
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"Fail: %@",error.localizedDescription);
        NSLog(@"Fail: %@",error.localizedFailureReason);
        
        completionBlock(nil, error);

        //TODO: Deal with all sorts of errors. Replace with DLog!
    }];
}


@end
