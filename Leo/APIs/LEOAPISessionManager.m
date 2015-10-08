    //
//  LeoAPISessionManager.m
//  Leo
//
//  Created by Zachary Drossman on 8/21/15.
//  Copyright (c) 2015 Leo Health. All rights reserved.
//

#import "LEOAPISessionManager.h"
#import "Configuration.h"
#import "LEOCredentialStore.h"
#import "SessionUser.h"

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
    
    if (!params) {
        params = [[NSDictionary alloc] init];
    }
    
    NSURLSessionDataTask *task = [self GET:urlString parameters:[self authenticatedParamsWithParams:params] success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)task.response;
        
        if (httpResponse.statusCode == 200) {
            NSLog(@"Received HTTP %ld - %@", (long)httpResponse.statusCode, responseObject);
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

- (NSURLSessionDataTask *)unauthenticatedGETRequestForJSONDictionaryFromAPIWithEndpoint:(NSString *)urlString params:(NSDictionary *)params completion:(void (^)(NSDictionary *rawResults, NSError *error))completionBlock {
    
    __block NSString *urlStringBlock = [urlString copy];
    __block NSDictionary *paramsBlock = params;
    
    if (!params) {
        params = [[NSDictionary alloc] init];
    }
    
    NSURLSessionDataTask *task = [self GET:urlString parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)task.response;
        
        if (httpResponse.statusCode == 200) {
            NSLog(@"Received HTTP %ld - %@", (long)httpResponse.statusCode, responseObject);
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
    
    NSURLSessionDataTask *task = [self POST:urlString parameters:[self authenticatedParamsWithParams:params] success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)task.response;

        if (httpResponse.statusCode == 200) {
            NSLog(@"Received HTTP %ld - %@", (long)httpResponse.statusCode, responseObject);
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock(responseObject, nil);
            });
        } else {
            NSLog(@"Received HTTP %ld - %@", (long)httpResponse.statusCode, responseObject);
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock(responseObject, nil);
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


- (NSURLSessionDataTask *)standardPUTRequestForJSONDictionaryToAPIWithEndpoint:(NSString *)urlString params:(NSDictionary *)params completion:(void (^)(NSDictionary *rawResults, NSError *error))completionBlock {
    
    NSURLSessionDataTask *task = [self PUT:urlString parameters:[self authenticatedParamsWithParams:params] success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)task.response;
        
        if (httpResponse.statusCode == 200) {
            NSLog(@"Received HTTP %ld - %@", (long)httpResponse.statusCode, responseObject);
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock(responseObject, nil);
            });
        } else {
            NSLog(@"Received HTTP %ld - %@", (long)httpResponse.statusCode, responseObject);
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock(responseObject, nil);
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

- (NSURLSessionDataTask *)unauthenticatedPOSTRequestForJSONDictionaryToAPIWithEndpoint:(NSString *)urlString params:(NSDictionary *)params completion:(void (^)(NSDictionary *rawResults, NSError *error))completionBlock {
    
    NSURLSessionDataTask *task = [self POST:urlString parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)task.response;
        
        if (httpResponse.statusCode == 200) {
            NSLog(@"Received HTTP %ld - %@", (long)httpResponse.statusCode, responseObject);
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock(responseObject, nil);
            });
        } else {
            NSLog(@"Received HTTP %ld - %@", (long)httpResponse.statusCode, responseObject);
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock(responseObject, nil);
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
    
    NSURLSessionDataTask *task = [self DELETE:urlString parameters:[self authenticatedParamsWithParams:params] success:^(NSURLSessionDataTask *task, id responseObject) {
        
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

- (NSMutableDictionary *)authenticatedParamsWithParams:(NSDictionary *)params {
    
    NSMutableDictionary *authenticatedParams = [params mutableCopy];
    
    [authenticatedParams setValue:[self authToken] forKey:APIParamToken];
    
    return authenticatedParams;
}


//FIXME: To be updated with the actual user token via keychain at some point.
- (NSString *)authToken {
    return [[SessionUser currentUser].credentialStore authToken];;
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
