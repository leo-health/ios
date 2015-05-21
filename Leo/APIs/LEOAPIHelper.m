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

+ (void)standardGETRequestForJSONDictionaryFromAPIWithURL:(NSString *)urlString params:(NSDictionary *)params completion:(void (^)(NSDictionary * __nonnull rawResults))completionBlock {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.responseSerializer = [[AFHTTPResponseSerializer alloc] init];
    
    [manager GET:urlString parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSDictionary *rawResults = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        completionBlock(rawResults);
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"Fail: %@",error.localizedDescription);
        NSLog(@"Fail: %@",error.localizedFailureReason);
        
        //FIXME: Deal with all sorts of errors. Replace with DLog!
    }];
}

+ (void)standardPOSTRequestForJSONDictionaryFromAPIWithURL:(NSString *)urlString params:(NSDictionary *)params completion:(void (^)(NSDictionary * __nonnull rawResults))completionBlock {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.responseSerializer = [[AFHTTPResponseSerializer alloc] init];
    
    [manager POST:urlString parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSError *error;
        NSDictionary *rawResults = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:&error];
        completionBlock(rawResults);
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"Fail: %@",error.localizedDescription);
        NSLog(@"Fail: %@",error.localizedFailureReason);
        
        //FIXME: Deal with all sorts of errors. Replace with DLog!
    }];
}

@end
