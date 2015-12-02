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
#import "Configuration.h"

@implementation LEOAPISessionManager

+ (LEOAPISessionManager *)sharedClient {
    static LEOAPISessionManager *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        NSString *urlString = [NSString stringWithFormat:@"%@/%@",[Configuration APIEndpointWithProtocol],[Configuration APIVersion]];

        NSURL *baseURL = [NSURL URLWithString:urlString];
        
        _sharedClient = [[LEOAPISessionManager alloc] initWithBaseURL:baseURL
                                         sessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];

        _sharedClient.responseSerializer = [AFJSONResponseSerializer serializer];
    
        AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
        securityPolicy.validatesDomainName = NO;
        securityPolicy.allowInvalidCertificates = YES;

        NSString *certificatePath = [[NSBundle mainBundle] pathForResource:[Configuration selfSignedCertificate] ofType:@"cer"];
        NSData *certificateData = [[NSData alloc] initWithContentsOfFile:certificatePath];
        securityPolicy.pinnedCertificates = @[certificateData];
        _sharedClient.securityPolicy = securityPolicy;
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
        
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)task.response;

        if (httpResponse.statusCode == 401) {
            
            [SessionUser logout];
        }
        
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


- (NSURLSessionDataTask *)unauthenticatedImageGETRequestForJSONDictionaryFromAPIWithEndpoint:(NSString *)urlString params:(NSDictionary *)params completion:(void (^)(UIImage *rawImage, NSError *error))completionBlock {
    
    __block NSString *urlStringBlock = [urlString copy];
    __block NSDictionary *paramsBlock = params;
    self.responseSerializer = [AFImageResponseSerializer serializer];
    
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
        
        self.responseSerializer = [AFJSONResponseSerializer serializer];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@",paramsBlock);
        NSLog(@"%@",urlStringBlock);
        NSLog(@"Fail: %@",error.localizedDescription);
        NSLog(@"Fail: %@",error.localizedFailureReason);
        dispatch_async(dispatch_get_main_queue(), ^{
            completionBlock(nil, error);
        });
        
        self.responseSerializer = [AFJSONResponseSerializer serializer];

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
        
        [self formattedErrorFromError:&error];

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
        
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)task.response;

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
    
    if (!params) {
        params = [NSDictionary new];
    }
    
    NSMutableDictionary *authenticatedParams = [params mutableCopy];
    
    [authenticatedParams setValue:[LEOAPISessionManager authToken] forKey:APIParamToken];
    
    return authenticatedParams;
}


//MARK: First pass at "serializer" method for NSError creation from JSON dictionary provided by our API
- (void)formattedErrorFromError:(NSError * __autoreleasing *)error {
    
    NSError *errorPointer = *error;
    NSData *data = errorPointer.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
    
    NSError *serializationError;
    NSDictionary *responseErrorDictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    
    NSString *errorDescription = responseErrorDictionary[@"message"][@"error_description"];
    NSString *errorSuggestion = responseErrorDictionary[@"message"][@"recovery_suggestion"];
    NSString *errorFailureReason = responseErrorDictionary[@"message"][@"error_message"];
    
    
    NSMutableDictionary *formattedErrorDictionary = [NSMutableDictionary new];
    
    if (errorDescription) {
        formattedErrorDictionary[NSLocalizedDescriptionKey] = errorDescription;
    }
    
    if (errorSuggestion) {
        formattedErrorDictionary[NSLocalizedRecoverySuggestionErrorKey] = errorSuggestion;
    }
    
    if (errorFailureReason) {
        formattedErrorDictionary[NSLocalizedFailureReasonErrorKey] = errorFailureReason;
    }
        
    if (!serializationError) {
        
        NSInteger errorCode = [responseErrorDictionary[@"message"][@"error_code"] integerValue];
        *error = [NSError errorWithDomain:errorPointer.domain code:errorCode userInfo:formattedErrorDictionary];
    }
}

//FIXME: To be updated with the actual user token via keychain at some point.
+ (NSString *)authToken {
    return [SessionUser authToken];;
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
