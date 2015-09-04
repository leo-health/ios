//
//  LeoAPISessionManager.m
//  Leo
//
//  Created by Zachary Drossman on 8/21/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import "LEOAPISessionManager.h"
#import "Configuration.h"

@implementation LEOAPISessionManager

+ (LEOAPISessionManager *)sharedClient {
    static LEOAPISessionManager *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        NSString *urlString = [NSString stringWithFormat:@"%@/%@",[Configuration APIEndpointWithHTTPSProtocol],[Configuration APIVersion]];

        NSURL *baseURL = [NSURL URLWithString:urlString];
        
        _sharedClient = [[LEOAPISessionManager alloc] initWithBaseURL:baseURL
                                         sessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];

        _sharedClient.responseSerializer = [AFJSONResponseSerializer serializer];
    });
    
    return _sharedClient;
}

- (NSURLSessionDataTask *)standardGETRequestForJSONDictionaryFromAPIWithEndpoint:(NSString *)urlString params:(NSDictionary *)params completion:(void (^)(NSDictionary *rawResults, NSError *error))completionBlock {
    
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

- (NSURLSessionDataTask *)standardPOSTRequestForJSONDictionaryToAPIWithEndpoint:(NSString *)urlString params:(NSDictionary *)params completion:(void (^)(NSDictionary *rawResults, NSError *error))completionBlock {
    
    NSURLSessionDataTask *task = [self POST:urlString parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        
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
        NSLog(@"Fail: %@",error.localizedDescription);
        NSLog(@"Fail: %@",error.localizedFailureReason);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            completionBlock(nil, error);
        });
    }];
    
    return task;
}

- (NSURLSessionDataTask *)standardDELETERequestForJSONDictionaryToAPIWithEndpoint:(NSString *)urlString params:(NSDictionary *)params completion:(void (^)(NSDictionary *rawResults, NSError *error))completionBlock {
    
    NSURLSessionDataTask *task = [self DELETE:urlString parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        
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
        NSLog(@"Fail: %@",error.localizedDescription);
        NSLog(@"Fail: %@",error.localizedFailureReason);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            completionBlock(nil, error);
        });
    }];
    
    return task;
}


@end
